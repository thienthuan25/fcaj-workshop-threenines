---
title : "Giới thiệu"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

#### Giới thiệu về kiến trúc Serverless và Event-driven

+ **Kiến trúc Serverless** cho phép xây dựng và vận hành ứng dụng mà không cần quản lý máy chủ. Các dịch vụ như AWS Lambda, Amazon S3, Amazon SQS, Amazon SNS và Amazon API Gateway là managed service, có khả năng tự động co giãn theo tải và tính phí theo mức sử dụng. Kiến trúc này phù hợp với CloudCost Insight vì hệ thống có số lượng request thấp, chạy theo lịch định kỳ và cần tối ưu chi phí vận hành.

+ **Kiến trúc Event-driven** giúp các thành phần giao tiếp với nhau thông qua event thay vì gọi trực tiếp. Các thành phần được tách rời, dễ mở rộng và có khả năng chịu lỗi tốt hơn. Trong CloudCost Insight, Amazon SQS đóng vai trò hàng đợi trung gian giữa Lambda Collector và Lambda Analyzer; Dead Letter Queue lưu các message không thể xử lý thành công sau số lần retry cho phép.

#### Tổng quan về workshop

Trong workshop này, chúng ta sẽ xây dựng hệ thống **CloudCost Insight** để tự động giám sát, phân tích và cảnh báo chi phí AWS. Toàn bộ hạ tầng được triển khai bằng **Terraform** theo mô hình **Infrastructure as Code**, giúp có thể tái tạo, cập nhật và dọn dẹp tài nguyên một cách nhất quán.

Hệ thống gồm các luồng hoạt động chính sau:

+ **Luồng thu thập và phân tích chi phí:** Amazon EventBridge kích hoạt Lambda Collector theo lịch định kỳ. Collector gọi AWS Cost Explorer để lấy dữ liệu chi phí, lưu dữ liệu vào Amazon S3 theo cấu trúc phân vùng ngày/tháng/năm và gửi event vào Amazon SQS. Lambda Analyzer nhận event từ SQS, đọc dữ liệu từ S3, so sánh với ngưỡng ngân sách và trung bình lịch sử để phát hiện các trường hợp chi phí bất thường.

+ **Luồng xử lý lỗi, giám sát và cảnh báo:** Lambda Analyzer sử dụng cơ chế **SQS partial batch failure** để chỉ retry những message xử lý thất bại. Nếu không đọc được file dữ liệu chính từ S3, Analyzer ghi log lỗi và trả message thất bại về SQS thay vì bỏ qua lỗi. Message tiếp tục thất bại sẽ được chuyển vào **Dead Letter Queue**. Amazon CloudWatch thu thập logs, metrics và kích hoạt Alarm khi Lambda xảy ra lỗi hoặc DLQ có message. Amazon SNS gửi email cảnh báo khi phát hiện chi phí vượt ngưỡng, tăng đột biến hoặc hệ thống gặp sự cố.

+ **Luồng trực quan hóa và bảo mật:** Web Dashboard hiển thị KPI, xu hướng chi phí, ngưỡng cảnh báo và các dịch vụ có chi phí cao nhất. Lambda API đọc dữ liệu từ S3, sau đó Amazon API Gateway cung cấp HTTP API cho frontend. Giao diện web được host trên Amazon S3 và phân phối qua Amazon CloudFront với HTTPS. Amazon Cognito quản lý người dùng và cấp JWT sau khi đăng nhập; API Gateway chỉ cho phép request có JWT hợp lệ truy cập dữ liệu. CORS cũng được giới hạn để chỉ domain CloudFront của Dashboard được gọi API từ trình duyệt.

+ **Luồng kiểm thử và CI/CD:** Mã nguồn được kiểm tra tự động bằng GitHub Actions trước khi merge vào nhánh `main`, bao gồm Hugo Workshop, Python Lambda, Terraform và JavaScript Dashboard. Các thay đổi Terraform sau khi được merge vào `main` sẽ tự động được triển khai thông qua HCP Terraform. Branch protection và GitHub Environment giúp kiểm soát thay đổi trước khi cập nhật hạ tầng AWS production.

![overview](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

Sau khi hoàn thành workshop, bạn sẽ có một hệ thống FinOps cơ bản có khả năng tự động thu thập dữ liệu chi phí, phát hiện bất thường, gửi cảnh báo, trực quan hóa dữ liệu, bảo vệ Dashboard bằng xác thực người dùng và triển khai hạ tầng bằng quy trình CI/CD.

#### Nội dung tiếp theo

- [Các bước chuẩn bị](5-Workshop/5.2-Prerequisite/)