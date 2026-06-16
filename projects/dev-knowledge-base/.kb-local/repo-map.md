# Repo map — dev-knowledge-base (chính KB)

> Mục lục cho agent đang làm việc **trên chính repo KB trung tâm** (không phải project con).
> KB tự áp dụng luật của mình: đọc file này + `llms.txt` TRƯỚC khi sửa, đừng quét cả repo.
> Đây là tài liệu thật (không phải skeleton); refresh theo PR khi cấu trúc KB đổi.

- **Cập nhật lần cuối:** 2026-06-16
- **Loại repo:** KB trung tâm (Markdown + Bash, không build/compile)
- **Stack:** Markdown · Bash (script POSIX-ish, cần `bash`) · YAML (registry). Tùy chọn: `python3`/`jq` để merge JSON (có fallback `sed`/`awk` nếu thiếu).

## Lệnh hay dùng
```
kb help                 # danh sách lệnh
kb init [--all]         # nối tất cả project ngang hàng vào KB
kb link [path]          # nối một project
kb check [base] [--strict]   # drift check mechanical
bash -n scripts/*.sh kb # syntax-check toàn bộ script trước khi commit
```
Không có test runner; "test" = `bash -n` + chạy thử `kb <lệnh>` trên một project nháp.

## Gotchas / lưu ý
- **Script tự định vị KB** qua `BASH_SOURCE`, KHÔNG phụ thuộc `$PWD`. `init-all.sh` lấy thư mục tổng = `dirname "$KB_DIR"`, nên `kb init` chạy ở đâu cũng quét đúng thư mục cha của KB.
- **`id` của project = tên thư mục project** (link-kb dùng `basename`). Đường dẫn knowledge luôn là `projects/<tên-thư-mục>/.kb-local/`. Giữ `registry.yaml#id` khớp tên thư mục.
- **`.kb` / `.kb-local` trong project con là symlink tuyệt đối, không commit** (link-kb thêm vào `.gitignore` của project con). Trong chính repo KB thì KHÔNG có symlink này.
- **Tôn trọng `CLAUDE.md` sẵn có:** link-kb chỉ chèn/cập nhật khối giữa marker `>>> ... >>>` / `<<< ... <<<`, không đụng phần còn lại.
- **`python3`/`jq` là tùy chọn:** `link-kb.sh` và `install-claude-hook.sh` có fallback khi thiếu (sed/awk cho block CLAUDE.md; jq cho settings.json).

## Cây thư mục (rút gọn)
```
kb                      # ⭐ CLI một cổng (dispatcher) → gọi scripts/
AGENTS.md               # NGUỒN SỰ THẬT: luật chung cho mọi agent
CLAUDE.md               # = @AGENTS.md (để Claude Code đọc chính KB)
llms.txt                # index điều hướng toàn KB — đọc trước
registry.yaml           # danh bạ project anh em (MCP-ready)
.claude/commands/       # slash command cấp KB: /kb-init, /kb-link
standards/              # convention chung: git-flow, code-style, code-review, security, naming, indexing, tool-compatibility
decisions/              # ADR (knowledge retention)
templates/              # khung cho project con
  ci/                   #   pre-push, gitlab, github (opt-in)
  hooks/                #   Claude Code hook (ép đọc index) + settings.json
  commands/             #   slash command tự cài khi link: kb-scan, kb-drift, kb-onboard
playbooks/              # quy trình: onboarding, dev-workflow, connect-project, automate-drift-check, troubleshooting
prompts/                # prompt vận hành agent: auto-scan, review-kb-drift
projects/               # knowledge RIÊNG từng project: projects/<tên>/.kb-local/
scripts/                # logic thực thi (xem dưới)
```

## Module / khu vực chính

### CLI dispatcher — `kb`
- **Trách nhiệm:** điểm vào duy nhất; map lệnh → script trong `scripts/`.
- **File then chốt:** `kb`
- **Phụ thuộc:** mọi script trong `scripts/`.
- **Lệnh:** `init|bootstrap` → `init-all.sh` · `link` → `link-kb.sh` · `scan` → link + `detect-stack.sh` · `check` → `kb-drift-check.sh` · `drift` → in hướng dẫn AI · `stack` → `detect-stack.sh` · `hook` → `install-claude-hook.sh` · `ci` → `install-hooks.sh` · `path` → in `$KB_DIR`.

### scripts/ — logic thực thi
- **`init-all.sh`** — quét project ngang hàng KB, gọi `link-kb.sh` cho từng cái. Bỏ chính KB và thư mục ẩn; `--all` để gồm cả non-git.
- **`link-kb.sh`** — nối MỘT project: tạo `projects/<tên>/.kb-local/` (skeleton từ templates), symlink `.kb`/`.kb-local` tuyệt đối, gitignore chúng, chèn/cập nhật khối KB trong `CLAUDE.md`, copy slash command. Migrate `.kb-local/` thật cũ. Idempotent.
- **`kb-drift-check.sh`** — drift mechanical: so code đổi (repo project) vs knowledge đổi (`projects/<tên>/.kb-local/` trong repo KB). Có `--strict`. Tính cả thay đổi chưa commit + untracked.
- **`detect-stack.sh`** — dò stack qua manifest (package.json, pom.xml, go.mod...).
- **`install-claude-hook.sh`** — tầng cứng: đặt hook vào `.kb-local/hooks/`, merge `UserPromptSubmit` vào `.claude/settings.json` (python3 → jq → hướng dẫn tay).
- **`install-hooks.sh`** — đặt template pre-push/CI vào `.kb-local/ci/` (opt-in).
- **`connect-project.sh`** — DEPRECATED shim → `link-kb.sh` (giữ tương thích tên cũ).

### Tài liệu (text, không code)
- **`standards/`** — luật bất biến; agent tuân theo khi làm task.
- **`playbooks/`** — quy trình từng bước cho người + agent.
- **`prompts/`** — prompt bỏ vào agent để sinh/drift knowledge.
- **`templates/`** — nguồn copy cho project con (repo-map, adr, llms, command, hook, ci).

## Entry points
- `kb` — mọi thao tác người dùng bắt đầu ở đây.
- `.claude/commands/kb-init.md`, `kb-link.md` — entry cho Claude Code (slash command cấp KB).
- `AGENTS.md` — entry "luật" cho mọi agent khi mở repo.

## Luồng chính

### Nối một project mới vào KB
1. `kb link <path>` → `scripts/link-kb.sh`
2. Tạo `projects/<tên>/.kb-local/{repo-map.md,llms.txt,adr/}` từ `templates/`
3. Symlink `.kb` + `.kb-local` (tuyệt đối) trong project con, thêm vào `.gitignore`
4. Chèn/cập nhật khối `@.kb/AGENTS.md` + fallback trong `CLAUDE.md`
5. Copy `templates/commands/*.md` → `.claude/commands/`

### Drift check trước MR
1. `kb check` → `scripts/kb-drift-check.sh`
2. Lấy diff repo project (code) + diff repo KB tại `projects/<tên>/.kb-local/` (knowledge)
3. Code đổi mà knowledge không đổi → cảnh báo (hoặc chặn nếu `--strict`)

## Phần mong manh / nợ kỹ thuật
- Drift check dựa `origin/main`; project/KB mới hoặc remote khác tên → rơi về fallback `HEAD~1` (có thể thiếu chính xác).
- Merge JSON settings.json ưu tiên `python3`, rồi `jq`; thiếu cả hai chỉ in hướng dẫn tay.
- `projects/` versioned cùng repo KB → PR knowledge và PR code nằm ở hai repo khác nhau (xem `playbooks/dev-workflow.md`).
