#!/usr/bin/env bash
# bootstrap-all.sh — chạy MỘT LẦN ở thư mục tổng (cha của dev-knowledge-base).
# Quét mọi project ngang hàng và nối vào KB qua link-kb.sh (tôn trọng file agent sẵn có).
# Idempotent: chạy lại bất cứ lúc nào đều an toàn.
#
# Dùng:
#   ./dev-knowledge-base/scripts/bootstrap-all.sh           # chỉ các thư mục là git repo (mặc định)
#   ./dev-knowledge-base/scripts/bootstrap-all.sh --all     # mọi thư mục con (kể cả chưa git)
set -euo pipefail
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT="$(dirname "$KB_DIR")"
ALL=0; [ "${1:-}" = "--all" ] && ALL=1

echo "Thư mục tổng: $PARENT"
echo "KB:           $KB_DIR"
echo "Chế độ:       $([ $ALL = 1 ] && echo 'mọi thư mục con' || echo 'chỉ git repo (--all để gồm tất cả)')"
echo

linked=0; skipped=0
for d in "$PARENT"/*/; do
  proj="${d%/}"
  base="$(basename "$proj")"
  [ "$proj" = "$KB_DIR" ] && continue          # bỏ chính KB
  case "$base" in .*) continue;; esac          # bỏ thư mục ẩn
  if [ "$ALL" = 0 ] && [ ! -d "$proj/.git" ]; then
    echo "— bỏ qua (không phải git repo): $base"; skipped=$((skipped+1)); continue
  fi
  echo "=== $base ==="
  bash "$KB_DIR/scripts/link-kb.sh" "$proj"
  bash "$KB_DIR/scripts/detect-stack.sh" "$proj" 2>/dev/null | sed 's/^/  /' | head -10
  echo
  linked=$((linked+1))
done

echo "Đã nối $linked project (bỏ qua $skipped)."
cat <<EOF

Bước tùy chọn — làm giàu knowledge bằng AI (mỗi project, khi cần):
  Mở agent trong project và bảo: "Đọc .kb/prompts/auto-scan.md và làm theo."
  (Bootstrap đã tạo skeleton .kb-local/repo-map.md; auto-scan sẽ điền chi tiết thực.)

Chạy lại script này bất cứ lúc nào để nối các project mới — an toàn, không ghi đè.
EOF
