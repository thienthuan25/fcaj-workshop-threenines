---
title : "Dọn dẹp tài nguyên"
date : 2024-01-01
weight : 8
chapter : false
pre : " <b> 5.8 </b> "
---

#### Dọn dẹp

1. Chúng ta sẽ dùng **Terraform** để xóa toàn bộ tài nguyên đã tạo, bao gồm **Lambda**, **IAM Role**, **SNS**, **SQS**, **EventBridge**, **CloudWatch Alarm**, **API Gateway**, **CloudFront**, và các bucket **S3**.

```bash
terraform destroy
```

2. Gõ `yes` để xác nhận.

![Cleanup](/fcaj-workshop-threenines/images/5-Workshop/5.8-Cleanup/cleanup_1.png)

3. Chờ quá trình dọn dẹp hoàn tất.

![Cleanup](/fcaj-workshop-threenines/images/5-Workshop/5.8-Cleanup/cleanup_2.png)

4.  Sau khi **destroy** hoàn tất, bạn nên kiểm tra lại trên AWS Console để xác nhận tài nguyên đã được xóa sạch. Kiểm tra lần lượt các dịch vụ đã sử dụng như **S3**, **Lambda**, **SNS**, **SQS**, **EventBridge**, **CloudWatch Alarm**, **API Gateway** và **CloudFront**.

5. Một số thành phần không được quản lý bởi **Terraform** nên cần dọn dẹp thủ công nếu muốn xóa hoàn toàn:

- Nếu không dùng tiếp, bạn có thể xóa **Workspace** trên **HCP Terraform**.
- Vô hiệu hóa hoặc xóa **Access Key** của **IAM User** nếu không còn sử dụng để đảm bảo an toàn.
- Kiểm tra và xác nhận đăng ký (Subscription) trên SNS đã được xóa cùng với topic.

#### Tổng kết

Sau khi hoàn thành các bước trên, toàn bộ tài nguyên của hệ thống **Cloudcost Insight** đã được dọn dẹp sạch sẽ, đảm bảo không phát sinh thêm bất kì chi phí nào. Việc dọn dẹp dễ dàng chỉ với một câu lệnh thể hiện lợi ích rõ ràng của việc quản lý hạ tầng bằng **Infrastructure as Code** với **Terraform**.

Workshop xây dựng hệ thống giám sát và cảnh báo chi phí **Cloudcost Insight** đã hoàn tất. Chúng ta đã đi qua toàn bộ quá trình từ thiết kế kiến trúc, dựng hạ tầng, phát triển logic xử lý, cấu hình giám sát, xây dựng Web Dashboard, kiểm thử và cuối cùng là dọn dẹp tài nguyên.