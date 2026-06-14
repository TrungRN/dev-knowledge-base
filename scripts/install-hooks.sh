#!/usr/bin/env bash
# install-hooks.sh — cài drift check vào một project:
#   1) vendor script + config CI vào .kb-local/ci/ (commit thư mục này)
#   2) cài pre-push hook (cảnh báo sớm)
#   3) in hướng dẫn bật CI
#
# Dùng: ./scripts/install-hooks.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
set -euo pipefail
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$PWD}"
PROOT="$(cd "$TARGET" && (git rev-parse --show-toplevel 2>/dev/null || pwd))"
cd "$PROOT"

# 1) Vendor (để CI runner dùng được — symlink .kb không tồn tại trên CI)
mkdir -p .kb-local/ci
cp "$KB_DIR/scripts/kb-drift-check.sh"             .kb-local/ci/kb-drift-check.sh
cp "$KB_DIR/templates/ci/gitlab-ci.kb-drift.yml"   .kb-local/ci/gitlab-ci.kb-drift.yml
cp "$KB_DIR/templates/ci/github-kb-drift.yml"      .kb-local/ci/github-kb-drift.yml
chmod +x .kb-local/ci/kb-drift-check.sh
echo "• Vendored: .kb-local/ci/  (NHỚ commit thư mục này)"

# 2) pre-push hook (không ghi đè nếu đã có hook khác)
HOOK=".git/hooks/pre-push"
if [ ! -d .git ]; then
  echo "• Bỏ qua hook: không thấy .git (chạy trong repo có git)."
elif [ -e "$HOOK" ] && ! grep -q "kb-drift" "$HOOK" 2>/dev/null; then
  echo "• .git/hooks/pre-push ĐÃ tồn tại — không ghi đè."
  echo "  Thêm tay dòng: bash \"\$(git rev-parse --show-toplevel)/.kb-local/ci/kb-drift-check.sh\" origin/main"
else
  cp "$KB_DIR/templates/ci/pre-push" "$HOOK"
  chmod +x "$HOOK"
  echo "• Cài hook: .git/hooks/pre-push (cảnh báo sớm; mỗi dev chạy script này 1 lần sau khi clone)"
fi

cat <<EOF

Bước cuối — bật CI (chọn theo nền tảng):
  • GitLab: thêm vào .gitlab-ci.yml của project:
        include:
          - local: '.kb-local/ci/gitlab-ci.kb-drift.yml'
  • GitHub: copy .kb-local/ci/github-kb-drift.yml -> .github/workflows/kb-drift.yml

Chế độ mặc định: CẢNH BÁO (không chặn merge).
Muốn CHẶN: GitLab đặt allow_failure:false; thêm '--strict' vào lệnh chạy script.
EOF
