# Chuẩn đánh index — tiết kiệm token cho agent

Mục tiêu: agent tìm đúng thứ cần mà **không nạp cả KB/codebase** vào context.
Dùng index dạng **text có cấu trúc** — KHÔNG vector/embedding (xem lý do cuối file).

## Hai tầng index (mỗi project phải có)

### 1. `llms.txt` — bản đồ điều hướng
Đặt ở gốc KB và gốc `.kb-local/` của mỗi project. Liệt kê "có tài liệu/khu vực gì,
mô tả 1 dòng, đường dẫn". Agent đọc file nhỏ này TRƯỚC rồi mới fetch đúng file.
Format: tiêu đề `#`, blockquote mô tả, các nhóm `##`, mỗi mục là `- [tên](đường-dẫn): mô tả 1 dòng`.

### 2. `repo-map.md` — mục lục codebase
Mục lục cấu trúc của project, do auto-scan sinh. Gồm:
- **Cây thư mục rút gọn** (chỉ thư mục quan trọng + vai trò mỗi cái, 1 dòng).
- **Module/khu vực chính**: tên, trách nhiệm, file then chốt, phụ thuộc vào module nào.
- **Entry points**: nơi bắt đầu đọc để hiểu luồng (main, route, handler, job).
- **Signature** các hàm/class công khai quan trọng — **KHÔNG kèm thân hàm**. Đủ để agent biết "có gì, ở đâu" rồi đọc trực tiếp khi cần.
- **Luồng nghiệp vụ chính**: 3–7 bước, trỏ tới file tương ứng.

## Quy tắc giữ index rẻ
- **Entry file mỏng.** AGENTS.md & llms.txt skim được trong 1 phút. Chi tiết để sau `@import`/đường dẫn, nạp theo nhu cầu.
- **Trỏ, đừng nhúng.** Index chứa đường dẫn + mô tả, không copy nội dung file.
- **Signature, không thân hàm.** Repo map liệt kê chữ ký, agent đọc thân khi cần.
- **Refresh theo PR.** Code đổi → repo map đổi trong cùng PR (xem `prompts/review-kb-drift.md`). Index lệch còn tệ hơn không có index.

## Vì sao KHÔNG vector/embedding (ở giai đoạn này)
- Codebase có tín hiệu **tất định** tốt hơn ngữ nghĩa mờ: tên file, cây thư mục, import, signature. Repo map text + `grep`/đọc trực tiếp là đủ và chính xác.
- Rẻ hơn: không token embedding, không re-embed mỗi lần đổi code, không vector DB.
- Tất định: cùng câu hỏi → cùng kết quả.
- Không drift ẩn: vector cũ vẫn trả kết quả "trông đúng" trỏ vào code đã xoá — đúng bệnh cần tránh.

**Ngưỡng cân nhắc vector về sau:** codebase cực lớn (hàng nghìn file, đa ngôn ngữ)
*và* cần hỏi bằng ngôn ngữ tự nhiên thường xuyên → khi đó làm ở tầng MCP (giai đoạn 2),
tách riêng, không trộn vào KB text.
