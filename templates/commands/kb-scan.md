Đọc file `.kb/prompts/auto-scan.md` trong project hiện tại và thực hiện đầy đủ các bước:
quét code, tự dò stack, sinh/cập nhật `.kb-local/repo-map.md` và `.kb-local/llms.txt`,
và đăng ký project vào `.kb/registry.yaml`.

Nếu `.kb-local/` chưa tồn tại, hãy tạo skeleton bằng cách đọc
`.kb/templates/repo-map.md` và `.kb/templates/project-llms.txt` rồi thay `<TÊN PROJECT>`
bằng tên folder project hiện tại.

Lưu ý: `.kb-local/` trong project con là symlink trỏ về KB trung tâm
(`projects/<tên-project>/.kb-local/`). Mọi thay đổi sẽ được lưu ở KB trung tâm.

Tôn trọng mọi file agent sẵn có (không ghi đè). Khi xong, báo lại: stack phát hiện,
các module chính, và danh sách mục "(cần xác nhận)" để tôi kiểm tay.

$ARGUMENTS
