---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Xây dựng hệ thống giám sát, phân tích và cảnh báo chi phí AWS bằng kiến trúc Serverless

### Tổng quan

**CloudCost Insight** là hệ thống FinOps Serverless giúp tự động thu thập, phân tích, trực quan hóa và cảnh báo chi phí sử dụng dịch vụ AWS theo chu kỳ. Thay vì phải kiểm tra AWS Billing Console thủ công, hệ thống sẽ lấy dữ liệu chi phí từ AWS Cost Explorer, phát hiện các trường hợp vượt ngưỡng hoặc tăng đột biến, sau đó chủ động gửi cảnh báo qua email.

Trong workshop này, chúng ta sẽ xây dựng hệ thống theo kiến trúc **Serverless** và **event-driven**, sử dụng **Terraform** để triển khai toàn bộ hạ tầng dưới dạng **Infrastructure as Code**. Hệ thống được thiết kế với khả năng xử lý lỗi, giám sát vận hành, xác thực người dùng cho Dashboard và quy trình CI/CD tự động.

Hệ thống gồm bốn luồng chính phối hợp với nhau:

+ **Luồng thu thập và phân tích chi phí:** Amazon EventBridge kích hoạt Lambda Collector theo lịch định kỳ để gọi AWS Cost Explorer lấy dữ liệu chi phí. Collector lưu dữ liệu vào Amazon S3 và gửi event qua Amazon SQS. Lambda Analyzer nhận event, đọc dữ liệu từ S3, so sánh chi phí với ngưỡng ngân sách và trung bình lịch sử để phát hiện chi phí bất thường.

+ **Luồng xử lý lỗi, giám sát và cảnh báo:** Lambda Analyzer sử dụng cơ chế SQS partial batch failure để chỉ retry các message thất bại. Các message không thể xử lý sau nhiều lần retry được chuyển vào SQS Dead Letter Queue. Amazon CloudWatch thu thập logs, metrics và kích hoạt Alarm khi Lambda gặp lỗi hoặc DLQ có message. Amazon SNS gửi email khi phát hiện chi phí vượt ngưỡng, tăng đột biến hoặc khi hệ thống gặp sự cố.

+ **Luồng trực quan hóa và bảo mật:** Web Dashboard hiển thị KPI, biểu đồ xu hướng chi phí, ngưỡng cảnh báo và các dịch vụ có chi phí cao nhất. Lambda API đọc dữ liệu từ S3, Amazon API Gateway cung cấp HTTP API, còn giao diện được host trên Amazon S3 và phân phối qua Amazon CloudFront với HTTPS. Amazon Cognito xác thực người dùng và cấp JWT; API Gateway chỉ cho phép request có JWT hợp lệ truy cập dữ liệu. CORS cũng được giới hạn để chỉ domain CloudFront của Dashboard được phép gọi API từ trình duyệt.

+ **Luồng kiểm thử và CI/CD:** Mã nguồn được kiểm tra tự động bằng GitHub Actions trước khi merge vào nhánh `main`, bao gồm Hugo Workshop, Python Lambda, Terraform và JavaScript Dashboard. Sau khi thay đổi Terraform được merge vào `main`, GitHub Actions tự động thực hiện Terraform Apply thông qua HCP Terraform. Branch protection và GitHub Environment giúp kiểm soát các thay đổi trước khi cập nhật hạ tầng AWS production.

### Nội dung

1. [Giới thiệu](5.1-Workshop-overview/)
2. [Các bước chuẩn bị](5.2-Prerequisite/)
3. [Dựng hạ tầng nền bằng Terraform](5.3-Infrastructure/)
4. [Triển khai Lambda Collector và Lambda Analyzer](5.4-Lambda/)
5. [Cấu hình giám sát và cảnh báo (CloudWatch Alarm)](5.5-Monitoring/)
6. [Xây dựng Web Dashboard](5.6-Dashboard/)
7. [Kiểm thử hệ thống](5.7-Testing/)
8. [CI/CD](5.8-CI-CD/)
9. [Dọn dẹp tài nguyên](5.9-Cleanup/)