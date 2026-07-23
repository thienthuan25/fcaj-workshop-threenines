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

{{% notice note %}}
Nếu tài khoản AWS của bạn là tài khoản mới hoặc bạn mới chạy hệ thống, chưa qua 24 giờ để **Cost Explorer** ghi nhận dữ liệu chi phí thì chúng ta sẽ tiếp tục sử dụng dữ liệu mô phỏng ([Simulated Data](../5.6-Dashboard/5.6.1-Backend/)) để kiểm thử đầy đủ các trường hợp phát hiện bất thường. Khi triển khai với tài khoản có chi phí thực tế, hệ thống hoạt động tương tự với dữ liệu thật từ **Cost Explorer**.
{{% /notice %}}

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

1. INFO:

- **Analyzer** tự động kích hoạt sau khi kích hoạt **Collector**.

- Truy cập **Lambda**, chọn **cloudcost-insight-analyzer**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/info_1.png)

- Chọn Tab **Monitoring**, sau đó chọn **View CloudWatch Logs**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/info_2.png)

- Chọn vào Log mới nhất:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/info_3.png)

- Kết quả mong đợi: log phân loại đúng mức **NORMAL**, không cần gửi email cảnh báo.

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/info_4.png)

2. WARNING:

- Truy vập vào **Lambda**, chọn **cloudcost-insight-analyzer**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/info_1.png)

- Chọn Tab **Test** và test với dữ liệu **JSON** ở múc **WARNING** đã được chạy script sinh dữ liệu mô phỏng chi phí:

```json
{
  "Records": [
    {
      "body": "{\"date\": \"2026-06-25\", \"s3_key\": \"cost-data/year=2026/month=06/day=25/cost_2026-06-25.json\", \"total_cost\": 12.0}"
    }
  ]
}
```

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/warning_1.png)

- Kết quả mong đợi: Log ghi nhận mức cảnh báo **WARNING** và email cảnh báo:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/warning_2.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/warning_3.png)

3. CRITICAL:

- Ở cửa sổ Console của **cloudcost-insight-analyzer**, tiếp tục test với dữ **JSON** ở mức **CRITICAL** đã được chạy script sinh dữ liệu mô phỏng chi phí:

```json
{
  "Records": [
    {
      "body": "{\"date\": \"2026-07-05\", \"s3_key\": \"cost-data/year=2026/month=07/day=05/cost_2026-07-05.json\", \"total_cost\": 52.0}"
    }
  ]
}
```

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/critical_1.png)

- Kết quả mong đợi: Log ghi nhận mức cảnh báo **CRITICAL** và email cảnh báo:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/critical_2.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/critical_3.png)

#### 3. Kiểm thử cơ chế xử lý lỗi (Dead Letter Queue)

Tiếp theo, chúng ta kiểm thử khả năng chịu lỗi của hệ thống.

1. Trên Terminal, gửi một sự kiện lỗi trỏ tới một file không tồn tại trong S3 vào hàng đợi chính:

```bash
aws sqs send-message --queue-url $(terraform output -raw sqs_events_queue_url) --message-body '{"date": "2099-01-01", "s3_key": "cost-data/unknown.json", "total_cost": 0}'
```

- Kết quả mong đợi: Message được nhận.

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_1.png)

2. Analyzer retry rồi thất bại:

- Truy cập vào **CloudWatch**, chọn Tab **Log management**, chọn tiếp **/aws/lambda/cloudcost-insight-analyzer**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_2.png)

- Chọn vào **Log stream** mới nhất:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_3.png)

- Kết quả mong đợi: Log lỗi **NoSuchKey** và lặp lại nhiều lần:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_4.png)

- Tiếp theo, truy cập vào **SQS**, chọn **cloudcost-insight-dlq**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_5.png)

- Chọn **Send and receive message**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_6.png)

- Kéo xuống chọn **Poll for messages**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_7.png)

- Kết quả mong đợi: Message được gửi vào **Dead Letter Queue**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_8.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dlq_9.png)

#### 4. Kiểm thử giám sát bằng CloudWatch Alarm

Khi sự kiện lỗi ở bước 3 khiến **Analyzer** phát sinh lỗi và có message rơi vào **DLQ**, các **CloudWatch Alarm** tương ứng sẽ chuyển sang trạng thái **ALARM** và gửi email cảnh báo sự cố.

- Truy cập vào **CloudWatch**, chọn mục **Alarm**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/cloudwatch_1.png)

- Kết quả mong đợi: **cloudcost-insight-analyzer-errors** và **cloudcost-insight-dlq-has-messages** trong trạng thái **In alarm**.

- Email thông báo:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/alarm_1.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/alarm_2.png)

- Sau một khoảng thời gian, chúng ta sẽ có email chuyển trạng thái của **cloudcost-insight-analyzer-errors** từ **ALARM** sang **OK** vì **Analyzer** không còn lỗi mới nữa, **CloudWatch** không nhận được datapoint lỗi nào. Dó đó Alarm tự chuyển về **OK**:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/alarm_3.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/alarm_4.png)

#### 5. Kiểm thử Web Dashboard

Cuối cùng, chúng ta kiểm thử giao diện trực quan.

Truy cập vào link URL CloudFront của dashboard trên trình duyệt và xác minh dữ liệu hiển thị đúng:

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dashboard_1.png)

![Testing](/fcaj-workshop-threenines/images/5-Workshop/5.7-Testing/dashboard_2.png)

Kết quả mong đợi là dashboard hiển thị đầy đủ các chỉ số KPI, biểu đồ xu hướng chi phí kèm đường ngưỡng và đánh dấu ngày bất thường, cùng biểu đồ top dịch vụ. Ngoài ra, dashboard còn có các chức năng chuyển đổi giao diện sáng tối và chuyển đổi ngôn ngữ Anh Việt.

#### 6. Tổng kết kiểm thử

Sau khi hoàn thành các bước kiểm thử trên, hệ thống **CloudCost Insight** đã được kiểm chứng hoạt động hoàn chỉnh và tự động end-to-end:

- Thu thập dữ liệu chi phí tự động và lưu trữ đúng cấu trúc.
- Phát hiện bất thường và cảnh báo qua email theo ba mức.
- Xử lý lỗi an toàn bằng **Dead Letter Queue**.
- Tự giám sát sức khỏe hệ thống bằng **CloudWatch Alarm**.
- Trực quan hóa dữ liệu qua **Web Dashboard** có thể truy cập công khai.

#### Nội dung tiếp theo

<!-- - [Dọn dẹp tài nguyên](5-Workshop/5.8-Cleanup/) -->