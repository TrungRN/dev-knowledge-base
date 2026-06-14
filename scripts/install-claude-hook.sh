#!/usr/bin/env bash
# install-claude-hook.sh — cài Claude Code hook (tầng CỨNG) vào một project:
#   1) vendor hook script vào .kb-local/hooks/ (commit để cả team có)
#   2) merge cấu hình UserPromptSubmit vào .claude/settings.json (an toàn, không ghi đè)
#
# Dùng: ./scripts/install-claude-hook.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
# Chỉ ảnh hưởng Claude Code (file .claude/settings.json trong repo) — KHÔNG đụng CI/git
# server, nên không cần lead duyệt. Cursor/Codex dùng cơ chế khác (xem cuối file).
set -euo pipefail
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$PWD}"
PROOT="$(cd "$TARGET" && (git rev-parse --show-toplevel 2>/dev/null || pwd))"
cd "$PROOT"

# 1) Vendor hook script
mkdir -p .kb-local/hooks
cp "$KB_DIR/templates/hooks/remind-read-index.sh" .kb-local/hooks/remind-read-index.sh
chmod +x .kb-local/hooks/remind-read-index.sh
echo "• Vendored: .kb-local/hooks/remind-read-index.sh (commit file này)"

# 2) Merge vào .claude/settings.json
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
  • Hook chỉ chạy với Claude Code. Cursor/Codex/Gemini vẫn dựa vào AGENTS.md (tầng mềm).
  • Đây là file trong repo (.claude/, .kb-local/) — KHÔNG đụng CI/git server, không cần lead duyệt.
EOF
