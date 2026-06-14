# Dev KB — Knowledge Base trung tâm cho developer & AI agent

KB dùng chung cho mọi project. Mục tiêu: chuẩn hoá quy trình dev, giữ lại tri thức
(knowledge retention), onboard người mới nhanh, và để AI agent (Claude Code, Cursor,
Copilot, Gemini...) đọc được & làm việc chính xác trên codebase legacy.

> **Bạn là ai?**
> - *Lần đầu đưa một project vào KB* → đọc [Quick start A](#quick-start-a--nối-project-vào-kb).
> - *Dev mới vào project đã có KB* → đọc [Quick start B](#quick-start-b--dev-mới-vào-project-đã-có-kb).
> - *Muốn hiểu KB hoạt động ra sao* → đọc [Có gì trong KB](#có-gì-trong-kb) và [Triết lý](#triết-lý-thiết-kế).

---

## Quick start A — Nối project vào KB
Đặt project **ngang hàng** với thư mục `dev-kb` (cùng nằm trong `~/Work/`).

```bash
# 1) Đứng TRONG project, nối vào KB (tạo symlink .kb + .kb-local + file trỏ đa tool)
cd ../ten-project
../dev-kb/scripts/connect-project.sh

# 2) Sinh knowledge: mở AI agent trong project, đưa nội dung file này cho nó chạy:
#    .kb/prompts/auto-scan.md   → tạo AGENTS.md + .kb-local/repo-map.md + llms.txt

# 3) (Tùy chọn) Ép Claude Code luôn đọc index trước mỗi prompt:
.kb/scripts/install-claude-hook.sh

# 4) Commit: AGENTS.md, các file trỏ, .kb-local/  (KHÔNG commit symlink .kb — đã gitignore)
```
Chi tiết: `playbooks/connect-project.md`.

## Quick start B — Dev mới vào project đã có KB
```bash
# Nếu .kb chưa có (symlink không theo git): nối lại một lần
cd ten-project && ../dev-kb/scripts/connect-project.sh
```
Rồi đọc theo thứ tự: `AGENTS.md` → `.kb-local/repo-map.md` → `.kb-local/llms.txt`.
Lộ trình onboard đầy đủ: `playbooks/onboarding.md`. Quy trình làm việc hằng ngày:
`playbooks/dev-workflow.md`.

> Agent **tự** đọc index, tra registry, cập nhật knowledge — vì AGENTS.md được nạp tự
> động. Bạn chỉ ra task bình thường, không phải nhắc.

## Trước khi tạo MR — tự kiểm
```bash
.kb/scripts/kb-drift-check.sh        # cảnh báo nếu code đổi mà quên cập nhật .kb-local/
```
Không cần cài gì, không đụng git/CI. Tự động hoá (hook/CI) là tùy chọn, xem
`playbooks/automate-drift-check.md`.

---

## Có gì trong KB

```
dev-kb/
├── AGENTS.md            # NGUỒN luật cho agent (các file CLAUDE.md/GEMINI.md... chỉ trỏ về đây)
├── llms.txt             # Bản đồ điều hướng toàn KB — agent đọc trước tiên
├── registry.yaml        # Danh bạ project anh em (schema MCP-ready)
├── standards/           # Convention chung: git, code-style, review, security, naming, indexing, tool-compatibility
├── decisions/           # ADR — log quyết định kiến trúc (knowledge retention)
├── templates/           # Khung cho project con: AGENTS, repo-map, ADR, checklist
│   ├── ci/              #   file CI/hook (pre-push, gitlab, github) — opt-in
│   └── hooks/           #   Claude Code hook (ép đọc index)
├── playbooks/           # Quy trình: onboarding, dev-workflow, connect-project, automate-drift-check, troubleshooting
├── prompts/             # Prompt vận hành: auto-scan (sinh knowledge), review-kb-drift
└── scripts/             # connect-project, add-tool-pointers, install-hooks, install-claude-hook, kb-drift-check, detect-stack
```

## Lưu ý quan trọng

- **Commit gì:** `AGENTS.md`, các file trỏ (`CLAUDE.md`, `GEMINI.md`, `.cursorrules`...), và `.kb-local/`. **Đừng commit** symlink `.kb` (đã gitignore — nó phụ thuộc máy; clone về chạy lại `connect-project.sh`).
- **Một nguồn sự thật:** chỉ `AGENTS.md` chứa nội dung; mọi file tool khác chỉ trỏ về nó. Sửa luật thì sửa ở `AGENTS.md`, đừng rải khắp nơi. (`standards/tool-compatibility.md`)
- **Knowledge riêng ở `.kb-local/`**, không ghi vào `.kb` (đó là KB chung, chỉ-đọc qua symlink).
- **CI cần lead duyệt:** bật drift check trên MR là thay đổi CI dùng chung → chờ thông qua. Trong lúc chờ, dùng script tự chạy `kb-drift-check.sh` (mức 1).
- **Tự động 2 tầng:** AGENTS.md tự nạp lo phần lớn (mềm); `install-claude-hook.sh` ép cứng cho Claude Code nếu cần chắc chắn.

## Triết lý thiết kế

| Nguyên tắc | Cụ thể |
|---|---|
| **KB ngang hàng, một bản vật lý** | `dev-kb` là repo độc lập, ngang hàng các project. Chỉ **một** bản. |
| **Tham chiếu, không sao chép** | Project trỏ qua symlink `.kb`. Không submodule/copy → không có gì để "đồng bộ", không xung đột git. |
| **Repo là nguồn sự thật** | Knowledge sống cùng code, versioned, review trong cùng PR. Confluence (nếu có) chỉ là đầu ra phái sinh. |
| **Template auto-scan, stack-agnostic** | AI quét project, tự phát hiện stack, sinh knowledge. Không hard-code ngôn ngữ. |
| **Index text, tiết kiệm token** | `llms.txt` + repo map để agent fetch đúng thứ cần. Không vector/embedding. |
| **Bảo trì theo PR** | Drift check so code với knowledge; sửa code thì sửa knowledge trong cùng PR. |

## Lộ trình
- **Giai đoạn 1 (hiện tại):** Repo-only, symlink, index text. 90% giá trị.
- **Giai đoạn 2 (khi cần):** Bọc `dev-kb` thành MCP server đọc `registry.yaml` để query cross-project không phụ thuộc đường dẫn; sync 1 chiều repo → Confluence; AI drift trong CI.
