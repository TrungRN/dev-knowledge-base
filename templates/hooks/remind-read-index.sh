#!/usr/bin/env bash
# Claude Code UserPromptSubmit hook — chèn nhắc "đọc index trước" vào MỖI prompt.
# stdout của hook này được Claude Code nạp làm context (tầng CỨNG: ép, không phụ
# thuộc model có nhớ đọc AGENTS.md hay không).
# Giữ ngắn (giới hạn ~10.000 ký tự). Không in gì khác ngoài phần nhắc.
cat <<'EOF'
[KB] Trước khi trả lời task này:
- Đọc .kb-local/repo-map.md + .kb-local/llms.txt để định vị (đừng quét cả repo).
- Cần thông tin project khác → tra .kb/registry.yaml.
- Nếu thay đổi đụng module/API/luồng/quyết định → cập nhật .kb-local/ trong cùng PR
  (đối chiếu .kb/templates/kb-acceptance-checklist.md).
- Tuân .kb/standards/*.
EOF
