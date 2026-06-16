#!/usr/bin/env bash
# connect-project.sh — DEPRECATED. Giữ lại chỉ để tương thích tên cũ.
#   → Dùng `kb link [path]` (hoặc trực tiếp scripts/link-kb.sh) cho project lẻ.
#   → Dùng `kb init` (scripts/init-all.sh) / `/kb-init` để nối tất cả project một lần.
# Script này chỉ uỷ quyền cho link-kb.sh; sẽ bị gỡ ở bản sau.
#
# Dùng: connect-project.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
set -euo pipefail
echo "⚠️  connect-project.sh đã DEPRECATED — dùng 'kb link' (hoặc scripts/link-kb.sh). Đang uỷ quyền..." >&2
exec bash "$(dirname "${BASH_SOURCE[0]}")/link-kb.sh" "$@"
