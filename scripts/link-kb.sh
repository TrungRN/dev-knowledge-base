#!/usr/bin/env bash
# link-kb.sh — nối MỘT project vào KB (tập trung Claude Code).
#
# Từ giai đoạn này, project con KHÔNG giữ .kb-local/ trong repo của mình nữa.
# Toàn bộ knowledge riêng project được lưu ở KB trung tâm:
#   <KB>/projects/<TÊN-PROJECT>/.kb-local/
# Project con chỉ giữ lại:
#   • symlink .kb       -> <KB>                         (đường dẫn tuyệt đối)
#   • symlink .kb-local -> <KB>/projects/<TÊN>/.kb-local (đường dẫn tuyệt đối)
#   • CLAUDE.md         -> khối tham chiếu KB + fallback nếu chưa link
#   • .claude/commands/ -> /kb-scan, /kb-drift, /kb-onboard
#
# Migration an toàn: nếu project còn .kb-local/ thật (directory, không phải symlink),
# script copy nội dung vào KB trung tâm, đổi tên cũ thành .kb-local.legacy-<ngày>,
# rồi tạo symlink. Người dùng tự xóa .kb-local.legacy-* sau khi kiểm tra.
#
# (Các agent khác — Gemini/Cursor/Windsurf/Cline/Copilot — tạm bỏ; mở rộng sau khi cần.)
#
# Dùng: link-kb.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
set -euo pipefail
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KB_NAME="$(basename "$KB_DIR")"
TARGET="${1:-$PWD}"
PROJ="$(cd "$TARGET" && pwd)" || { echo "Không tìm thấy: $TARGET" >&2; exit 1; }
if [ "$PROJ" = "$KB_DIR" ]; then echo "  (bỏ qua: đây là chính KB)"; exit 0; fi
cd "$PROJ"
BASE="$(basename "$PROJ")"

CENTRAL_KB_LOCAL="$KB_DIR/projects/$BASE/.kb-local"

# ---------- 1) Chuẩn bị .kb-local/ trong KB trung tâm ----------
mkdir -p "$CENTRAL_KB_LOCAL/adr"
[ -f "$CENTRAL_KB_LOCAL/repo-map.md" ] || { sed "s/<TÊN PROJECT>/$BASE/g" "$KB_DIR/templates/repo-map.md" > "$CENTRAL_KB_LOCAL/repo-map.md"; echo "• skeleton KB project knowledge: projects/$BASE/.kb-local/repo-map.md"; }
[ -f "$CENTRAL_KB_LOCAL/llms.txt" ]    || { sed "s/<TÊN PROJECT>/$BASE/g" "$KB_DIR/templates/project-llms.txt" > "$CENTRAL_KB_LOCAL/llms.txt"; echo "• skeleton KB project knowledge: projects/$BASE/.kb-local/llms.txt"; }

# ---------- 2) Migration: .kb-local/ thật trong project con ----------
if [ -d .kb-local ] && [ ! -L .kb-local ]; then
  echo "• phát hiện .kb-local/ thật trong project con — đang migrate sang KB trung tâm..."
  if [ -n "$(ls -A .kb-local 2>/dev/null)" ]; then
    # Copy nội dung vào KB trung tâm (không ghi đè file đã có)
    cp -R .kb-local/. "$CENTRAL_KB_LOCAL/"
    echo "  đã copy nội dung .kb-local/ vào $CENTRAL_KB_LOCAL"
  fi
  LEGACY=".kb-local.legacy-$(date +%Y%m%d)"
  mv .kb-local "$LEGACY"
  echo "  đã đổi tên .kb-local/ cũ thành $LEGACY (tự xóa sau khi kiểm tra)"
fi

# ---------- 3) Symlink .kb (tuyệt đối, không commit) ----------
if [ -L .kb ]; then
  CURRENT="$(readlink .kb || true)"
  if [ "$CURRENT" != "$KB_DIR" ]; then
    rm .kb && ln -s "$KB_DIR" .kb && echo "• cập nhật symlink .kb -> $KB_DIR"
  else
    echo "• .kb đã đúng"
  fi
elif [ -e .kb ]; then
  echo "⚠️  .kb tồn tại nhưng không phải symlink — giữ nguyên." >&2
else
  ln -s "$KB_DIR" .kb && echo "• symlink .kb -> $KB_DIR"
fi

# ---------- 4) Symlink .kb-local (tuyệt đối, không commit) ----------
if [ -L .kb-local ]; then
  CURRENT="$(readlink .kb-local || true)"
  if [ "$CURRENT" != "$CENTRAL_KB_LOCAL" ]; then
    rm .kb-local && ln -s "$CENTRAL_KB_LOCAL" .kb-local && echo "• cập nhật symlink .kb-local -> $CENTRAL_KB_LOCAL"
  else
    echo "• .kb-local đã đúng"
  fi
elif [ -e .kb-local ]; then
  echo "⚠️  .kb-local tồn tại nhưng không phải symlink — giữ nguyên." >&2
  echo "   Knowledge trung tâm dự kiến ở: $CENTRAL_KB_LOCAL" >&2
else
  ln -s "$CENTRAL_KB_LOCAL" .kb-local && echo "• symlink .kb-local -> $CENTRAL_KB_LOCAL"
fi

# ---------- 5) gitignore .kb + .kb-local ----------
GI=.gitignore
gitignore_add() {
  local entry="$1"
  if [ -f "$GI" ] && grep -qxF "$entry" "$GI"; then return 0; fi
  printf "\n# Symlink tới %s (tạo lại bằng link-kb.sh)\n%s\n" "$KB_NAME" "$entry" >> "$GI"
  echo "• .gitignore += $entry"
}
gitignore_add ".kb"
gitignore_add ".kb-local"
if ! { [ -f "$GI" ] && grep -qxF ".kb-local.legacy-*" "$GI"; }; then
  printf "\n# Backup .kb-local cũ khi migrate (tạo bằng link-kb.sh)\n.kb-local.legacy-*\n" >> "$GI"
  echo "• .gitignore += .kb-local.legacy-*"
fi

# ---------- 6) CLAUDE.md — tôn trọng bản sẵn có, thêm/cập nhật khối fallback ----------
MB="# >>> ${KB_NAME} (agent-kb) >>>"
ME="# <<< ${KB_NAME} (agent-kb) <<<"
NOTE="# Tham chiếu KB chung. Nếu symlink .kb/.kb-local không tồn tại (chưa link KB),"
NOTE2="# hãy BỎ QUA mọi bước liên quan .kb/.kb-local và tiếp tục làm việc bình thường."
NEW_BLOCK=$(printf '%s\n%s\n%s\n@.kb/AGENTS.md\n%s\n' "$MB" "$NOTE" "$NOTE2" "$ME")

CLAUDE_FILE="CLAUDE.md"
if [ ! -e "$CLAUDE_FILE" ]; then
  printf '%s\n' "$NEW_BLOCK" > "$CLAUDE_FILE"
  echo "• CLAUDE.md (tạo mới → trỏ KB + fallback)"
elif grep -qF "$MB" "$CLAUDE_FILE"; then
  # Cập nhật block cũ thành block mới (fallback) mà không đụng nội dung ngoài block
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$CLAUDE_FILE" "$MB" "$ME" "$NEW_BLOCK" <<'PY'
import sys, re
path, mb, me, new_block = sys.argv[1:5]
text = open(path).read()
pat = re.compile(re.escape(mb) + r'.*?' + re.escape(me), re.DOTALL)
if pat.search(text):
    text = pat.sub(new_block.rstrip(), text)
    open(path, 'w').write(text)
    print("• CLAUDE.md (cập nhật khối KB → có fallback)")
else:
    print("• CLAUDE.md (đã có tham chiếu KB)")
PY
  elif grep -qF "$ME" "$CLAUDE_FILE"; then
    # Fallback không cần python3: dùng awk thay phần giữa hai marker (literal, không regex).
    # Chỉ chạy khi có ĐỦ cả marker đầu+cuối để không bao giờ nuốt nội dung ngoài block.
    _TB="$(mktemp)"; _TO="$(mktemp)"
    printf '%s\n' "$NEW_BLOCK" > "$_TB"
    if awk -v mb="$MB" -v me="$ME" -v bf="$_TB" '
        { if (!ins && index($0, mb)) { while ((getline l < bf) > 0) print l; close(bf); ins=1; next }
          if (ins) { if (index($0, me)) ins=0; next }
          print }
      ' "$CLAUDE_FILE" > "$_TO"; then
      cat "$_TO" > "$CLAUDE_FILE"
      echo "• CLAUDE.md (cập nhật khối KB → có fallback; qua awk, không cần python3)"
    else
      echo "• CLAUDE.md (đã có tham chiếu KB — không tự cập nhật được, sửa tay nếu cần)"
    fi
    rm -f "$_TB" "$_TO"
  else
    echo "• CLAUDE.md (có marker đầu nhưng thiếu marker cuối — giữ nguyên, sửa tay nếu cần)"
  fi
else
  printf '\n%s\n' "$NEW_BLOCK" >> "$CLAUDE_FILE"
  echo "• CLAUDE.md (giữ nguyên + CHÈN tham chiếu KB + fallback)"
fi

# ---------- 7) slash command cho Claude Code ----------
mkdir -p .claude/commands
if [ -d "$KB_DIR/templates/commands" ]; then
  cp "$KB_DIR/templates/commands/"*.md .claude/commands/
  echo "• slash command: /kb-scan, /kb-drift, /kb-onboard (.claude/commands/)"
else
  echo "⚠️  Không tìm thấy templates/commands/ trong KB" >&2
fi

echo ""
echo "Project '$BASE' đã nối vào KB."
echo "  KB chung:     $KB_DIR"
echo "  Knowledge:    $CENTRAL_KB_LOCAL"
echo "  (không commit .kb / .kb-local — đã có trong .gitignore)"
