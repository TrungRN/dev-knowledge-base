# Tương thích đa tool — một nguồn, đủ bộ file trỏ

Mỗi AI coding tool tìm một tên file chỉ-dẫn khác nhau. Để **một** nội dung phục vụ
mọi tool mà không lệch nhau: `AGENTS.md` là **nguồn sự thật duy nhất**; mọi tool khác
dùng một **file trỏ** mỏng (import hoặc chỉ-dẫn) về `AGENTS.md`. Không copy nội dung.

> Tài liệu ngoài kia mâu thuẫn về việc tool nào đã đọc AGENTS.md native. Cách an toàn
> cho repo dùng chung: **cứ tạo đủ bộ file trỏ**. Tool đã đọc native → file trỏ vô hại;
> tool chưa → file trỏ cứu. Script `scripts/add-tool-pointers.sh` tạo tất cả tự động.

## Ma trận tool ↔ file

| Tool | File nó đọc | Nội dung file trỏ |
|---|---|---|
| Codex CLI | `AGENTS.md` | — (nguồn gốc) |
| **Claude Code** | `CLAUDE.md` | `@AGENTS.md` (import) |
| **Gemini CLI** | `GEMINI.md` | `@AGENTS.md` (import) |
| **GitHub Copilot** | `.github/copilot-instructions.md` | chỉ-dẫn "đọc AGENTS.md" |
| **Cursor** | `AGENTS.md` native; `.cursorrules` (cũ) | chỉ-dẫn (fallback bản cũ) |
| **Windsurf** | `AGENTS.md` native; `.windsurfrules` (cũ) | chỉ-dẫn |
| **Cline** | `.clinerules` | chỉ-dẫn |

## Tạo đủ bộ (tự động)
Chạy `scripts/connect-project.sh` khi nối project sẽ **tự tạo cả bộ**. Hoặc chạy riêng:
```bash
./scripts/add-tool-pointers.sh [đường-dẫn-project]   # mặc định: thư mục hiện tại
```
Script idempotent: file đã có thì bỏ qua, không ghi đè.

## Nguyên tắc
- **Chỉ AGENTS.md chứa nội dung.** Mọi file khác chỉ trỏ về nó.
- **Ưu tiên import** (`@AGENTS.md`) cho tool hỗ trợ (Claude Code, Gemini) → giữ đúng một nguồn. Tool không hỗ trợ thì để file trỏ ghi rõ "đọc AGENTS.md", đừng dán nội dung.
- **File trỏ NÊN commit** (khác symlink `.kb` bị gitignore) — để mọi người clone về là có ngay, không cần tool nào cũng cài.
- **Khi tool ra bản mới đọc AGENTS.md native:** có thể xoá file trỏ tương ứng, nhưng giữ lại cũng không hại.

## Ví dụ nội dung
`CLAUDE.md` / `GEMINI.md`:
```
@AGENTS.md
```
`.github/copilot-instructions.md` / `.cursorrules` / `.windsurfrules` / `.clinerules`:
```
# Hướng dẫn AI cho project này nằm ở AGENTS.md (gốc repo).
Hãy đọc và tuân theo `AGENTS.md`, gồm cả các file nó tham chiếu trong `.kb/` và `.kb-local/`.
```
