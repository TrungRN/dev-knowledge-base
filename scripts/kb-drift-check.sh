#!/usr/bin/env bash
# kb-drift-check.sh — kiểm drift MECHANICAL (tất định, không cần AI/API).
#
# Từ giai đoạn này, knowledge .kb-local/ nằm trong KB trung tâm:
#   projects/<tên-project>/.kb-local/
# Project con chỉ giữ symlink .kb-local. Do đó drift check cần so sánh:
#   • code thay đổi trong repo project con
#   • knowledge thay đổi trong repo KB trung tâm (cùng folder projects/<tên>/.kb-local/)
#
# Quy tắc: nếu diff có sửa file CODE mà KHÔNG sửa file knowledge nào
#          → cảnh báo "có thể quên cập nhật knowledge".
#
# Dùng được ở: local trước khi tạo MR. CI cần checkout kèm KB trung tâm.
#
# Dùng: kb-drift-check.sh [BASE_REF] [--strict]
#   BASE_REF : nhánh đích để so (mặc định: origin/main)
#   --strict : trả mã 1 nếu có drift (để CHẶN). Mặc định chỉ cảnh báo (mã 0).
set -uo pipefail

BASE="origin/main"
STRICT=0
for a in "$@"; do
  case "$a" in
    --strict) STRICT=1 ;;
    "") ;;
    *) BASE="$a" ;;
  esac
done

# ---------- Xác định project con ----------
PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROJ_NAME="$(basename "$PROJ_ROOT")"

# ---------- Xác định KB trung tâm ----------
KB_DIR=""
if [ -L "$PROJ_ROOT/.kb" ]; then
  KB_DIR="$(readlink "$PROJ_ROOT/.kb" 2>/dev/null || true)"
fi
if [ -z "$KB_DIR" ] || [ ! -d "$KB_DIR/.git" ]; then
  # Fallback: thư mục anh em tên dev-knowledge-base
  KB_DIR="$(cd "$PROJ_ROOT/.." 2>/dev/null && cd "dev-knowledge-base" 2>/dev/null && pwd)" || true
fi
if [ -z "$KB_DIR" ] || [ ! -d "$KB_DIR/.git" ]; then
  echo "⚠️  kb-drift: không tìm thấy KB trung tâm (.kb symlink hoặc ../dev-knowledge-base)." >&2
  echo "   Drift check cần cả repo project và repo KB. Bỏ qua." >&2
  exit 0
fi

KNOWLEDGE_PREFIX="projects/$PROJ_NAME/.kb-local"

# ---------- Helper: tìm merge-base an toàn ----------
merge_base() {
  local repo="$1"
  local ref="$2"
  if git -C "$repo" rev-parse --verify "$ref" >/dev/null 2>&1; then
    git -C "$repo" merge-base "$ref" HEAD 2>/dev/null || echo "$ref"
  else
    git -C "$repo" rev-parse --verify HEAD~1 2>/dev/null || echo "HEAD"
  fi
}

MB_PROJ="$(merge_base "$PROJ_ROOT" "$BASE")"
MB_KB="$(merge_base "$KB_DIR" "$BASE")"

# ---------- Danh sách file thay đổi ----------
CHANGED_PROJ="$(git -C "$PROJ_ROOT" diff --name-only "$MB_PROJ"...HEAD 2>/dev/null || git -C "$PROJ_ROOT" diff --name-only "$BASE")"
CHANGED_KB="$(git -C "$KB_DIR" diff --name-only "$MB_KB"...HEAD -- "$KNOWLEDGE_PREFIX" 2>/dev/null || true)"
# Bổ sung cả thay đổi chưa commit (working tree + staged) trong KB — vì knowledge thường đang sửa dở
_KB_UNTRACKED="$(git -C "$KB_DIR" diff --name-only -- "$KNOWLEDGE_PREFIX" 2>/dev/null || true)"
_KB_STAGED="$(git -C "$KB_DIR" diff --cached --name-only -- "$KNOWLEDGE_PREFIX" 2>/dev/null || true)"
CHANGED_KB_UNCOMMITTED="$(printf '%s\n%s\n' "$_KB_UNTRACKED" "$_KB_STAGED")"

if [ -z "${CHANGED_PROJ//[[:space:]]/}" ] && [ -z "${CHANGED_KB//[[:space:]]/}" ] && [ -z "${CHANGED_KB_UNCOMMITTED//[[:space:]]/}" ]; then
  echo "kb-drift: không có thay đổi để kiểm. ✓"; exit 0
fi

# ---------- Lọc CODE trong project con ----------
CODE="$(printf '%s\n' "$CHANGED_PROJ" \
  | grep -vE '^\.(kb|kb-local)/' \
  | grep -vE '^(AGENTS\.md|CLAUDE\.md|GEMINI\.md|\.cursorrules|\.windsurfrules|\.clinerules|\.github/copilot-instructions\.md|README\.md)$' \
  | grep -vE '\.(md|txt)$' || true)"

# ---------- Lọc KNOWLEDGE trong KB ----------
KNOWLEDGE="$(printf '%s\n%s\n' "$CHANGED_KB" "$CHANGED_KB_UNCOMMITTED" \
  | grep -E "^${KNOWLEDGE_PREFIX}/" \
  | sort -u || true)"

if [ -n "${CODE//[[:space:]]/}" ] && [ -z "${KNOWLEDGE//[[:space:]]/}" ]; then
  echo "=============================================================="
  echo "⚠️  kb-drift: CODE thay đổi nhưng KHÔNG thấy cập nhật knowledge"
  echo "              trong KB trung tâm ($KNOWLEDGE_PREFIX/)"
  echo "--------------------------------------------------------------"
  printf '%s\n' "$CODE" | sed 's/^/   • /'
  echo "--------------------------------------------------------------"
  echo "Nếu thay đổi đụng module / public API / luồng / quyết định kiến trúc,"
  echo "hãy cập nhật $KNOWLEDGE_PREFIX/ trong KB trung tâm,"
  echo "rồi đọc checklist: .kb/templates/kb-acceptance-checklist.md"
  echo "Phân tích sâu bằng agent (tùy chọn): .kb/prompts/review-kb-drift.md"
  echo "=============================================================="
  if [ "$STRICT" -eq 1 ]; then exit 1; fi
  echo "(chế độ cảnh báo — không chặn. Thêm --strict để chặn.)"
  exit 0
fi

echo "kb-drift: knowledge & code nhất quán (hoặc thay đổi chỉ là tài liệu). ✓"
exit 0
