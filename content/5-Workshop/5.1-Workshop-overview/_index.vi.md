---
title : "Giới thiệu"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---


#### Giới thiệu về kiến trúc Serverless và Event-driven

+ Kiến trúc Serverless cho phép bạn xây dựng và chạy ứng dụng mà không cần quản lý máy chủ. Các dịch vụ như AWS Lambda, Amazon S3, Amazon SQS và Amazon SNS đều là managed service, tự động co giãn theo tải và tính phí theo mức sử dụng, rất phù hợp cho các hệ thống nhỏ gọn cần tối ưu chi phí vận hành.

+ Kiến trúc Event-driven giúp các thành phần trong hệ thống giao tiếp với nhau thông qua sự kiện thay vì gọi trực tiếp. Nhờ đó, các thành phần được tách rời (decoupling), giúp hệ thống linh hoạt, dễ mở rộng và có khả năng chịu lỗi tốt hơn. Trong CloudCost Insight, Amazon SQS đóng vai trò đệm sự kiện giữa khâu thu thập và khâu phân tích dữ liệu.

#### Tổng quan về workshop

Trong workshop này, chúng ta sẽ xây dựng hệ thống CloudCost Insight gồm ba luồng hoạt động chính, được triển khai hoàn toàn bằng Terraform theo mô hình Infrastructure as Code.

+ **Luồng thu thập và phân tích** chịu trách nhiệm tự động lấy dữ liệu chi phí từ AWS Cost Explorer. Amazon EventBridge lập lịch kích hoạt Lambda Collector định kỳ để thu thập dữ liệu, lưu vào Amazon S3 và đẩy sự kiện qua Amazon SQS. Sau đó Lambda Analyzer tiêu thụ sự kiện, phân tích dữ liệu và phát hiện chi phí bất thường dựa trên ngưỡng ngân sách cùng trung bình chi phí lịch sử.

+ **Luồng giám sát và cảnh báo** đảm nhận việc theo dõi sức khỏe hệ thống và thông báo cho người dùng. Amazon SNS gửi email cảnh báo khi chi phí vượt ngưỡng, trong khi Amazon CloudWatch thu thập log, metric và kích hoạt Alarm khi Lambda gặp lỗi hoặc khi có sự kiện rơi vào Dead Letter Queue. Cơ chế này đảm bảo hệ thống luôn hoạt động tin cậy và không bỏ sót sự cố.

+ **Luồng trực quan hóa** cung cấp một web dashboard tự xây để người dùng theo dõi xu hướng chi phí. Dữ liệu được cung cấp qua Lambda API và Amazon API Gateway, giao diện web được host trên Amazon S3 và phân phối qua Amazon CloudFront với HTTPS. Để tối ưu chi phí, toàn bộ hệ thống chạy trên kiến trúc Serverless và nằm gần như hoàn toàn trong Free Tier của AWS.

![overview](/fcaj-workshop-threenines/images/5-Workshop/5.1-Workshop-overview/CloudCostInsight1.jpg)