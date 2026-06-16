#!/usr/bin/env bash
# install-claude-hook.sh — cài Claude Code hook (tầng CỨNG) vào một project:
#   1) đặt hook script vào .kb-local/hooks/ (bây giờ nằm trong KB trung tâm
#      qua symlink .kb-local; commit ở KB trung tâm)
#   2) merge cấu hình UserPromptSubmit vào .claude/settings.json (an toàn, không ghi đè)
#
# Dùng: ./scripts/install-claude-hook.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
# Chỉ ảnh hưởng Claude Code (file .claude/ trong repo project) — KHÔNG đụng CI/git server,
# nên không cần lead duyệt. Cursor/Codex dùng cơ chế khác (xem cuối file).
set -euo pipefail
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$PWD}"
PROOT="$(cd "$TARGET" && (git rev-parse --show-toplevel 2>/dev/null || pwd))"
cd "$PROOT"
BASE="$(basename "$PROOT")"

# Xác định .kb-local thực tế (trong KB trung tâm)
KB_LOCAL_REAL="$KB_DIR/projects/$BASE/.kb-local"
if [ -L .kb-local ]; then
  KB_LOCAL_REAL="$(readlink .kb-local)"
elif [ ! -d "$KB_LOCAL_REAL" ]; then
  mkdir -p "$KB_LOCAL_REAL"
  ln -s "$KB_LOCAL_REAL" .kb-local 2>/dev/null || true
fi
mkdir -p "$KB_LOCAL_REAL/hooks"

# 1) Đặt hook script vào KB trung tâm (commit file này ở repo KB)
cp "$KB_DIR/templates/hooks/remind-read-index.sh" "$KB_LOCAL_REAL/hooks/remind-read-index.sh"
chmod +x "$KB_LOCAL_REAL/hooks/remind-read-index.sh"
echo "• Hook đặt trong KB trung tâm: projects/$BASE/.kb-local/hooks/remind-read-index.sh"
echo "  (commit file này trong repo dev-knowledge-base; project con chỉ truy xuất qua symlink)"

# 2) Merge vào .claude/settings.json trong project con
mkdir -p .claude
SETTINGS=".claude/settings.json"
SNIPPET="$KB_DIR/templates/hooks/settings.json"

if [ ! -f "$SETTINGS" ]; then
  cp "$SNIPPET" "$SETTINGS"
  echo "• Tạo $SETTINGS với hook UserPromptSubmit."
elif command -v python3 >/dev/null 2>&1; then
  python3 - "$SETTINGS" "$SNIPPET" <<'PY'
import json, sys
cur_path, snip_path = sys.argv[1], sys.argv[2]
cur = json.load(open(cur_path))
snip = json.load(open(snip_path))
hooks = cur.setdefault("hooks", {})
ups = hooks.setdefault("UserPromptSubmit", [])
flat = json.dumps(ups)
if "remind-read-index.sh" in flat:
    print("• Hook đã có trong settings.json — bỏ qua.")
else:
    ups.extend(snip["hooks"]["UserPromptSubmit"])
    json.dump(cur, open(cur_path, "w"), ensure_ascii=False, indent=2)
    print("• Đã merge hook vào " + cur_path)
PY
else
  echo "• $SETTINGS đã tồn tại và không có python3 để merge an toàn."
  echo "  Thêm tay khối UserPromptSubmit từ: $SNIPPET"
fi

cat <<EOF

Xong (tầng cứng cho Claude Code). Mở phiên Claude Code mới để hook có hiệu lực.
Lưu ý:
  • Hook script nằm trong repo KB trung tâm (projects/$BASE/.kb-local/hooks/).
  • Cài đặt Claude Code (.claude/settings.json) nằm trong repo project con.
  • Cursor/Codex/Gemini vẫn dựa vào AGENTS.md (tầng mềm).
  • KHÔNG đụng CI/git server, không cần lead duyệt.
EOF
