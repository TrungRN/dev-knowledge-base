# Playbook: Onboard dev mới vào project legacy

Lộ trình đọc theo thứ tự — từ tổng quan tới chi tiết, tiết kiệm thời gian & token.

## 30 phút đầu — bức tranh lớn
1. `.kb/README.md` — KB hoạt động thế nào.
2. Project's `AGENTS.md` — project này là gì, stack, lệnh build/run/test.
3. `.kb-local/repo-map.md` — mục lục: module nào, entry point ở đâu, luồng chính.

## Giờ đầu — chạy được
4. Làm theo mục "Lệnh hay dùng" trong `AGENTS.md`: cài deps, chạy local, chạy test.
5. Nếu kẹt → `.kb/playbooks/troubleshooting.md`.

## Ngày đầu — hiểu sâu một luồng
6. Chọn một "Luồng nghiệp vụ chính" trong `repo-map.md`, lần theo file từ entry point.
7. Đọc `.kb-local/glossary.md` cho thuật ngữ domain & tên cũ khó hiểu.
8. Đọc `.kb-local/adr/` — *vì sao* các quyết định lớn như hiện tại.

## Khi bắt đầu code
9. Theo `.kb/standards/*` (git, style, review, security, naming).
10. Trước khi mở PR: chạy `.kb/prompts/review-kb-drift.md`; theo `.kb/standards/code-review.md`.

## Agent tự làm gì (bạn KHÔNG phải nhắc)
Những việc dưới đây đã là **luật trong `AGENTS.md`**, và agent (Claude Code, Cursor,
Codex...) **tự nạp AGENTS.md ngay đầu mỗi phiên** — nên nó tự làm mà bạn không cần dặn:
- Đọc `repo-map.md` + `llms.txt` trước khi trả lời (đúng & rẻ token hơn).
- Tra `.kb/registry.yaml` khi cần thông tin project khác.
- Sửa `.kb-local/` ngay trong PR khi đụng module/API/luồng (văn hoá của KB).

Bạn chỉ cần ra task bình thường ("thêm chức năng X", "vì sao luồng Y lỗi"). Muốn agent
tuân chặt hơn, sửa luật ở `AGENTS.md` (một nguồn) — đừng nhắc lại trong từng prompt.

> Muốn ÉP chắc tay (tầng cứng, Claude Code): chạy `.kb/scripts/install-claude-hook.sh`
> để cài hook tự chèn nhắc "đọc index trước" vào mỗi prompt. Trường hợp tool/web UI
> không tự nạp file chỉ-dẫn: dán `AGENTS.md` vào đầu phiên.
