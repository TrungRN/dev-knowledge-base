#!/usr/bin/env bash
# Nối một project vào KB: tạo symlink .kb -> dev-knowledge-base và thư mục .kb-local/
#
# Khuyến nghị: chạy TỪ TRONG project con (không cần tham số):
#   ../dev-knowledge-base/scripts/connect-project.sh
# Hoặc chạy từ bất cứ đâu và truyền đường dẫn project:
#   /đường-dẫn/dev-knowledge-base/scripts/connect-project.sh ../project-a
# Chạy từ đâu cũng cho kết quả như nhau (script tự xác định vị trí KB).
set -euo pipefail

# Thư mục gốc của dev-knowledge-base (nơi script này nằm, lùi 1 cấp) — độc lập với chỗ gọi lệnh.
KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Mặc định: thư mục hiện tại (tiện khi đứng trong project con). Hoặc nhận tham số.
TARGET="${1:-$PWD}"
PROJECT_DIR="$(cd "$TARGET" && pwd)" || { echo "Không tìm thấy project: $TARGET" >&2; exit 1; }

if [[ "$PROJECT_DIR" == "$KB_DIR" ]]; then
  echo "Lỗi: đang trỏ vào chính dev-knowledge-base — không thể nối KB vào chính nó." >&2
  echo "Hãy chạy lệnh TỪ TRONG project con, hoặc truyền đường dẫn project làm tham số." >&2
  exit 1
fi

echo "KB:      $KB_DIR"
echo "Project: $PROJECT_DIR"

# 1) Symlink .kb -> dev-knowledge-base (đường dẫn tương đối để di chuyển cùng nhau dễ hơn)
REL="$(python3 -c "import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$KB_DIR" "$PROJECT_DIR")"
if [[ -L "$PROJECT_DIR/.kb" || -e "$PROJECT_DIR/.kb" ]]; then
  echo "• .kb đã tồn tại — bỏ qua (xoá thủ công nếu muốn tạo lại)."
else
  ln -s "$REL" "$PROJECT_DIR/.kb"
  echo "• Tạo symlink .kb -> $REL"
fi

# 2) Thư mục knowledge riêng
mkdir -p "$PROJECT_DIR/.kb-local/adr"
echo "• Tạo .kb-local/ (knowledge riêng project, commit vào repo project)"

# 2b) Đủ bộ file trỏ cho mọi AI tool (CLAUDE.md, GEMINI.md, .cursorrules, ...)
echo "• Tạo file trỏ đa tool:"
"$(dirname "${BASH_SOURCE[0]}")/add-tool-pointers.sh" "$PROJECT_DIR" | sed 's/^/    /'

# 3) Gợi ý .gitignore: bỏ symlink .kb (trỏ ra ngoài, phụ thuộc máy)
GI="$PROJECT_DIR/.gitignore"
if ! { [[ -f "$GI" ]] && grep -qxF ".kb" "$GI"; }; then
  printf "\n# Symlink tới dev-knowledge-base (tạo lại bằng connect-project.sh)\n.kb\n" >> "$GI"
  echo "• Thêm '.kb' vào .gitignore"
fi

cat <<EOF

Xong. Bước tiếp theo:
  1) Mở agent trong project và đưa nội dung: $KB_DIR/prompts/auto-scan.md
     → agent sẽ sinh AGENTS.md + .kb-local/repo-map.md + llms.txt và đăng ký vào registry.
  2) Commit .kb-local/ và AGENTS.md vào repo project.
EOF
