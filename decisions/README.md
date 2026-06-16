# Architecture Decision Records (ADR)

ADR = bản ghi ngắn cho **một quyết định kiến trúc quan trọng**: bối cảnh, lựa chọn,
vì sao, hệ quả. Đây là cốt lõi của "knowledge retention" — giữ lại *vì sao* mọi thứ
như hiện tại, để người sau (và agent) không phá nhầm hoặc lặp lại tranh luận cũ.

## Khi nào viết ADR
Viết khi quyết định: khó đảo ngược, ảnh hưởng nhiều phần, hoặc người sau dễ thắc mắc "sao lại làm thế này". Ví dụ: chọn DB, đổi pattern auth, tách/gộp service, bỏ một thư viện, quy ước API.

Không cần ADR cho: sửa bug nhỏ, đổi tên biến, tinh chỉnh style.

## Cách viết
1. Copy `../templates/adr.md`.
2. Đặt tên `NNNN-tieu-de-ngan.md` (số tăng dần).
3. Điền, đặt trạng thái `Proposed`, mở PR.
4. Khi chốt → đổi `Accepted`. Khi bị thay thế → `Superseded by NNNN`.

## Quy ước
- ADR **không sửa nội dung cũ** khi đã Accepted. Quyết định mới → ADR mới, đánh dấu superseded cái cũ. Giữ nguyên lịch sử để hiểu diễn tiến.
- ADR của **project con** để trong `.kb-local/adr/` (thực chất nằm trong repo KB trung tâm,
  tại `projects/<tên>/.kb-local/adr/`). ADR cấp KB chung để ở đây.
