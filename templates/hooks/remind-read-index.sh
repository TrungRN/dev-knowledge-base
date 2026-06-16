#!/usr/bin/env bash
# Claude Code UserPromptSubmit hook — chèn nhắc "đọc index trước" vào MỖI prompt.
# stdout của hook này được Claude Code nạp làm context (tầng CỨNG: ép, không phụ
# thuộc model có nhớ đọc AGENTS.md hay không).
# Giữ ngắn (giới hạn ~10.000 ký tự). Không in gì khác ngoài phần nhắc.
#
# Lưu ý: .kb-local/ là symlink trỏ về projects/<tên>/.kb-local/ trong KB trung tâm.
# Hook này được đặt trong KB trung tâm, project con chỉ truy xuất qua symlink.
cat <<'EOF'
[KB] Trước khi trả lời task này:
- Đọc .kb-local/repo-map.md + .kb-local/llms.txt để định vị (đừng quét cả repo).
  (.kb-local là symlink tới KB trung tâm.)
- Cần thông tin project khác → tra .kb/registry.yaml.
- Nếu thay đổi đụng module/API/luồng/quyết định → cập nhật .kb-local/ trong KB trung tâm
  (đối chiếu .kb/templates/kb-acceptance-checklist.md).
- Tuân .kb/standards/*.
EOF
