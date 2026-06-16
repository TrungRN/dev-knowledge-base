# AGENTS.md — Dev Knowledge Base (trung tâm)

File entry chuẩn cho mọi AI agent (Claude Code, Cursor, Copilot, Codex...).
Đây là KB **trung tâm**; mỗi project con có AGENTS.md riêng trỏ về đây qua `@.kb/...`.

## Luật vàng cho agent (đọc kỹ)

1. **Đọc index trước, fetch sau.** Luôn đọc `llms.txt` (KB này) và `.kb/repo-map.md` (project hiện tại) TRƯỚC. Chỉ mở file chi tiết khi thực sự cần. Không nạp cả KB hay cả codebase vào context.
2. **Cross-project qua registry.** Cần thông tin từ project anh em? Tra `registry.yaml` để biết đường dẫn/entry, rồi đọc `.kb` của project đó — đừng đoán.
3. **Repo là nguồn sự thật.** Knowledge ở repo thắng mọi nguồn khác. Nếu code và doc mâu thuẫn, tin code và báo drift.
4. **Sửa code thì sửa knowledge liên quan.** Module mới, đổi luồng, đổi quyết định kiến trúc → cập nhật `.kb-local/` (repo map, ADR). Knowledge riêng project giờ nằm trong repo KB trung tâm (`projects/<tên>/.kb-local/`), nên PR sửa knowledge thường là PR riêng của repo KB. Xem `templates/kb-acceptance-checklist.md`.
5. **Theo chuẩn chung.** Tuân `standards/*` cho git, style, review, security, naming, indexing. Phần riêng theo stack nằm trong `.kb` của project.
6. **Không bịa.** Không chắc thì nói không chắc và chỉ ra cần đọc file/hỏi ai.

## Quy trình mặc định khi nhận BẤT KỲ task nào
Không cần người nhắc — tự thực hiện theo thứ tự:
1. Đọc `.kb-local/repo-map.md` + `llms.txt` để định vị (đừng quét cả repo).
2. Nếu task liên quan project khác → tra `.kb/registry.yaml` trước.
3. Làm task theo `standards/*`.
4. Nếu thay đổi đụng module/API/luồng/quyết định → cập nhật `.kb-local/` trong cùng PR.
5. Trước khi xong → đối chiếu `templates/kb-acceptance-checklist.md`.

> **Đang đứng trong CHÍNH repo KB này (dev-knowledge-base), không phải project con?**
> Không có symlink `.kb`/`.kb-local` ở đây. Thay vào đó đọc index của bản thân KB:
> `projects/dev-knowledge-base/.kb-local/repo-map.md` + `llms.txt` (gốc repo), rồi tra
> `registry.yaml`/`templates/` trực tiếp (bỏ tiền tố `.kb/`). KB tự áp dụng luật của mình.

## Cách dùng KB này

- **Onboard / hiểu nhanh project:** đọc `.kb/AGENTS.md` của project → `.kb/repo-map.md` → `playbooks/onboarding.md`.
- **Sinh knowledge cho project legacy chưa có KB:** chạy `prompts/auto-scan.md`.
- **Review trước merge:** chạy `prompts/review-kb-drift.md` trên diff của PR.
- **Tra project khác:** `registry.yaml`.

## Quy ước chung (tóm tắt — chi tiết trong standards/)

- **Git:** xem `standards/git-flow.md`. Commit theo Conventional Commits. PR nhỏ, có mô tả "vì sao".
- **Bảo mật:** không commit secret. Xem `standards/security.md`.
- **Index/token:** mọi project phải có `llms.txt` + `repo-map.md` dạng text. Không vector. Xem `standards/indexing.md`.

## Cấu trúc tham chiếu

```
dev-knowledge-base/                    # KB trung tâm (một bản vật lý)
├── AGENTS.md                          # NGUỒN SỰ THẬT: luật chung cho mọi agent
├── llms.txt
├── registry.yaml
├── projects/
│   └── project-legacy/
│       └── .kb-local/                 # knowledge RIÊNG của project: repo-map.md, llms.txt, adr/
│
project-legacy/                        # repo project con
├── CLAUDE.md                          # file trỏ: khối nhỏ → @.kb/AGENTS.md + fallback
├── .kb -> /abs/path/dev-knowledge-base            # symlink TUYỆT ĐỐI tới KB
├── .kb-local -> /abs/path/dev-knowledge-base/projects/project-legacy/.kb-local   # symlink TUYỆT ĐỐI
└── .claude/commands/                  # /kb-scan, /kb-drift, /kb-onboard (copy từ KB)
```

> Mỗi tool đọc một tên file khác nhau. AGENTS.md là nguồn duy nhất; CLAUDE.md (và
> Copilot/Gemini nếu dùng) chỉ là file trỏ. Xem `standards/tool-compatibility.md`.

> Lưu ý:
> • `.kb` là symlink chỉ-đọc tới KB chung.
> • `.kb-local/` là symlink tới `projects/<tên-project>/.kb-local/` trong KB trung tâm.
>   Knowledge riêng project giờ versioned cùng repo KB, KHÔNG nằm trong repo project con.
> • CLAUDE.md trong project con có fallback: nếu `.kb` chưa được link, agent bỏ qua mọi
>   tham chiếu `.kb`/`.kb-local` và tiếp tục làm việc bình thường.
