# Dev Knowledge Base — KB trung tâm cho developer & AI agent

KB dùng chung cho mọi project. Mục tiêu: chuẩn hoá quy trình dev, giữ lại tri thức
(knowledge retention), onboard người mới nhanh, và để AI agent (Claude Code, Cursor,
Copilot, Gemini...) đọc được & làm việc chính xác trên codebase legacy.

> **Bạn là ai?**
> - *Lần đầu đưa một project vào KB* → đọc [Quick start A](#quick-start-a--nối-project-vào-kb).
> - *Dev mới vào project đã có KB* → đọc [Quick start B](#quick-start-b--dev-mới-vào-project-đã-có-kb).
> - *Muốn hiểu KB hoạt động ra sao* → đọc [Có gì trong KB](#có-gì-trong-kb) và [Triết lý](#triết-lý-thiết-kế).

---

> **Hiện tập trung Claude Code.** Mỗi project chỉ có một file agent: `CLAUDE.md`. Các
> tool khác (Cursor, Gemini...) để dành, mở rộng sau — xem `standards/tool-compatibility.md`.

## Cài lệnh `kb` (một lần)

Mọi thao tác gói trong một lệnh `kb`. Cho vào PATH để gõ ở bất cứ đâu:
```bash
# từ thư mục tổng (vd ~/Work/mywork)
echo 'export PATH="'"$PWD"'/dev-knowledge-base:$PATH"' >> ~/.zshrc && source ~/.zshrc
kb help
```

## Quick start A — Nối project vào KB

Đặt `dev-knowledge-base` **ngang hàng** các project (cùng thư mục tổng).

**Cách 1 — trong Claude Code (khuyên dùng, không cần Terminal):**
Mở Claude Code trên thư mục `dev-knowledge-base`, gõ:
```
/kb-init
```
Claude sẽ nối mọi project vào KB và báo kết quả.

**Cách 2 — Terminal:**
```bash
cd ~/Work/mywork && kb init       # --all để gồm cả thư mục chưa git
```

Mỗi project được: symlink `.kb`, skeleton `.kb-local/`, `CLAUDE.md` trỏ sang KB, và
**slash command tự cài** (`/kb-scan`, `/kb-drift`, `/kb-onboard`). **Tôn trọng `CLAUDE.md`
sẵn có**: nếu project đã có thì GIỮ NGUYÊN, chỉ chèn một khối trỏ KB. Chạy lại bất cứ lúc
nào (idempotent). Nối một project lẻ: `/kb-link` hoặc `kb link`.

**Sau đó, mỗi project (tùy chọn):**
```bash
kb hook        # ép Claude Code đọc index trước mỗi prompt
# Làm giàu knowledge bằng AI: trong Claude Code gõ /kb-scan
# Commit: CLAUDE.md, .kb-local/, .claude/commands/  (KHÔNG commit .kb — đã gitignore)
```

## Quick start B — Dev mới vào project đã có KB
```bash
cd ten-project && kb link     # tái lập .kb + slash command nếu chưa có
```
Trong Claude Code gõ `/kb-onboard` để agent tóm tắt project cho bạn.

> Agent **tự** đọc index, tra registry, cập nhật knowledge — vì `CLAUDE.md` (→ KB) được
> nạp tự động. Bạn chỉ ra task bình thường, không phải nhắc.

## Trước khi tạo MR — tự kiểm
```bash
kb check        # cảnh báo nếu code đổi mà quên cập nhật .kb-local/
```
Không cần cài gì, không đụng git/CI. Tự động hoá (hook/CI) là tùy chọn: `kb ci`
(xem `playbooks/automate-drift-check.md`).

## Bảng lệnh `kb`

| Lệnh | Làm gì |
|---|---|
| `kb init [--all]` | Nối tất cả project vào KB (hoặc `/kb-init` trong Claude Code) |
| `kb link [path]` | Nối một project |
| `kb scan` | Cách sinh knowledge bằng AI (hoặc `/kb-scan` trong Claude Code) |
| `kb check [base] [--strict]` | Kiểm drift nhanh trước khi tạo MR |
| `kb hook` | Cài Claude Code hook (ép đọc index) |
| `kb ci` | Cài drift check cho pre-push/CI (opt-in) |
| `kb stack [path]` | Dò stack project |
| `kb help` | Trợ giúp |

> **Slash command** (gõ trong Claude Code): cấp KB có `/kb-init`, `/kb-link` (mở Claude Code
> trên thư mục KB). Mỗi project có `/kb-scan`, `/kb-drift`, `/kb-onboard` — tự cài khi nối.

---

## Có gì trong KB

```
dev-knowledge-base/
├── kb                   # ⭐ CLI một cổng — kb init | link | scan | check | hook | help
├── .claude/commands/    # slash command cấp KB: /kb-init, /kb-link
├── AGENTS.md            # NGUỒN luật chung (CLAUDE.md ở mỗi project chỉ trỏ về đây)
├── CLAUDE.md            # = @AGENTS.md (để Claude Code đọc chính KB này)
├── llms.txt             # Bản đồ điều hướng toàn KB — agent đọc trước tiên
├── registry.yaml        # Danh bạ project anh em (schema MCP-ready)
├── standards/           # Convention chung: git, code-style, review, security, naming, indexing, tool-compatibility
├── decisions/           # ADR — log quyết định kiến trúc (knowledge retention)
├── templates/           # Khung cho project con: repo-map, ADR, checklist
│   ├── ci/              #   file CI/hook (pre-push, gitlab, github) — opt-in
│   ├── hooks/           #   Claude Code hook (ép đọc index)
│   └── commands/        #   slash command (/kb-scan...) — tự cài khi link
├── playbooks/           # Quy trình: onboarding, dev-workflow, connect-project, automate-drift-check, troubleshooting
├── prompts/             # Prompt vận hành: auto-scan (sinh knowledge), review-kb-drift
└── scripts/             # init-all, link-kb, connect-project, install-hooks, install-claude-hook, kb-drift-check, detect-stack
```

## Lưu ý quan trọng

- **Tập trung Claude Code:** mỗi project chỉ có `CLAUDE.md` (trỏ `@.kb/AGENTS.md`). Tool khác để dành (`standards/tool-compatibility.md`).
- **Commit gì trong project:** `CLAUDE.md`, `.kb-local/`, `.claude/commands/`. **Đừng commit** symlink `.kb` (đã gitignore; clone về chạy lại `kb link`).
- **Một nguồn sự thật:** chỉ `AGENTS.md` (ở KB) chứa luật; `CLAUDE.md` chỉ trỏ về. Sửa luật ở KB, đừng rải khắp nơi.
- **Knowledge riêng ở `.kb-local/`** (commit cùng code), không ghi vào `.kb` (KB chung, chỉ-đọc qua symlink).
- **CI cần lead duyệt** (`kb ci`); trong lúc chờ dùng `kb check` (chạy tay, không đụng git).
- **Tự động 2 tầng:** `CLAUDE.md` tự nạp lo phần lớn; `kb hook` ép cứng nếu cần chắc chắn.

## Triết lý thiết kế

| Nguyên tắc | Cụ thể |
|---|---|
| **KB ngang hàng, một bản vật lý** | `dev-knowledge-base` là repo độc lập, ngang hàng các project. Chỉ **một** bản. |
| **Tham chiếu, không sao chép** | Project trỏ qua symlink `.kb`. Không submodule/copy → không có gì để "đồng bộ", không xung đột git. |
| **Repo là nguồn sự thật** | Knowledge sống cùng code, versioned, review trong cùng PR. Confluence (nếu có) chỉ là đầu ra phái sinh. |
| **Template auto-scan, stack-agnostic** | AI quét project, tự phát hiện stack, sinh knowledge. Không hard-code ngôn ngữ. |
| **Index text, tiết kiệm token** | `llms.txt` + repo map để agent fetch đúng thứ cần. Không vector/embedding. |
| **Bảo trì theo PR** | Drift check so code với knowledge; sửa code thì sửa knowledge trong cùng PR. |

## Lộ trình
- **Giai đoạn 1 (hiện tại):** Repo-only, symlink, index text. 90% giá trị.
- **Giai đoạn 2 (khi cần):** Bọc `dev-knowledge-base` thành MCP server đọc `registry.yaml` để query cross-project không phụ thuộc đường dẫn; sync 1 chiều repo → Confluence; AI drift trong CI.
