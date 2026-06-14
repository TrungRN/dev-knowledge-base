# AGENTS.md — <TÊN PROJECT>

> Template. Auto-scan điền các <...>. Đây là file entry agent đọc khi làm việc trong project này.

@.kb/AGENTS.md
@.kb/standards/git-flow.md
@.kb/standards/security.md
@.kb/standards/indexing.md

## Project này là gì
<1–3 câu: mục đích, vai trò trong hệ thống, ai dùng.>

## Stack (auto-detected)
- Ngôn ngữ: <...>
- Framework: <...>
- Package manager: <...>
- Build/run: <lệnh build>, <lệnh run>, <lệnh test>

## Bắt đầu đọc ở đâu (cho agent)
1. `.kb-local/repo-map.md` — mục lục codebase, đọc trước.
2. `.kb-local/llms.txt` — bản đồ tài liệu của project.
3. Entry points: <file/đường dẫn>.

## Lệnh hay dùng
```
<cài deps>
<chạy local>
<chạy test>
<lint/format>
```

## Gotchas / lưu ý legacy
- <quirk, bẫy, phần code mong manh, lib lỗi thời... — auto-scan & người bổ sung dần>

## Quy ước riêng của project
- <khác biệt so với standards chung, nếu có. Mặc định: theo `.kb/standards/*`.>

## Quan hệ với project khác
- Phụ thuộc / được gọi bởi: <tra `.kb/registry.yaml`>
