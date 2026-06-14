# 0001. Dùng ADR để ghi lại quyết định kiến trúc

- **Trạng thái:** Accepted
- **Ngày:** 2026-06-14
- **Người quyết:** trungrn67@gmail.com

## Bối cảnh
Project legacy mất nhiều tri thức "vì sao" khi người cũ rời đi. Cần một cách nhẹ,
versioned cùng code, để giữ lại lý do của các quyết định kiến trúc — phục vụ
onboarding, tránh phá nhầm, và để AI agent đọc hiểu được nền tảng.

## Quyết định
Mọi quyết định kiến trúc quan trọng được ghi thành một ADR dạng markdown, lưu trong
repo (`decisions/` cho KB chung, `.kb-local/adr/` cho project con), versioned theo git.

## Các lựa chọn đã cân nhắc
- **ADR trong repo (đã chọn):** đi cùng code, review trong PR, không drift, agent đọc trực tiếp rẻ.
- **Wiki/Confluence:** tách rời code, dễ drift, tốn lượt fetch. Để dành cho doc người-đọc giai đoạn 2.
- **Không ghi gì:** tri thức tiếp tục thất thoát — chính vấn đề cần giải.

## Hệ quả
- Tích cực: tri thức "vì sao" được giữ, versioned, agent-readable.
- Đánh đổi: cần kỷ luật viết ADR khi ra quyết định (đưa vào checklist review).
- Phát sinh: định kỳ đánh dấu superseded cho ADR lỗi thời.
