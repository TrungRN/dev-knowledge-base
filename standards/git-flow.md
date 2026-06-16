# Git flow & quy ước commit

## Nhánh
- `main` — luôn deploy được. Không commit thẳng.
- `feature/<mô-tả-ngắn>`, `fix/<mô-tả-ngắn>`, `chore/...` — nhánh làm việc, rebase lên `main` trước khi mở PR.
- Nhánh sống ngắn (lý tưởng < 3 ngày). Nhánh càng dài, drift & conflict càng nhiều.

## Commit — Conventional Commits
```
<type>(<scope>): <mô tả ngắn, thì hiện tại>

<thân: VÌ SAO thay đổi, không phải LÀM GÌ>
```
`type`: `feat | fix | refactor | docs | test | chore | perf | build | ci`.

Ví dụ: `fix(payment): retry khi gateway timeout vì lỗi 504 lúc cao tải`.

## Pull Request
- **Nhỏ và một mục đích.** PR > 400 dòng nên tách.
- Mô tả PR trả lời: *Vì sao? Thay đổi gì? Rủi ro gì? Test thế nào?*
- **Bắt buộc:** nếu PR đổi kiến trúc/luồng/module → cập nhật `.kb-local/` trong repo KB trung tâm (`projects/<tên>/.kb-local/`). Thường là PR riêng của repo KB; đính kèm liên kết trong PR code (xem `templates/kb-acceptance-checklist.md`).
- Chạy `prompts/review-kb-drift.md` trước khi xin review.

## Điều agent phải làm
- Không tự force-push lên nhánh chung.
- Không gộp nhiều mục đích vào một commit.
- Mỗi PR đổi code có ảnh hưởng knowledge → kèm thay đổi knowledge tương ứng.
