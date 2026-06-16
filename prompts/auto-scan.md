# Prompt: Auto-scan & sinh knowledge cho project legacy

Đưa prompt này cho agent (Claude Code / Cursor...) khi chạy **bên trong thư mục một
project chưa có KB**. Agent sẽ tự phát hiện stack và sinh knowledge từ template.
Stack-agnostic: không giả định ngôn ngữ trước.

Lưu ý: `.kb-local/` trong project con là symlink trỏ về `projects/<tên-project>/.kb-local/`
trong repo KB trung tâm. Toàn bộ knowledge project được ghi ở đó.

---

**Vai trò:** Bạn là kỹ sư đang lập bản đồ một codebase legacy để vừa cho người mới
onboard, vừa cho AI agent đọc hiệu quả (tiết kiệm token). Làm theo các bước, KHÔNG
sửa code nguồn — chỉ tạo file trong `.kb-local/` (thực chất nằm trong KB trung tâm).

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

### Bước 3 — Sinh knowledge vào `.kb-local/` (KHÔNG đụng file ở gốc project)
Tất cả nội dung project nằm trong `.kb-local/` (symlink tới KB trung tâm). File `CLAUDE.md`
ở gốc project do `link-kb.sh` tạo sẵn (chỉ trỏ `@.kb/AGENTS.md` + fallback) — đừng dán
nội dung vào đó.
- `.kb-local/repo-map.md` (đã tạo ở Bước 2) — điền đầy đủ: **stack, lệnh build/run/test, gotchas** ở đầu file, rồi cây thư mục, module, entry, luồng.
- `.kb-local/llms.txt` — cập nhật mục lục tài liệu của project.
- `.kb-local/code-style.md`: formatter/linter & quy ước đọc được từ code thật.
- `.kb-local/glossary.md`: thuật ngữ domain & tên cũ khó hiểu (ban đầu có thể ngắn).
- `.kb-local/security-notes.md`: gotcha bảo mật nếu thấy (đừng vá, chỉ ghi).

### Bước 4 — Đăng ký vào registry
Thêm/cập nhật entry của project trong `registry.yaml` **ở gốc repo KB trung tâm**
(đường dẫn thật: `<KB_DIR>/registry.yaml`; trong project con thấy qua symlink
`.kb/registry.yaml` — sửa file này thực chất ghi vào repo KB, KHÔNG vào repo project con).
Điền: `id` (= tên thư mục project), name, path, stack, entrypoints, đường dẫn kb
(dùng `projects/<tên>/.kb-local/...`), `last_scanned` = hôm nay.

### Bước 5 — Báo cáo
Tóm tắt: stack phát hiện, số module, các luồng chính, **danh sách "cần xác nhận"**
và **câu hỏi cho con người** (chỗ code mơ hồ không suy ra được). Đừng bịa khi không chắc.

### Ràng buộc
- Không sửa code nguồn. Chỉ tạo/sửa: `.kb-local/` và `registry.yaml` — cả hai đều nằm
  trong repo KB trung tâm (project con chỉ thấy qua symlink `.kb-local/`, `.kb/registry.yaml`).
  (Đừng đụng `CLAUDE.md` ở gốc project — link-kb đã lo.)
- Index dạng text, signature không kèm thân hàm (xem `.kb/standards/indexing.md`).
- Ngắn gọn, trỏ-đừng-nhúng. Mục tiêu là bản đồ tra cứu, không phải bản sao codebase.
