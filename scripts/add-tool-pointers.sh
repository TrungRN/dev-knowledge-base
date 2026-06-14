#!/usr/bin/env bash
# Tạo ĐỦ BỘ "file trỏ" cho các AI coding tool — tất cả trỏ về AGENTS.md (nguồn duy nhất).
# File trỏ KHÔNG chứa nội dung, chỉ import/chỉ-dẫn → không nhân đôi, không lệch nhau.
#
# Dùng: ./scripts/add-tool-pointers.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
# Idempotent: file đã tồn tại thì bỏ qua (không ghi đè bản bạn đã sửa tay).
set -euo pipefail
TARGET="${1:-$PWD}"
cd "$TARGET" || { echo "Không vào được: $TARGET" >&2; exit 1; }

created=(); skip=()
write_if_absent() {
  local path="$1"; shift
  if [[ -e "$path" ]]; then skip+=("$path"); return; fi
  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$@" > "$path"
  created+=("$path")
}

IMPORT='@AGENTS.md'
I1='# Hướng dẫn AI cho project này nằm ở AGENTS.md (gốc repo).'
I2='Hãy đọc và tuân theo `AGENTS.md`, gồm cả các file nó tham chiếu trong `.kb/` và `.kb-local/`.'

# Tool hỗ trợ cú pháp import @ → giữ một nguồn:
write_if_absent "CLAUDE.md"  "$IMPORT"     # Claude Code
write_if_absent "GEMINI.md"  "$IMPORT"     # Gemini CLI

# Tool không hỗ trợ import → file trỏ dạng chỉ-dẫn:
write_if_absent ".cursorrules"                    "$I1" "$I2"  # Cursor (bản mới đọc AGENTS.md native; đây là fallback)
write_if_absent ".windsurfrules"                  "$I1" "$I2"  # Windsurf
write_if_absent ".clinerules"                     "$I1" "$I2"  # Cline
write_if_absent ".github/copilot-instructions.md" "$I1" "$I2"  # GitHub Copilot

echo "File trỏ đã tạo:"; printf '  + %s\n' "${created[@]:-(không có — tất cả đã tồn tại)}"
if [[ ${#skip[@]} -gt 0 ]]; then echo "Bỏ qua (đã tồn tại):"; printf '  · %s\n' "${skip[@]}"; fi
echo
echo "Lưu ý: các file trỏ này NÊN commit (khác với symlink .kb). AGENTS.md là nguồn duy nhất."
