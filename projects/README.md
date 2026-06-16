# projects/ — Knowledge riêng từng project (versioned trong repo KB)

Mỗi project con được nối vào KB có một thư mục ở đây:

```
projects/
└── <tên-project>/          # = tên thư mục project con (cũng là `id` trong registry.yaml)
    └── .kb-local/
        ├── repo-map.md     # mục lục codebase (stack, lệnh, gotchas, module, luồng)
        ├── llms.txt        # index tài liệu riêng project
        ├── adr/            # ADR riêng project (tùy chọn)
        ├── hooks/          # hook script nếu chạy `kb hook` (tùy chọn)
        └── ci/             # template pre-push/CI nếu chạy `kb ci` (tùy chọn)
```

## Quy ước
- **`<tên-project>` = đúng tên thư mục của repo project con.** `scripts/link-kb.sh`
  dùng `basename` của project để suy ra đường dẫn này, nên `registry.yaml#id` phải khớp.
- Project con **không** giữ `.kb-local/` thật — chỉ giữ symlink tuyệt đối
  `.kb-local -> <KB>/projects/<tên>/.kb-local` (không commit ở repo project con).
- **Knowledge ở đây commit cùng repo KB.** PR sửa knowledge thường tách khỏi PR sửa code
  (hai repo khác nhau) — xem [../playbooks/dev-workflow.md](../playbooks/dev-workflow.md).
- Tạo/cập nhật bằng `kb link <path>` rồi làm giàu bằng `/kb-scan` trong Claude Code.

## Lưu ý
- `projects/dev-knowledge-base/` là knowledge của **chính KB này** (xem
  [dev-knowledge-base/.kb-local/repo-map.md](dev-knowledge-base/.kb-local/repo-map.md)) —
  agent đọc khi sửa source KB.
- Thư mục `projects/` luôn được giữ trong repo (file README này) kể cả khi chưa có
  project nào khác được nối.
