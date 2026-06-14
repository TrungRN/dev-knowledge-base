# Quy ước đặt tên

Phần chung. Quy ước cụ thể theo ngôn ngữ do auto-scan ghi vào `.kb-local/`.

## Nguyên tắc
- **Mô tả ý định, không mô tả kiểu.** `activeUsers` tốt hơn `userList`.
- **Nhất quán toàn project.** Cùng khái niệm → cùng một từ (đừng lẫn `customer`/`client`/`user` cho cùng thứ). Ghi "từ điển thuật ngữ" vào `.kb-local/glossary.md`.
- **Theo convention của ngôn ngữ:** camelCase (JS/Java), snake_case (Python/Rust), PascalCase cho type/class, UPPER_SNAKE cho hằng.
- **Tránh viết tắt mơ hồ.** `cfg`, `tmp` ok; `mgr2`, `dataX` thì không.
- **Boolean ở dạng khẳng định:** `isEnabled`, `hasAccess` — tránh phủ định lồng (`isNotDisabled`).

## File & thư mục
- Theo convention sẵn có của project (đừng trộn kiểu).
- Tên file phản ánh nội dung chính bên trong.

## Đặc thù legacy
- **Đừng đổi tên hàng loạt** lẫn vào PR tính năng — gây nhiễu diff & review.
- Khi gặp tên cũ khó hiểu, ghi giải nghĩa vào `.kb-local/glossary.md` thay vì đổi ngay.
