# Checklist code review

Dùng khi review PR (người hoặc agent). Đánh dấu mục không áp dụng là N/A.

## Đúng đắn
- [ ] Giải quyết đúng vấn đề nêu trong PR, không hơn không kém.
- [ ] Xử lý edge case & lỗi (null, rỗng, timeout, quyền).
- [ ] Không phá hành vi hiện có (backward compatible) trừ khi cố ý & có ghi chú.

## Chất lượng
- [ ] Đặt tên rõ; hàm nhỏ, một việc.
- [ ] Không lặp logic có thể tái dùng.
- [ ] Nhất quán với code xung quanh (đặc biệt legacy).
- [ ] Không code chết / import thừa / log debug sót.

## An toàn
- [ ] Không secret/credential trong code hay log (xem `security.md`).
- [ ] Input từ ngoài được validate; query có tham số hoá (chống injection).
- [ ] Không nâng quyền ngoài ý muốn.

## Test
- [ ] Có test cho phần thêm/sửa; test chạy xanh.
- [ ] Path lỗi cũng được test, không chỉ happy path.

## Knowledge (BẮT BUỘC — đặc thù KB này)
- [ ] Nếu đổi kiến trúc/luồng/module/quyết định → `.kb-local/` đã cập nhật trong CÙNG PR.
- [ ] `repo-map.md` còn khớp với cấu trúc thật sau thay đổi.
- [ ] Quyết định kiến trúc mới có ADR (nếu thuộc loại cần ADR).
- [ ] Đã chạy `prompts/review-kb-drift.md`, không còn drift chưa xử lý.
