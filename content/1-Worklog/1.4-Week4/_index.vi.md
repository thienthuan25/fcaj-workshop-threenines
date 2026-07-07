---
title: "Worklog Tuần 4"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---

### Mục tiêu tuần 4:

* Lên ý tưởng và chốt đề tài cho dự án, đảm bảo giải quyết một bài toán thiết thực trên AWS.
* Nghiên cứu và lựa chọn kiến trúc hạ tầng phù hợp (ưu tiên Serverless) để xây dựng hệ thống.
* Hoàn thiện Proposal với định hướng công nghệ và lộ trình phát triển rõ ràng.
* Trực quan hóa giải pháp bằng các sơ đồ kiến trúc (Architecture Diagram) chi tiết.
* Chuẩn bị môi trường mã nguồn, khắc phục các sự cố liên quan đến template dự án (lỗi Git submodule).

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Lên ý tưởng dự án: <br>&emsp; + Phân tích bài toán quản lý và cảnh báo chi phí trên AWS. <br>&emsp; + Tham khảo tính năng AWS Cost Anomaly Detection để định vị ý tưởng. <br>&emsp; + Chốt đề tài dự án **CloudCost Insight**. | 01/06/2026 | 01/06/2026 | - AWS Cost Management (Cost Anomaly Detection): <br> https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html |
| 3 | - Nghiên cứu và thiết kế hệ thống: <br>&emsp; + Tìm hiểu ưu điểm của kiến trúc Serverless (khả năng mở rộng, tối ưu chi phí vận hành). <br>&emsp; + Thiết kế luồng thu thập – phân tích – cảnh báo. <br>&emsp; + Chốt công nghệ triển khai: Serverless kết hợp IaC (Terraform). | 02/06/2026 | 02/06/2026 | - AWS Serverless Architecture: <br> https://aws.amazon.com/serverless/ <br> - AWS Well-Architected – Cost Optimization Pillar |
| 4 | - Viết Proposal dự án: <br>&emsp; + Viết phần giới thiệu, phạm vi và mục tiêu dự án. <br>&emsp; + Lập luận lý do chọn đề tài dựa trên nhu cầu thực tế và mục đích học tập. <br>&emsp; + Định nghĩa các ngưỡng ngân sách riêng và logic tùy biến cảnh báo. | 03/06/2026 | 03/06/2026 | - Tổng hợp kiến thức từ các tài liệu nghiên cứu thiết kế hệ thống và quản lý chi phí AWS. |
| 5 | - Vẽ Diagram: <br>&emsp; + Vẽ sơ đồ kiến trúc tổng quan (High-level Architecture). <br>&emsp; + Vẽ sơ đồ luồng dữ liệu (Data Flow) mô tả cách các thành phần Serverless tương tác để phát hiện chi phí bất thường. | 04/06/2026 | 04/06/2026 |  |
| 6 | - Khởi tạo môi trường & fix lỗi template: <br>&emsp; + Kiểm tra và rà soát cấu trúc thư mục dự án ban đầu. <br>&emsp; + Xử lý lỗi Git submodule trong template (bị hỏng, cấu hình repository không đầy đủ, không push được source lên GitHub Pages). <br>&emsp; + Cấu hình lại chuẩn xác để sẵn sàng cho quá trình phát triển (coding). | 05/06/2026 | 05/06/2026 |  |

### Kết quả đạt được tuần 4:

* **Chốt ý tưởng và định hình dự án:** Hoàn thành việc lên ý tưởng và chốt đề tài **CloudCost Insight** — hệ thống giám sát và cảnh báo chi phí AWS. Quá trình lên ý tưởng xuất phát từ một bài toán thực tế: với mô hình pay-as-you-go, chi phí AWS rất dễ vượt tầm kiểm soát nếu không được theo dõi chủ động.

* **Lý do lựa chọn đề tài:** Trong quá trình nghiên cứu, tôi đã tham khảo **AWS Cost Anomaly Detection** — tính năng cảnh báo chi phí bất thường có sẵn của AWS. Việc này giúp khẳng định giám sát chi phí là một nhu cầu thực tế được chính AWS công nhận. Trên cơ sở đó, tôi lựa chọn hướng đi cốt lõi: thay vì sử dụng dịch vụ managed có sẵn, dự án sẽ **tự xây dựng toàn bộ luồng thu thập – phân tích – cảnh báo bằng kiến trúc Serverless kết hợp Terraform (IaC)**. Hướng tiếp cận này nhằm ba mục đích: (1) học tập và làm chủ hoàn toàn kiến trúc hạ tầng AWS; (2) rèn luyện kỹ năng Infrastructure as Code; (3) chủ động tùy biến logic phát hiện theo từng ngưỡng ngân sách riêng — điều mà giải pháp có sẵn khó đáp ứng linh hoạt.

* **Hoàn thiện bộ tài liệu đề xuất:** Đã viết xong Proposal dự án rõ ràng, chi tiết hóa mục tiêu, phạm vi và định hướng công nghệ. Đồng thời hoàn thành các sơ đồ kiến trúc (tổng quan và luồng dữ liệu), giúp trực quan hóa cách các dịch vụ Serverless tương tác để phát hiện và cảnh báo chi phí bất thường.

* **Xử lý sự cố môi trường phát triển:** Khắc phục thành công lỗi Git submodule trong template khởi tạo (do submodule bị hỏng và thiếu file cấu hình), thiết lập môi trường phát triển đồng bộ và sẵn sàng bước vào giai đoạn lập trình, cấu hình hạ tầng ở các tuần tiếp theo.