#!/usr/bin/env bash
# link-kb.sh — nối MỘT project vào KB (tập trung Claude Code).
#
# Với mỗi project:
#   • tạo symlink .kb -> <KB>                         (nếu chưa có)
#   • tạo .kb-local/ + skeleton repo-map.md, llms.txt (không ghi đè bản đã có)
#   • thêm .kb vào .gitignore
#   • CLAUDE.md: chưa có → tạo, trỏ @.kb/AGENTS.md;  đã có → GIỮ NGUYÊN, chỉ chèn 1 khối trỏ KB
#   • cài slash command (/kb-scan, /kb-drift, /kb-onboard) vào .claude/commands/
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

# 1) symlink .kb
REL="$(python3 -c "import os,sys;print(os.path.relpath(sys.argv[1],sys.argv[2]))" "$KB_DIR" "$PROJ")"
if [ -e .kb ] || [ -L .kb ]; then echo "• .kb đã có"; else ln -s "$REL" .kb; echo "• symlink .kb -> $REL"; fi

# 2) .kb-local skeleton
mkdir -p .kb-local/adr
[ -f .kb-local/repo-map.md ] || { sed "s/<TÊN PROJECT>/$BASE/g" "$KB_DIR/templates/repo-map.md" > .kb-local/repo-map.md; echo "• skeleton .kb-local/repo-map.md"; }
[ -f .kb-local/llms.txt ]    || { sed "s/<TÊN PROJECT>/$BASE/g" "$KB_DIR/templates/project-llms.txt" > .kb-local/llms.txt; echo "• skeleton .kb-local/llms.txt"; }

# 3) gitignore .kb
GI=.gitignore
if { [ -f "$GI" ] && grep -qxF ".kb" "$GI"; }; then :; else
  printf "\n# Symlink tới %s (tạo lại bằng link-kb.sh)\n.kb\n" "$KB_NAME" >> "$GI"; echo "• .gitignore += .kb"
fi

# 4) CLAUDE.md — tôn trọng bản sẵn có
MB="# >>> ${KB_NAME} (agent-kb) >>>"
ME="# <<< ${KB_NAME} (agent-kb) <<<"
NOTE="# Tham chiếu KB chung — KHÔNG xoá khối này. Sửa luật ở ${KB_NAME}, đừng sửa ở đây."
if [ ! -e CLAUDE.md ]; then
  printf '%s\n%s\n@.kb/AGENTS.md\n%s\n' "$MB" "$NOTE" "$ME" > CLAUDE.md; echo "• CLAUDE.md (tạo mới → trỏ KB)"
elif grep -qF "$MB" CLAUDE.md; then echo "• CLAUDE.md (đã có tham chiếu KB)"
else printf '\n%s\n%s\n@.kb/AGENTS.md\n%s\n' "$MB" "$NOTE" "$ME" >> CLAUDE.md; echo "• CLAUDE.md (giữ nguyên + CHÈN tham chiếu KB)"; fi

# 5) slash command cho Claude Code (tự cài, không cần bước riêng)
mkdir -p .claude/commands
cp "$KB_DIR/templates/commands/"*.md .claude/commands/
echo "• slash command: /kb-scan, /kb-drift, /kb-onboard (.claude/commands/)"
