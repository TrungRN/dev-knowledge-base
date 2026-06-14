# Tương thích tool — hiện TẬP TRUNG Claude Code

Giai đoạn này KB chỉ thiết lập cho **Claude Code** cho gọn. Mỗi project chỉ có một file
agent: `CLAUDE.md` (do `link-kb.sh` tạo/giữ, trỏ `@.kb/AGENTS.md`). Nguồn luật chung vẫn
là `AGENTS.md` ở KB.

## Khi cần mở rộng sang tool khác (Cursor, Copilot, Gemini, Windsurf, Cline)
Mỗi tool đọc một tên file khác nhau, tất cả chỉ cần **trỏ về cùng `@.kb/AGENTS.md`**
(không copy nội dung). Khi đó thêm vào mỗi project:

| Tool | File | Nội dung |
|---|---|---|
| Claude Code | `CLAUDE.md` | `@.kb/AGENTS.md` (đã có) |
| Codex / Cursor / Windsurf | `AGENTS.md` | `@.kb/AGENTS.md` |
| Gemini CLI | `GEMINI.md` | `@.kb/AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` | "đọc .kb/AGENTS.md" |
| Cline | `.clinerules` | "đọc .kb/AGENTS.md" |

Lúc đó chỉ cần mở rộng `link-kb.sh` để sinh thêm các file trỏ này (logic y hệt phần
`CLAUDE.md` hiện có). Nguyên tắc không đổi: **một nguồn `AGENTS.md`, các file khác chỉ trỏ về.**
