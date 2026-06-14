# Bảo mật — luật & gotchas

## Tuyệt đối không
- Commit secret/credential/token/private key vào repo (kể cả lịch sử git).
- In secret ra log, error message, hay file knowledge.
- Disable kiểm tra SSL/cert "cho nhanh".

## Secrets
- Đọc từ biến môi trường / secret manager, không hard-code.
- File mẫu `.env.example` (không giá trị thật) được commit; `.env` thật thì gitignore.
- Nếu lỡ commit secret → coi như đã lộ: **xoay (rotate) ngay**, không chỉ xoá commit.

## Input & dữ liệu
- Validate mọi input từ ngoài (user, API, file, queue).
- Query DB tham số hoá (parameterized) — chống SQL/NoSQL injection.
- Escape output theo ngữ cảnh (HTML, shell, SQL) — chống injection/XSS.

## Quyền
- Nguyên tắc đặc quyền tối thiểu. Không nâng quyền ngoài nhu cầu.
- Kiểm tra authz ở server, không tin client.

## Đặc thù legacy
- Khi đụng code cũ: ghi lại các **lỗ hổng/gotcha bảo mật** phát hiện được vào
  `.kb-local/security-notes.md` (vd: lib lỗi thời, endpoint không auth, hard-code cũ)
  — đây là tri thức quan trọng cần giữ lại, không tự ý vá lẫn vào PR khác.

## Việc của agent
- Trước khi commit, quét diff tìm secret (pattern key/token/password).
- Không đề xuất code vô hiệu hoá kiểm soát an toàn.
