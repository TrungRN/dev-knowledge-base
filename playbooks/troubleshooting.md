# Playbook: Sự cố thường gặp

## Symlink `.kb` hỏng / trỏ sai
- Triệu chứng: agent không đọc được `@.kb/...`, hoặc `ls .kb` báo lỗi.
- Khắc phục: xoá và tạo lại — `rm .kb && ./<đường-dẫn>/dev-kb/scripts/connect-project.sh .` (từ trong project), hoặc `ln -s <đường-dẫn-dev-kb> .kb`.
- Nguyên nhân hay gặp: đổi chỗ thư mục project hoặc dev-kb → đường dẫn tương đối lệch. Giữ chúng ngang hàng.

## Agent nạp quá nhiều / tốn token
- Kiểm tra agent có đọc `repo-map.md`/`llms.txt` trước không. Nhắc rõ trong prompt: "đọc index trước, fetch theo nhu cầu".
- Repo map quá dài → cắt bớt: chỉ giữ module/signature quan trọng, bỏ chi tiết vụn.

## Knowledge lệch code (drift)
- Chạy `.kb/prompts/review-kb-drift.md` trên diff để định vị & vá.
- Phòng ngừa: theo `kb-acceptance-checklist.md`, sửa knowledge trong cùng PR.

## Auto-scan đoán sai stack
- Mục "(cần xác nhận)" trong báo cáo là chỗ agent không chắc — xác nhận tay rồi cho chạy lại bước liên quan.
- Project đa stack (mono-repo): chạy auto-scan cho từng package, mỗi cái một `.kb-local/`.

## Không biết project khác expose gì
- Tra `.kb/registry.yaml` → mở `.kb-local/repo-map.md` của project đó qua `path`.
- Nếu registry cũ → chạy lại auto-scan ở project đó để cập nhật `last_scanned`.

## Conflict khi nhiều người sửa cùng file knowledge
- Knowledge ở repo nên xử lý như code: rebase, giải conflict trong PR. Vì là một-bản-vật-lý + per-project, ít khi đụng nhau.
