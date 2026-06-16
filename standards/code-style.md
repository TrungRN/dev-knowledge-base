# Code style (phần chung, stack-agnostic)

Đây là nguyên tắc chung áp dụng cho mọi project. **Quy ước cụ thể theo ngôn ngữ/
framework** (vd indent, linter config, format) do auto-scan phát hiện và ghi vào
`.kb-local/code-style.md` của từng project (trong repo KB trung tâm, tại
`projects/<tên>/.kb-local/code-style.md`) — tin file đó trước khi file này.

## Nguyên tắc chung
- **Theo formatter/linter sẵn có của project**, đừng áp style cá nhân. Nếu project có `.editorconfig`, `prettier`, `eslint`, `checkstyle`, `ruff`, `gofmt`... thì đó là luật.
- **Đặt tên rõ hơn comment.** Tên hàm/biến nói lên ý định; comment dành cho "vì sao", không phải "cái gì".
- **Hàm nhỏ, một việc.** Tránh hàm > 50 dòng hoặc lồng > 3 cấp.
- **Không magic number/string.** Đưa vào hằng có tên.
- **Xử lý lỗi tường minh.** Không nuốt exception im lặng.
- **Không để code chết / import thừa.** Dọn trong cùng PR.

## Với codebase legacy
- **Nhất quán với code xung quanh** quan trọng hơn "đúng chuẩn mới". Đừng refactor style hàng loạt lẫn vào PR tính năng.
- Refactor style tách thành PR `refactor:` riêng.

## Việc của auto-scan
Khi quét project, agent phát hiện và ghi vào `.kb-local/code-style.md`:
ngôn ngữ, version, formatter/linter đang dùng, config ở đâu, các quy ước đặc thù
đọc được từ code thực tế.
