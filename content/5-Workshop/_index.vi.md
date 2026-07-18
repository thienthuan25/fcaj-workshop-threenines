---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Xây dựng hệ thống giám sát và cảnh báo chi phí AWS bằng kiến trúc Serverless

#### Tổng quan

**CloudCost Insight** là một hệ thống Serverless giúp tự động giám sát, phân tích và cảnh báo chi phí sử dụng dịch vụ AWS theo thời gian gần thực, mà không cần bất kỳ thao tác thủ công nào. Thay vì phải đăng nhập vào Billing Console để kiểm tra chi phí mỗi ngày, hệ thống sẽ tự thu thập dữ liệu, phát hiện bất thường và chủ động gửi cảnh báo qua email khi chi phí vượt ngưỡng.

Trong bài lab này, chúng ta sẽ học cách xây dựng một hệ thống FinOps hoàn chỉnh trên AWS theo kiến trúc Serverless và event-driven, sử dụng Terraform để triển khai toàn bộ hạ tầng dưới dạng Infrastructure as Code. Hệ thống được thiết kế để tự động hóa hoàn toàn quy trình từ thu thập, phân tích, cảnh báo cho đến trực quan hóa dữ liệu chi phí.

Hệ thống bao gồm ba luồng chính, mỗi luồng đảm nhận một vai trò riêng biệt nhưng phối hợp chặt chẽ với nhau.

+ **Luồng thu thập và phân tích**: Amazon EventBridge lập lịch kích hoạt Lambda Collector định kỳ để gọi Cost Explorer API lấy dữ liệu chi phí, lưu vào S3 và đẩy sự kiện qua SQS. Lambda Analyzer sau đó tiêu thụ sự kiện, phân tích dữ liệu, phát hiện chi phí vượt ngưỡng hoặc tăng đột biến và gửi cảnh báo qua SNS.

+ **Luồng giám sát và xử lý lỗi**: Amazon CloudWatch thu thập log và metric của các hàm Lambda, đồng thời kích hoạt Alarm khi hệ thống gặp sự cố. Các sự kiện xử lý lỗi được chuyển vào SQS Dead Letter Queue để đảm bảo không mất dữ liệu.

+ **Luồng trực quan hóa**: Một web dashboard tự xây được cung cấp dữ liệu qua Lambda API và Amazon API Gateway, giao diện host trên Amazon S3 và phân phối qua Amazon CloudFront, giúp người dùng theo dõi xu hướng chi phí một cách trực quan.

#### Nội dung

1. [Giới thiệu](5.1-Workshop-overview/)
2. [Các bước chuẩn bị](5.2-Prerequisite/)
3. [Dựng hạ tầng nền bằng Terraform](5.3-Infrastructure/)
4. [Triển khai Lambda Collector và Lambda Analyzer](5.4-Lambda/)
5. [Cấu hình giám sát và cảnh báo (CloudWatch Alarm)](5.5-Monitoring/)
6. [Xây dựng Web Dashboard](5.6-Dashboard/)
7. [Kiểm thử hệ thống](5.7-Testing/)
8. [Dọn dẹp tài nguyên](5.8-Cleanup/)