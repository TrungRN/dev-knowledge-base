Đọc `.kb/prompts/review-kb-drift.md` và chạy quy trình đó trên thay đổi hiện tại
(`git diff origin/main...HEAD`, hoặc range tôi cung cấp bên dưới).

Knowledge cần so nằm ở `.kb-local/` (symlink tới `projects/<tên-project>/.kb-local/`
trong KB trung tâm). Liệt kê mọi chỗ knowledge bị lệch so với code, kèm đề xuất patch cụ thể,
và nêu rõ chỗ nào cần tôi quyết (vd cần viết ADR mới).

$ARGUMENTS
