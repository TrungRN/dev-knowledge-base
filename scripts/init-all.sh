#!/usr/bin/env bash
# init-all.sh — KHỞI TẠO KB cho tất cả project (chạy MỘT LẦN ở thư mục tổng).
#
# MỤC ĐÍCH: quét mọi project ngang hàng với dev-knowledge-base và "nối" từng cái vào KB.
# Với mỗi project nó tạo: symlink .kb (trỏ về KB chung), skeleton .kb-local/, file
# CLAUDE.md trỏ sang KB, và slash command cho Claude Code. Tôn trọng CLAUDE.md sẵn có.
# => Sau khi chạy, mọi project đều "biết" tới KB chung mà không phải làm tay từng cái.
#
# Idempotent: chạy lại bất cứ lúc nào để nối project mới — an toàn, không ghi đè.
# Dùng: init-all.sh [--all]   (--all để gồm cả thư mục chưa phải git repo)
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
  Mở project trong Claude Code và gõ /kb-scan
  (init đã tạo skeleton .kb-local/repo-map.md; /kb-scan sẽ điền chi tiết thực.)

Chạy lại bất cứ lúc nào để nối project mới — an toàn, không ghi đè.
EOF
