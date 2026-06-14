# Điều kiện cần thoả khi cập nhật knowledge

Checklist này là "hợp đồng" giữa code và knowledge. Một PR đụng tới các mục dưới đây
**chỉ được merge khi** knowledge tương ứng đã cập nhật trong cùng PR. Dùng kèm
`prompts/review-kb-drift.md`.

## Khi thêm/xoá/đổi tên module hoặc file then chốt
- [ ] `.kb-local/repo-map.md` cập nhật cây thư mục & danh sách module.
- [ ] `.kb-local/llms.txt` cập nhật nếu khu vực tài liệu thay đổi.

## Khi đổi public API / signature hàm quan trọng
- [ ] Signature trong `repo-map.md` khớp code mới.
- [ ] Nơi gọi (kể cả project anh em) được rà — nếu ảnh hưởng, ghi chú trong PR.

## Khi đổi luồng nghiệp vụ
- [ ] Mục "Luồng nghiệp vụ chính" trong `repo-map.md` cập nhật các bước.

## Khi ra quyết định kiến trúc (đổi DB, pattern, lib, tách/gộp service...)
- [ ] Có ADR mới trong `.kb-local/adr/`.
- [ ] ADR cũ liên quan đánh dấu `Superseded by` nếu bị thay.

## Khi đổi stack / lệnh build-run-test
- [ ] `AGENTS.md` (mục Stack & Lệnh) cập nhật.

## Khi phát hiện gotcha / nợ kỹ thuật / vấn đề bảo mật
- [ ] Ghi vào `repo-map.md` (phần mong manh) hoặc `.kb-local/security-notes.md`.

## Luôn luôn
- [ ] `last_scanned`/ngày cập nhật trong file knowledge được làm mới.
- [ ] Đã chạy `prompts/review-kb-drift.md`, không còn drift chưa giải thích.
