Khởi tạo KB cho TẤT CẢ project trong thư mục tổng.

Chạy: `bash scripts/init-all.sh` (thêm `--all` nếu tôi yêu cầu gồm cả thư mục chưa phải git).

Việc này quét mọi project ngang hàng với KB và nối từng cái: tạo symlink `.kb` + `.kb-local`
(tuyệt đối), `CLAUDE.md` trỏ sang KB với fallback, và slash command. Toàn bộ knowledge
riêng project (`repo-map.md`, `llms.txt`, `adr/`) được lưu trong KB trung tâm tại
`projects/<tên>/.kb-local/`, KHÔNG nằm trong repo project con.

Tôn trọng `CLAUDE.md` sẵn có (không ghi đè). An toàn chạy lại nhiều lần.

Sau khi chạy xong, tóm tắt cho tôi: project nào đã nối, project nào bỏ qua, và gợi ý
bước tiếp theo (vào từng project gõ /kb-scan để làm giàu knowledge trong KB trung tâm).

$ARGUMENTS
