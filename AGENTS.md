# AGENTS.md — Dev Knowledge Base (trung tâm)

File entry chuẩn cho mọi AI agent (Claude Code, Cursor, Copilot, Codex...).
Đây là KB **trung tâm**; mỗi project con có AGENTS.md riêng trỏ về đây qua `@.kb/...`.

## Luật vàng cho agent (đọc kỹ)

1. **Đọc index trước, fetch sau.** Luôn đọc `llms.txt` (KB này) và `.kb/repo-map.md` (project hiện tại) TRƯỚC. Chỉ mở file chi tiết khi thực sự cần. Không nạp cả KB hay cả codebase vào context.
2. **Cross-project qua registry.** Cần thông tin từ project anh em? Tra `registry.yaml` để biết đường dẫn/entry, rồi đọc `.kb` của project đó — đừng đoán.
3. **Repo là nguồn sự thật.** Knowledge ở repo thắng mọi nguồn khác. Nếu code và doc mâu thuẫn, tin code và báo drift.
4. **Sửa code thì sửa knowledge trong cùng PR.** Module mới, đổi luồng, đổi quyết định kiến trúc → cập nhật `.kb` (repo map, ADR) ngay trong PR đó. Xem `templates/kb-acceptance-checklist.md`.
5. **Theo chuẩn chung.** Tuân `standards/*` cho git, style, review, security, naming, indexing. Phần riêng theo stack nằm trong `.kb` của project.
6. **Không bịa.** Không chắc thì nói không chắc và chỉ ra cần đọc file/hỏi ai.

## Quy trình mặc định khi nhận BẤT KỲ task nào
Không cần người nhắc — tự thực hiện theo thứ tự:
1. Đọc `.kb-local/repo-map.md` + `llms.txt` để định vị (đừng quét cả repo).
2. Nếu task liên quan project khác → tra `.kb/registry.yaml` trước.
3. Làm task theo `standards/*`.
4. Nếu thay đổi đụng module/API/luồng/quyết định → cập nhật `.kb-local/` trong cùng PR.
5. Trước khi xong → đối chiếu `templates/kb-acceptance-checklist.md`.

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
project-legacy/
├── AGENTS.md          # NGUỒN SỰ THẬT: @import .kb/standards/*, phần riêng project
├── CLAUDE.md          # file trỏ: chỉ chứa "@AGENTS.md" (để Claude Code nhận)
├── .kb -> ../dev-knowledge-base   # symlink tới KB trung tâm (một bản vật lý)
└── .kb-local/         # knowledge RIÊNG của project: repo-map.md, llms.txt, adr/
```

> Mỗi tool đọc một tên file khác nhau. AGENTS.md là nguồn duy nhất; CLAUDE.md (và
> Copilot/Gemini nếu dùng) chỉ là file trỏ. Xem `standards/tool-compatibility.md`.

> Lưu ý: `.kb` là symlink chỉ-đọc tới KB chung. Knowledge riêng của project để trong
> `.kb-local/` (versioned cùng repo project). Đừng ghi vào `.kb`.
