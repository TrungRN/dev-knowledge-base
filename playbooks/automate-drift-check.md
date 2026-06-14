# Playbook: Drift check — chạy tay & (tùy chọn) tự động

Drift check có ba mức độ "tự động". Mặc định dùng **mức 1** vì nó không đụng gì tới
git server nên không cần lead duyệt. Mức 2–3 là opt-in, bật khi đã được thông qua.

## Mức 1 — Script độc lập, dev chủ động chạy (MẶC ĐỊNH)
Không cài gì, không đụng git config/CI. Từ trong project đã nối KB:
```bash
.kb/scripts/kb-drift-check.sh            # so với origin/main
.kb/scripts/kb-drift-check.sh main --strict   # trả mã 1 nếu có drift
```
Nó chỉ đọc `git diff` và cảnh báo nếu code đổi mà `.kb-local/` không đổi. Đây là cách
khuyến nghị khi các setup trên git **chưa được lead thông qua**. Dev tự chạy trước khi
push hoặc khi cần.

> Vì nó không thay đổi gì trong repo (chỉ đọc), không cần phê duyệt để dùng.

## Mức 2 — pre-push hook (local, mỗi dev tự bật)
Tự chạy mức 1 mỗi khi `git push`, trên máy dev. Không đụng CI server.
```bash
.kb/scripts/install-hooks.sh    # cài hook + vendor script vào .kb-local/ci/
```
Hook không chặn push (mặc định cảnh báo). Mỗi dev chạy lệnh này một lần sau khi clone.

## Mức 3 — CI trên MR (CẦN LEAD DUYỆT)
Tự chạy server-side khi tạo MR, dán kết quả cho lead xem. **Chỉ bật sau khi lead
thông qua** vì nó sửa cấu hình CI dùng chung:
- GitLab: thêm vào `.gitlab-ci.yml`: `include: [ { local: '.kb-local/ci/gitlab-ci.kb-drift.yml' } ]`
- GitHub: copy `.kb-local/ci/github-kb-drift.yml` → `.github/workflows/kb-drift.yml`

(`install-hooks.sh` đã vendor sẵn các file CI vào `.kb-local/ci/` để dành; chỉ khi nào
được duyệt thì mới thêm dòng include/workflow ở trên.)

## KHÔNG sinh tự động khi scan
`connect-project.sh` và `prompts/auto-scan.md` **không** cài hook/CI. Việc bật tự động
là quyết định riêng (mức 2–3), tách khỏi quá trình scan. Mặc định chỉ có mức 1 sẵn dùng.

## Cảnh báo hay Chặn
| | Cấu hình |
|---|---|
| Cảnh báo (mặc định) | không `--strict`; GitLab `allow_failure: true` |
| Chặn | thêm `--strict`; GitLab `allow_failure: false` |

## Mechanical vs AI
- **Mechanical (các script trên):** tất định, miễn phí. Bắt việc *quên* cập nhật knowledge.
- **AI drift (tùy chọn):** agent chạy `prompts/review-kb-drift.md` để phân tích sâu; cần API key. Chạy cạnh mechanical, không thay thế.
