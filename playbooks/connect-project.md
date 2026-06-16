# Playbook: Nối project vào KB

Mục tiêu: mỗi project con chỉ giữ lại entry point tối thiểu cho Claude Code; toàn bộ
knowledge riêng project nằm trong KB trung tâm (`projects/<tên>/.kb-local/`). Project
trỏ tới KB qua symlink TUYỆT ĐỐI, **tôn trọng file agent sẵn có** (chỉ chèn một khối
nhỏ trỏ KB, không ghi đè).

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
Hoặc Terminal (sau khi thêm `dev-knowledge-base` vào PATH):
```bash
kb init              # chỉ các git repo
kb init --all        # gồm cả thư mục chưa git
```
Quét mọi project con, nối từng cái. **Idempotent** — chạy lại bất cứ lúc nào để nối
project mới, không ghi đè gì.

## Cách 2 — nối một project lẻ
```bash
cd project-a
kb link              # hoặc kb link /đường/dẫn/project-a
```
Chạy từ đâu cũng như nhau.

## Mỗi project con được gì
- `.kb -> /abs/path/dev-knowledge-base` (symlink tuyệt đối, không commit).
- `.kb-local -> /abs/path/dev-knowledge-base/projects/project-a/.kb-local` (symlink tuyệt đối, không commit).
- `CLAUDE.md` (tập trung Claude Code):
  - **Chưa có** → tạo mới, trỏ về `@.kb/AGENTS.md` + fallback nếu chưa link.
  - **Đã có** → GIỮ NGUYÊN nội dung, chỉ chèn một khối có marker `# >>> ... (agent-kb) >>>`.
    Chạy lại không chèn lần hai.
- `.claude/commands/` — slash command `/kb-scan`, `/kb-drift`, `/kb-onboard` (copy từ KB).

## Trong KB trung tâm được gì cho project
- `projects/project-a/.kb-local/` được tạo với skeleton `repo-map.md`, `llms.txt`.
- Knowledge chi tiết được điền sau khi chạy `/kb-scan` trong Claude Code.
- Các file hook/CI (nếu dùng `kb hook` / `kb ci`) cũng nằm ở đây.

## Sau khi nối (tùy chọn, mỗi project)
1. **Làm giàu knowledge:** trong Claude Code gõ `/kb-scan` → agent điền chi tiết vào
   `projects/project-a/.kb-local/` trong KB trung tâm và cập nhật `registry.yaml`.
2. **Commit:**
   - Trong project con: `CLAUDE.md`, `.claude/commands/`.
   - Trong KB trung tâm: `projects/project-a/.kb-local/`.
   - KHÔNG commit `.kb` / `.kb-local` (đã có trong `.gitignore` project con).

## Ghi chú symlink & git
- `.kb` và `.kb-local` là symlink ra ngoài repo → **gitignore** trong project con.
  Mỗi máy chạy `kb link` một lần sau clone để tái lập.
- Knowledge giờ versioned trong repo KB trung tâm, KHÔNG trong repo project con.
  Điều này giúp project con sạch sẽ, dễ dùng chung với các công cụ KB khác.
- Khối `(agent-kb)` trong `CLAUDE.md`: **đừng xoá**; muốn đổi luật thì sửa ở `dev-knowledge-base`,
  không sửa rải rác. Nếu project chưa link KB, agent sẽ bỏ qua tham chiếu `.kb`/`.kb-local`
  theo fallback trong khối đó.
