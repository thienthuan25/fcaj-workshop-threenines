---
title : "Kiểm thử hệ thống"
date : 2024-01-01
weight : 7
chapter : false
pre : " <b> 5.7 </b> "
---

#### Tổng quan

Sau khi đã triển khai đầy đủ các thành phần, trong phần này chúng ta sẽ kiểm thử toàn bộ hệ thống **CloudCost Insight** từ đầu đến cuối. Mục tiêu là xác minh các luồng hoạt động đúng và phối hợp chặt chẽ với nhau.

Chúng ta sẽ kiểm thử theo 4 nhóm chính:

- Luồng thu thập và phân tích dữ liệu chi phí.
- Cơ chế phát hiện bất thường và cảnh báo qua Email theo 3 mức.
- Cơ chế xử lý lỗi bằng **Dead Letter Queue**.
- Cơ chế giám sát bằng **CloudWatch Alarm** và **Web Dashboard**.

{{ % notice %}}
Nếu tài khoản AWS của bạn là tài khoản mới hoặc bạn mới chạy hệ thống, chưa qua 24 giờ để **Cost Explorer** ghi nhận dữ liệu chi phí thì chúng ta sẽ tiếp tục sử dụng dữ liệu mô phỏng ([Simulated Data](../5.6-Dashboard/5.6.1-Backend/)) để kiểm thử đầy đủ các trường hợp phát hiện bất thường. Khi triển khai với tài khoản có chi phí thực tế, hệ thống hoạt động tương tự với dữ liệu thật từ **Cost Explorer**.

#### 1. Kiểm thử luồng thu thập dữ liệu

Trước tiên, chúng ta kiểm tra **Lambda Collector** có thu thập dữ liệu và ghi vào S3 đúng hay không. Trên **AWS Console**, mở hàm Lambda Collector và chạy thử với một sự kiện rống:

1. Kiểm tra **Lambda Collector**

- Truy cập vào **Lambda**, chọn **cloudcost-insight-collector**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_1.png)

- Chọn mục **Test** và chạy một sự kiện rỗng:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_2.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_3.png)

- Kết quả kì vọng: 

    + Trả về **statusCode: 200**.
    + Log ghi nhận việc gọi **Cost Explorer**

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_4.png)

2. Kiểm tra dữ liệu đã được ghi vào S3 theo đúng cấu trúc phân vùng theo năm/tháng/ngày:

- Truy cập vào **S3** và chọn bucket của bạn:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_5.png)

- Kết quả kì vọng: Có các thư mục chứa file JSON chứa dữ liệu chi phí:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_6.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_7.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_8.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_9.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/testing_10.png)

#### 2. Kiểm thử phát hiện chi phí bất thường theo 3 mức (INFO, WARNING, CRITICAL)

Để kiểm thử ba mức cảnh báo, chúng ta chuẩn bị dữ liệu chi phí đã mô phỏng trong S3 cho từng trường hợp xảy ra. Logic phân loại dựa trên 2 tiêu chí:

- Ngưỡng ngân sách.
- Mức tăng đột biến so với trung bình lịch sử.

| Mức cảnh báo | Dữ liệu | Kết quả mong đợi |
| --- | --- | --- |
| INFO | Chi phí thấp, không vượt ngưỡng | Không gửi email cảnh báo |
| WARNING | Chi phí vượt ngưỡng nhưng chưa đột biến | Gửi email cảnh báo ở mức WARNING |
| CRITICAL | Chi phí tăng đột biến so với trung bình | Gửi email cảnh báo ở mức CRITICAL |

Với mỗi mức cảnh báo, chúng ta gửi sự kiện tương ứng vào SQS, sau đó theo dõi kết quả phân loại dựa trên CloudWatch Logs của Analyzer.



