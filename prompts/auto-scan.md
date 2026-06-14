# Prompt: Auto-scan & sinh knowledge cho project legacy

Đưa prompt này cho agent (Claude Code / Cursor...) khi chạy **bên trong thư mục một
project chưa có KB**. Agent sẽ tự phát hiện stack và sinh knowledge từ template.
Stack-agnostic: không giả định ngôn ngữ trước.

---

**Vai trò:** Bạn là kỹ sư đang lập bản đồ một codebase legacy để vừa cho người mới
onboard, vừa cho AI agent đọc hiệu quả (tiết kiệm token). Làm theo các bước, KHÔNG
sửa code nguồn — chỉ tạo file trong `.kb-local/`.

### Bước 1 — Phát hiện stack (tất định, qua manifest)
Quét gốc & thư mục con tìm các dấu hiệu, suy ra ngôn ngữ/framework/package manager/lệnh:
- `package.json` → Node/JS-TS (xem `scripts` để lấy lệnh build/run/test, `dependencies` để lấy framework: react/vue/express/nest...).
- `pom.xml` / `build.gradle` → Java/Kotlin (Maven/Gradle); tìm spring-boot...
- `requirements.txt` / `pyproject.toml` / `Pipfile` → Python (pip/poetry/uv); django/flask/fastapi...
- `go.mod` → Go. `Cargo.toml` → Rust. `composer.json` → PHP. `Gemfile` → Ruby. `*.csproj` → .NET.
- `Dockerfile` / `docker-compose.yml` / `Makefile` → lấy thêm lệnh build/run.
- Linter/formatter: `.editorconfig`, `.eslintrc*`, `.prettierrc*`, `ruff.toml`, `checkstyle`, `.golangci*`...
Ghi rõ những gì **chắc chắn đọc được**; cái nào suy đoán thì đánh dấu "(cần xác nhận)".

### Bước 2 — Lập repo map
Tạo `.kb-local/repo-map.md` từ `.kb/templates/repo-map.md`:
- Cây thư mục rút gọn (chỉ thư mục quan trọng + vai trò 1 dòng).
- Module/khu vực chính: trách nhiệm, file then chốt, phụ thuộc.
- **Signature** public quan trọng (KHÔNG thân hàm) kèm `path:line`.
- Entry points (main/route/handler/job).
- Luồng nghiệp vụ chính: lần theo từ entry point, mô tả 3–7 bước, trỏ file.
- Phần mong manh / nợ kỹ thuật / lib lỗi thời phát hiện được.

### Bước 3 — Sinh entry & index
- **`AGENTS.md` ở GỐC project** (không phải trong `.kb-local/`) từ `.kb/templates/project-AGENTS.md` — đây là NGUỒN nội dung, đặt ở gốc để mọi tool tìm thấy. Điền stack, lệnh, gotchas.
- **File trỏ đa tool** (`CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `.clinerules`, `.github/copilot-instructions.md`...) do `connect-project.sh` tạo sẵn. Nếu thiếu, chạy `.kb/scripts/add-tool-pointers.sh`. KHÔNG dán nội dung vào chúng — chúng chỉ trỏ về AGENTS.md. Xem `.kb/standards/tool-compatibility.md`.
- `.kb-local/llms.txt` từ `.kb/templates/project-llms.txt`.
- `.kb-local/repo-map.md` (đã tạo ở Bước 2).
- `.kb-local/code-style.md`: formatter/linter & quy ước đọc được từ code thật.
- `.kb-local/glossary.md`: thuật ngữ domain & tên cũ khó hiểu (ban đầu có thể ngắn).
- `.kb-local/security-notes.md`: gotcha bảo mật nếu thấy (đừng vá, chỉ ghi).

### Bước 4 — Đăng ký vào registry
Thêm/cập nhật entry của project trong `.kb/registry.yaml`: id, name, path, stack,
entrypoints, đường dẫn kb, `last_scanned` = hôm nay.

### Bước 5 — Báo cáo
Tóm tắt: stack phát hiện, số module, các luồng chính, **danh sách "cần xác nhận"**
và **câu hỏi cho con người** (chỗ code mơ hồ không suy ra được). Đừng bịa khi không chắc.

### Ràng buộc
- Không sửa code nguồn. Chỉ tạo/sửa: `AGENTS.md` + `CLAUDE.md` (gốc project), `.kb-local/`, và `.kb/registry.yaml`.
- Index dạng text, signature không kèm thân hàm (xem `.kb/standards/indexing.md`).
- Ngắn gọn, trỏ-đừng-nhúng. Mục tiêu là bản đồ tra cứu, không phải bản sao codebase.
