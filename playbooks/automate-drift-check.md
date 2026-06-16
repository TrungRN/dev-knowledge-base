# Playbook: Drift check — chạy tay & (tùy chọn) tự động

Drift check có ba mức độ "tự động". Mặc định dùng **mức 1** vì nó không đụng gì tới
git server nên không cần lead duyệt. Mức 2–3 là opt-in, bật khi đã được thông qua.

Lưu ý: `.kb-local/` là symlink trỏ về `projects/<tên>/.kb-local/` trong KB trung tâm.
Drift check so code đổi ở repo project con với knowledge đổi ở repo KB.

## Mức 1 — Script độc lập, dev chủ động chạy (MẶC ĐỊNH)
Không cài gì, không đụng git config/CI. Từ trong project đã nối KB:
```bash
kb check            # so với origin/main
kb check main --strict   # trả mã 1 nếu có drift
```
Nó đọc `git diff` của repo project con và `git diff` của repo KB tại
`projects/<tên>/.kb-local/`, rồi cảnh báo nếu code đổi mà knowledge không đổi. Đây là
cách khuyến nghị khi các setup trên git **chưa được lead thông qua**. Dev tự chạy trước
khi push hoặc khi cần.

> Vì nó không thay đổi gì trong repo (chỉ đọc), không cần phê duyệt để dùng.

## Mức 2 — pre-push hook (local, mỗi dev tự bật)
Tự chạy mức 1 mỗi khi `git push`, trên máy dev. Không đụng CI server.
```bash
kb ci    # cài hook + đặt script/template CI vào .kb-local/ (trong KB trung tâm)
```
Hook không chặn push (mặc định cảnh báo). Mỗi dev chạy lệnh này một lần sau khi clone.

## Mức 3 — CI trên MR (CẦN LEAD DUYỆT)
Tự chạy server-side khi tạo MR, dán kết quả cho lead xem. **Chỉ bật sau khi lead
thông qua** vì nó sửa cấu hình CI dùng chung. Lưu ý: CI runner cần checkout cả
repo project con và repo dev-knowledge-base ở ngang hàng, hoặc dùng remote include.
- GitLab: xem `projects/<tên>/.kb-local/ci/gitlab-ci.kb-drift.yml` và include từ repo KB
  (hoặc copy nội dung vào `.gitlab-ci.yml` sau khi lead duyệt).
- GitHub: copy `projects/<tên>/.kb-local/ci/github-kb-drift.yml` → `.github/workflows/kb-drift.yml`
  trong project con, rồi cấu hình checkout kèm repo KB.

(`kb ci` đã đặt sẵn các file CI vào `.kb-local/ci/` trong KB trung tâm; chỉ khi nào
được duyệt thì mới bật include/workflow ở trên.)

## KHÔNG sinh tự động khi scan
`kb link` và `prompts/auto-scan.md` **không** cài hook/CI. Việc bật tự động
là quyết định riêng (mức 2–3), tách khỏi quá trình scan. Mặc định chỉ có mức 1 sẵn dùng.

## Cảnh báo hay Chặn
| | Cấu hình |
|---|---|
| Cảnh báo (mặc định) | không `--strict`; GitLab `allow_failure: true` |
| Chặn | thêm `--strict`; GitLab `allow_failure: false` |

## Mechanical vs AI
- **Mechanical (các script trên):** tất định, miễn phí. Bắt việc *quên* cập nhật knowledge.
- **AI drift (tùy chọn):** agent chạy `prompts/review-kb-drift.md` để phân tích sâu; cần API key. Chạy cạnh mechanical, không thay thế.
