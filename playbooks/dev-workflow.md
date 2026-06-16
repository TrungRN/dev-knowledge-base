# Playbook: Quy trình làm việc của một dev (end-to-end)

Một vòng từ lúc nhận task tới lúc merge. Mỗi bước trỏ tới file liên quan trong KB.

Lưu ý: `.kb-local/` là symlink trỏ về `projects/<tên>/.kb-local/` trong KB trung tâm.
Knowledge riêng project versioned cùng repo KB, không nằm trong repo project con.

## Sơ đồ nhanh
```
nhánh mới → (agent đọc index) → code → cập nhật knowledge → check drift
   → commit (code + KB) → push → mở PR → review → merge
```

## Chi tiết

**1. Tạo nhánh**
```bash
git switch -c feature/<mô-tả-ngắn>
```
Quy ước nhánh: `standards/git-flow.md`.

**2. Khởi động agent (nếu dùng AI)**
Để agent đọc theo thứ tự: `AGENTS.md` → `.kb-local/repo-map.md` → `.kb-local/llms.txt`.
Cần thông tin project khác → tra `.kb/registry.yaml`. (Đọc index trước, tiết kiệm token.)

**3. Code tính năng**
Theo `standards/code-style.md`, `naming.md`, `security.md`. Phần riêng theo stack: tin `.kb-local/` trước.

**4. Cập nhật knowledge NẾU có ảnh hưởng**
Đụng module / public API / luồng / lệnh / quyết định kiến trúc → sửa `.kb-local/`
(repo-map, ADR...) trong repo KB trung tâm. Điều kiện cụ thể: `templates/kb-acceptance-checklist.md`.

Thường sẽ có 2 PR liên quan:
- PR 1: code trong repo project con.
- PR 2: knowledge trong repo KB trung tâm (`projects/<tên>/.kb-local/`).

**5. Tự kiểm trước khi commit**
- Chạy test + lint/format của project.
- Chạy drift check (script độc lập, không cần cài gì):
  ```bash
  kb check
  ```
  Vá knowledge nếu nó cảnh báo. Muốn phân tích sâu hơn: dùng prompt
  `prompts/review-kb-drift.md`. (Tự động theo hook/CI là tùy chọn — xem
  `playbooks/automate-drift-check.md`.)

**6. Commit**
Conventional Commits, thân commit nói VÌ SAO (`standards/git-flow.md`):
```bash
git add -A
git commit -m "feat(scope): ... " -m "Vì sao: ..."
```

**7. Push**
```bash
git push -u origin feature/<mô-tả-ngắn>
```

**8. Mở PR vào `main`**
Mô tả PR trả lời: *Vì sao? Thay đổi gì? Rủi ro? Test thế nào?* PR nhỏ, một mục đích.
Nếu PR code đi kèm PR knowledge, đính kèm liên kết tới PR của repo KB.

**9. Review PR**
Người review (hoặc agent) dùng `standards/code-review.md` — checklist có mục
**Knowledge bắt buộc** đảm bảo `.kb-local/` trong KB trung tâm đã được cập nhật tương ứng.

**10. Merge**
Khi xanh CI + được duyệt + không còn drift → merge vào `main`.

---

## Ba file "review" khác nhau thế nào (gỡ rối)
| File | Là gì | Dùng khi |
|---|---|---|
| `prompts/review-kb-drift.md` | **Prompt để CHẠY** (agent so code vs knowledge) | Bước 5, trước khi commit |
| `templates/kb-acceptance-checklist.md` | **Tiêu chí** drift check đối chiếu | Tham chiếu ở bước 4 & 5 |
| `standards/code-review.md` | **Checklist review** chất lượng code tổng thể | Bước 9, khi review PR |

Nhớ gọn: *acceptance-checklist = luật · review-kb-drift = công cụ chạy luật · code-review = checklist review tổng thể khi duyệt PR.*
