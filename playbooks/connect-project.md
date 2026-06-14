# Playbook: Nối một project vào KB

Mục tiêu: project con trỏ tới KB chung qua symlink `.kb` (một bản vật lý, không copy),
và có thư mục `.kb-local/` cho knowledge riêng.

## Yêu cầu vị trí
Project và `dev-kb` nên đặt **ngang hàng**:
```
~/Work/
├── dev-kb/            ← KB này
├── project-a/
└── project-b/
```

## Cách 1 — dùng script (khuyến nghị)
**Chạy từ TRONG project con** — quy ước chuẩn (không cần truyền tham số):
```bash
cd ../project-a
../dev-kb/scripts/connect-project.sh
```
Hoặc chạy từ bất cứ đâu và truyền đường dẫn project:
```bash
/đường-dẫn/dev-kb/scripts/connect-project.sh ../project-a
```
Chạy từ đâu cũng cho kết quả như nhau — script tự xác định vị trí KB qua chính nó.
Nó sẽ: tạo symlink `project-a/.kb -> dev-kb`, tạo `project-a/.kb-local/`,
thêm gợi ý `.gitignore`, và in bước tiếp theo.

> Vì sao "từ trong project con"? Mô hình tư duy "đưa *project này* vào KB"; liền mạch
> với bước auto-scan (bạn vốn đã ở trong project); người mới clone về tái lập symlink
> bằng đúng câu lệnh đó.

## Cách 2 — thủ công
```bash
cd ../project-a
ln -s ../dev-kb .kb          # symlink tới KB chung (đổi ../dev-kb cho đúng tên thật)
mkdir -p .kb-local/adr
```

## Sau khi nối
1. **Sinh knowledge:** mở agent trong `project-a`, đưa nội dung `.kb/prompts/auto-scan.md`. Agent tạo `AGENTS.md`, `.kb-local/repo-map.md`, `llms.txt`...
2. **Đăng ký:** auto-scan tự thêm project vào `.kb/registry.yaml` (hoặc thêm tay).
3. **Git:** commit `.kb-local/` và `AGENTS.md` vào repo project. Symlink `.kb` thì
   gitignore (vì nó trỏ ra ngoài, phụ thuộc máy) — xem ghi chú dưới.

## Ghi chú về symlink & git
- `.kb` là symlink ra ngoài repo, **không nên commit** (mỗi máy bố trí thư mục khác nhau). Cho vào `.gitignore`.
- Người mới clone project chỉ cần chạy lại `connect-project.sh` (hoặc tạo symlink) một lần để tái lập `.kb`.
- Knowledge thật (`.kb-local/`) thì **commit bình thường** — nó versioned cùng code.
