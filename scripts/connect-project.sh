#!/usr/bin/env bash
# connect-project.sh — nối MỘT project vào KB (giữ tên cũ cho tương thích).
# Nay uỷ quyền cho link-kb.sh: tôn trọng file agent sẵn có (chèn tham chiếu KB,
# KHÔNG ghi đè). Để nối toàn bộ project một lần, dùng bootstrap-all.sh.
#
# Dùng: connect-project.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
set -euo pipefail
exec bash "$(dirname "${BASH_SOURCE[0]}")/link-kb.sh" "$@"
