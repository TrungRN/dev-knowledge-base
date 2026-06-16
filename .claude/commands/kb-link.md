Nối MỘT project vào KB.

Chạy: `bash scripts/link-kb.sh <đường-dẫn-project>` với đường dẫn tôi đưa bên dưới
(nếu tôi không đưa, hỏi tôi đường dẫn project).

Việc này tạo symlink `.kb` + `.kb-local` (tuyệt đối), `CLAUDE.md` trỏ sang KB với
fallback nếu chưa link, và slash command. Knowledge riêng project được giữ trong
KB trung tâm (`projects/<tên>/.kb-local/`); project con chỉ giữ symlink. Tôn trọng
`CLAUDE.md` sẵn có. Sau khi chạy, tóm tắt kết quả.

$ARGUMENTS
