# Playbook: Sự cố thường gặp

## Symlink `.kb` hoặc `.kb-local` hỏng / trỏ sai
- Triệu chứng: agent không đọc được `@.kb/...`, hoặc `ls .kb` báo lỗi.
- Khắc phục: chạy lại `kb link` từ trong project (hoặc `kb init` từ thư mục tổng). Script
tạo lại symlink tuyệt đối `.kb` → KB trung tâm và `.kb-local` → `projects/<tên>/.kb-local/`.
- Nguyên nhân hay gặp: đổi chỗ thư mục project hoặc dev-knowledge-base. Vì dùng đường dẫn
tuyệt đối, chỉ cần cả 2 repo vẫn tồn tại ở đâu đó trong máy là symlink vẫn đúng.

## Agent nạp quá nhiều / tốn token
- Kiểm tra agent có đọc `repo-map.md`/`llms.txt` trước không. Nhắc rõ trong prompt: "đọc index trước, fetch theo nhu cầu".
- Repo map quá dài → cắt bớt: chỉ giữ module/signature quan trọng, bỏ chi tiết vụn.

## Knowledge lệch code (drift)
- Chạy `.kb/prompts/review-kb-drift.md` trên diff để định vị & vá.
- Phòng ngừa: theo `kb-acceptance-checklist.md`, sửa knowledge trong repo KB trung tâm
  (`projects/<tên>/.kb-local/`) kèm theo PR code.

## Auto-scan đoán sai stack
- Mục "(cần xác nhận)" trong báo cáo là chỗ agent không chắc — xác nhận tay rồi cho chạy lại bước liên quan.
- Project đa stack (mono-repo): chạy auto-scan cho từng package, mỗi cái một thư mục trong
  `projects/<tên>/.kb-local/` (hoặc một `.kb-local/` duy nhất nếu chia module rõ ràng).

## Không biết project khác expose gì
- Tra `.kb/registry.yaml` → mở `projects/<tên>/.kb-local/repo-map.md` trong KB trung tâm.
- Nếu registry cũ → chạy lại auto-scan ở project đó để cập nhật `last_scanned`.

## Conflict khi nhiều người sửa cùng file knowledge
- Knowledge ở repo KB trung tâm nên xử lý như code: rebase, giải conflict trong PR của repo KB.
  Vì là một-bản-vật-lý + per-project, ít khi đụng nhau.
