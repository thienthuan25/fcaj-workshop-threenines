---
title: "Worklog Tuần 10"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.10. </b> "
---

### Mục tiêu tuần 10:

* Xây dựng web frontend cho dashboard (index.html, style.css, script.js), dùng Chart.js trực quan hóa dữ liệu chi phí.
* Host frontend lên AWS (S3 Web Hosting + CloudFront) với link HTTPS công khai.
* Kiểm thử end-to-end toàn bộ luồng web dashboard (từ trình duyệt → API → dữ liệu).
* Hoàn thiện & nâng cấp dashboard: tinh chỉnh biểu đồ, thêm chế độ sáng/tối và chuyển đổi song ngữ EN/VI.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Viết web frontend (giao diện & logic): <br>&emsp; + Viết `index.html` (cấu trúc trang) và `style.css` (giao diện). <br>&emsp; + Viết `script.js` gọi API endpoint, xử lý JSON và vẽ biểu đồ bằng Chart.js. <br>&emsp; + Vẽ các biểu đồ: xu hướng chi phí (đường ngưỡng + đánh dấu bất thường), tỷ trọng dịch vụ, top dịch vụ, KPI. | 13/07/2026 | 13/07/2026 | - Chart.js Documentation: <br> https://www.chartjs.org/docs/latest/ <br> - MDN Fetch API: <br> https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API |
| 3 | - Host frontend lên AWS (S3 + CloudFront): <br>&emsp; + Tạo S3 bucket (Web Hosting) và upload 3 file giao diện bằng Terraform. <br>&emsp; + Cấu hình CloudFront (HTTPS) + Origin Access Control để bảo mật, chặn truy cập public trực tiếp vào S3. <br>&emsp; + Lấy link CloudFront công khai để truy cập dashboard. | 14/07/2026 | 14/07/2026 | - Amazon CloudFront + S3: <br> https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.SimpleDistribution.html <br> - Terraform aws_cloudfront_distribution: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution |
| 4 | - Kiểm thử end-to-end web dashboard: <br>&emsp; + Truy cập dashboard qua link CloudFront trên trình duyệt. <br>&emsp; + Xác minh toàn luồng: trình duyệt → CloudFront/S3 (tải giao diện) và trình duyệt → API Gateway → Lambda-API → S3 (lấy dữ liệu). <br>&emsp; + Kiểm tra các biểu đồ hiển thị đúng dữ liệu chi phí và trạng thái bất thường. | 15/07/2026 | 15/07/2026 | - Testing web applications & trình duyệt (Developer Tools). |
| 5 | - Tinh chỉnh biểu đồ & thêm chế độ sáng/tối: <br>&emsp; + Điều chỉnh kích thước biểu đồ donut (tỷ trọng dịch vụ) nhỏ lại cho cân đối. <br>&emsp; + Bổ sung tooltip hiển thị số tiền kèm ký hiệu `$`. <br>&emsp; + Thêm chức năng chuyển đổi giao diện sáng/tối (dark mode) bằng CSS variables. | 16/07/2026 | 16/07/2026 | - MDN CSS Custom Properties (variables): <br> https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties |
| 6 | - Thêm chức năng chuyển đổi song ngữ (EN/VI): <br>&emsp; + Xây dựng từ điển song ngữ (Anh/Việt) cho các nhãn, tiêu đề và biểu đồ. <br>&emsp; + Thêm nút chuyển ngôn ngữ, cập nhật giao diện và vẽ lại biểu đồ theo ngôn ngữ được chọn. <br>&emsp; + Kiểm thử lại toàn bộ dashboard ở cả 2 ngôn ngữ. | 17/07/2026 | 17/07/2026 | - Tổng hợp kiến thức JavaScript (DOM manipulation, event handling). |

### Kết quả đạt được tuần 10:

* **Hoàn thành web frontend cho dashboard:** Đã xây dựng giao diện dashboard được tổ chức thành 3 file riêng biệt (`index.html`, `style.css`, `script.js`) theo nguyên tắc separation of concerns. Dashboard dùng thư viện Chart.js để trực quan hóa dữ liệu chi phí với đầy đủ các biểu đồ: xu hướng chi phí theo ngày (kèm đường ngưỡng và đánh dấu ngày bất thường), tỷ trọng theo dịch vụ, top dịch vụ tốn chi phí và các chỉ số KPI.

* **Host frontend lên AWS thành công:** Đã đưa web dashboard lên S3 (Web Hosting) kết hợp CloudFront, cấp phát link HTTPS công khai. Áp dụng Origin Access Control để bảo mật, chỉ CloudFront được đọc S3, chặn truy cập public trực tiếp. Nhờ đó, CloudCost Insight chính thức trở thành một product hoàn chỉnh, có thể truy cập qua trình duyệt bằng đường link công khai.

* **Kiểm thử end-to-end web dashboard:** Đã kiểm chứng thành công toàn bộ luồng hoạt động của dashboard: trình duyệt tải giao diện từ CloudFront/S3, đồng thời gọi API Gateway → Lambda-API → S3 để lấy dữ liệu chi phí và hiển thị lên biểu đồ. Toàn bộ luồng vận hành trơn tru, biểu đồ hiển thị đúng dữ liệu và trạng thái bất thường.

* **Tinh chỉnh giao diện & thêm chế độ sáng/tối:** Đã điều chỉnh kích thước biểu đồ donut cho cân đối, bổ sung tooltip hiển thị số tiền kèm ký hiệu `$`. Thêm chức năng chuyển đổi giao diện sáng/tối (dark mode) sử dụng CSS variables, giúp người dùng lựa chọn giao diện phù hợp và cải thiện trải nghiệm.

* **Thêm chức năng song ngữ (EN/VI):** Đã xây dựng cơ chế chuyển đổi song ngữ Anh/Việt cho toàn bộ dashboard (nhãn, tiêu đề, nhãn biểu đồ). Chức năng này không chỉ nâng cao trải nghiệm người dùng mà còn phù hợp với yêu cầu song ngữ của chương trình FCAJ. Sau khi hoàn thiện, dashboard được kiểm thử lại ở cả 2 ngôn ngữ, hoàn tất CloudCost Insight thành một product trực quan, chuyên nghiệp và tự động end-to-end.