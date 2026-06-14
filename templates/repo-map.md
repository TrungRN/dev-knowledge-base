# Repo map — <TÊN PROJECT>

> Mục lục codebase do auto-scan sinh. Refresh theo PR. Mục tiêu: agent biết "cái gì
> ở đâu" mà không đọc cả repo. Liệt kê signature, KHÔNG kèm thân hàm.

- **Cập nhật lần cuối:** <YYYY-MM-DD> (commit <hash>)
- **Stack:** <ngôn ngữ / framework>

## Cây thư mục (rút gọn)
```
<thư-mục>/        # vai trò 1 dòng
  <con>/          # ...
```

## Module / khu vực chính
### <Tên module>
- **Trách nhiệm:** <1 dòng>
- **File then chốt:** `<path>`, `<path>`
- **Phụ thuộc:** <module khác / lib>
- **Public API (signature):**
  - `<kiểu trả về> <tên hàm>(<tham số>)` — `<path:line>`

<lặp cho từng module>

## Entry points
- `<path>` — <luồng gì bắt đầu ở đây: main / route / handler / job>

## Luồng nghiệp vụ chính
### <Tên luồng, vd: Xử lý thanh toán>
1. <bước> → `<path>`
2. <bước> → `<path>`
3. ...

## Phần mong manh / nợ kỹ thuật
- <khu vực dễ vỡ, code khó, lib lỗi thời — trỏ file>
