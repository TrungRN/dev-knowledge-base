# Playbook: Nối project vào KB

Mục tiêu: mỗi project trỏ tới KB chung qua symlink `.kb` (một bản vật lý, không copy),
có `.kb-local/` cho knowledge riêng, và **tôn trọng file agent sẵn có** của project
(chỉ chèn một khối trỏ sang KB, không ghi đè).

## Yêu cầu vị trí
`dev-knowledge-base` đặt **ngang hàng** các project, trong cùng thư mục tổng:
```
~/Work/mywork/
├── dev-knowledge-base/   ← KB này
├── project-a/
└── project-b/
```

## Cách 1 — init MỘT LẦN cho tất cả (khuyến nghị)
Dễ nhất: mở Claude Code trên thư mục `dev-knowledge-base` rồi gõ **`/kb-init`**.
Hoặc Terminal:
```bash
./dev-knowledge-base/scripts/init-all.sh           # chỉ các git repo
./dev-knowledge-base/scripts/init-all.sh --all     # gồm cả thư mục chưa git
```
Quét mọi project con, nối từng cái. **Idempotent** — chạy lại bất cứ lúc nào để nối
project mới, không ghi đè gì.

## Cách 2 — nối một project lẻ
```bash
cd project-a
../dev-knowledge-base/scripts/link-kb.sh        # hoặc connect-project.sh (cùng tác dụng)
```
Hoặc truyền đường dẫn: `.../link-kb.sh ../project-a`. Chạy từ đâu cũng như nhau.

## Mỗi project được gì
- `.kb -> ../dev-knowledge-base` (symlink, không commit).
- `.kb-local/` + skeleton `repo-map.md`, `llms.txt` (commit; auto-scan điền chi tiết sau).
- `CLAUDE.md` (tập trung Claude Code):
  - **Chưa có** → tạo mới, trỏ về `@.kb/AGENTS.md`.
  - **Đã có** → GIỮ NGUYÊN nội dung, chỉ chèn một khối có marker `# >>> ... (agent-kb) >>>` trỏ sang KB. Chạy lại không chèn lần hai.
- `.claude/commands/` — slash command `/kb-scan`, `/kb-drift`, `/kb-onboard` (tự cài).

## Sau khi nối (tùy chọn, mỗi project)
1. **Làm giàu knowledge:** trong Claude Code gõ `/kb-scan` (hoặc bảo agent "Đọc `.kb/prompts/auto-scan.md` và làm theo") → điền chi tiết `.kb-local/repo-map.md`, đăng ký vào `registry.yaml`.
2. **Commit:** `.kb-local/`, `AGENTS.md`, các file trỏ. KHÔNG commit `.kb`.

## Ghi chú symlink & git
- `.kb` là symlink ra ngoài repo → **gitignore** (mỗi máy bố trí khác nhau). Người mới clone gõ `/kb-init` (hoặc `/kb-link`) một lần để tái lập.
- `.kb-local/` và các file agent thì **commit bình thường** (versioned cùng code).
- Khối `(agent-kb)` trong file agent: **đừng xoá**; muốn đổi luật thì sửa ở `dev-knowledge-base`, không sửa rải rác.
