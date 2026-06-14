#!/usr/bin/env bash
# kb-drift-check.sh — kiểm drift MECHANICAL (tất định, không cần AI/API).
# Quy tắc: nếu diff có sửa file CODE mà KHÔNG sửa file knowledge nào trong .kb-local/
#          → cảnh báo "có thể quên cập nhật knowledge".
# Dùng được ở: pre-push hook (local), GitLab CI, GitHub Actions.
# Bản này được VENDOR vào .kb-local/ci/ của project (vì symlink .kb không có trên CI runner).
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

# Fallback nếu không có ref đích
if ! git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  BASE="$(git rev-parse --verify HEAD~1 2>/dev/null || echo HEAD)"
fi
MB="$(git merge-base "$BASE" HEAD 2>/dev/null || echo "$BASE")"

CHANGED="$(git diff --name-only "$MB"...HEAD 2>/dev/null || git diff --name-only "$BASE")"
if [ -z "${CHANGED//[[:space:]]/}" ]; then
  echo "kb-drift: không có thay đổi để kiểm. ✓"; exit 0
fi

KNOWLEDGE="$(printf '%s\n' "$CHANGED" | grep -E '^\.kb-local/' || true)"
# CODE = không phải knowledge, không phải file trỏ/doc ở gốc, không phải *.md/*.txt
CODE="$(printf '%s\n' "$CHANGED" \
  | grep -vE '^\.kb-local/' \
  | grep -vE '^(AGENTS\.md|CLAUDE\.md|GEMINI\.md|\.cursorrules|\.windsurfrules|\.clinerules|\.github/copilot-instructions\.md|README\.md)$' \
  | grep -vE '\.(md|txt)$' || true)"

if [ -n "${CODE//[[:space:]]/}" ] && [ -z "${KNOWLEDGE//[[:space:]]/}" ]; then
  echo "=============================================================="
  echo "⚠️  kb-drift: CODE thay đổi nhưng KHÔNG cập nhật knowledge (.kb-local/)"
  echo "--------------------------------------------------------------"
  printf '%s\n' "$CODE" | sed 's/^/   • /'
  echo "--------------------------------------------------------------"
  echo "Nếu thay đổi đụng module / public API / luồng / quyết định kiến trúc,"
  echo "hãy cập nhật .kb-local/ theo checklist: templates/kb-acceptance-checklist.md"
  echo "Phân tích sâu bằng agent (tùy chọn): prompts/review-kb-drift.md"
  echo "=============================================================="
  if [ "$STRICT" -eq 1 ]; then exit 1; fi
  echo "(chế độ cảnh báo — không chặn. Thêm --strict để chặn.)"
  exit 0
fi

echo "kb-drift: knowledge & code nhất quán (hoặc thay đổi chỉ là tài liệu). ✓"
exit 0
