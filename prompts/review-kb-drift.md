# Prompt: Review drift knowledge ↔ code (chạy theo PR)

Chạy trên **diff của PR** (hoặc diff so với `main`) để bắt knowledge lệch code TRƯỚC
khi merge. Mục tiêu: docs co-evolve với code, không trở thành nguồn sai cho agent.

Lưu ý: `.kb-local/` trong project con là symlink trỏ về `projects/<tên-project>/.kb-local/`
trong repo KB trung tâm. Knowledge cần so nằm ở đó.

---

**Vai trò:** Bạn là reviewer kiêm người gác cổng knowledge. Xét diff dưới đây và xác
định mọi chỗ knowledge cần cập nhật nhưng chưa cập nhật.

### Đầu vào
- Diff code: `git diff origin/main...HEAD` trong repo project con (hoặc range được cung cấp).
- Diff knowledge: thay đổi trong `projects/<tên-project>/.kb-local/` của repo KB trung tâm
  (cùng khoảng commit nếu có, hoặc uncommitted changes).
- Checklist: `.kb/templates/kb-acceptance-checklist.md`.

### Việc cần làm
1. **Phân loại thay đổi trong diff:** có đụng module/file then chốt? public API/signature? luồng nghiệp vụ? stack/lệnh? quyết định kiến trúc? bảo mật?
2. **Đối chiếu từng mục với checklist.** Với mỗi loại bị đụng, kiểm tra knowledge tương ứng trong `.kb-local/` (repo KB trung tâm) đã được sửa tương ứng chưa.
3. **Liệt kê drift:** mỗi mục gồm — *file knowledge nào*, *lệch chỗ nào*, *vì sao* (trỏ tới hunk trong diff).
4. **Đề xuất patch cụ thể:** nội dung cần sửa trong `repo-map.md` / `AGENTS.md` / ADR mới... Viết sẵn để người chỉ việc duyệt.
5. **Cập nhật ngày/last_scanned** nếu áp dụng.

### Đầu ra (định dạng cố định)
```
## Kết quả drift
- [ ] PASS / [ ] CẦN SỬA: <tóm tắt 1 dòng>

### Drift phát hiện
1. <file knowledge> — <mô tả lệch> — nguồn: <hunk>
   → Đề xuất: <patch>

### Cần con người quyết
- <chỗ không tự suy được — vd quyết định kiến trúc cần ADR, ai là người quyết>
```

### Ràng buộc
- **Tin code hơn doc.** Nếu mâu thuẫn, code là sự thật, doc phải theo.
- Chỉ báo drift có căn cứ trong diff — không bịa, không "review" phần ngoài diff trừ khi cần ngữ cảnh.
- Nếu không có drift, nói rõ PASS và vì sao — đừng tạo việc thừa.
- Nếu project con chưa link KB (không có .kb-local), báo "chưa link KB — skip drift check".
