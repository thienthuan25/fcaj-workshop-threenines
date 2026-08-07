---
title: "Blog 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# CloudCost Insight - Điều mình học được khi xây dựng một hệ thống Serverless để giám sát chi phí AWS

Có lẽ ai mới bắt đầu học AWS cũng từng nghe câu nói:

> "Cloud giúp tiết kiệm chi phí."

Nhưng sau khi học và bắt tay vào làm project, mình nhận ra một điều thú vị hơn: Cloud chỉ thực sự tiết kiệm khi chúng ta biết mình đang tiêu tiền vào đâu.

Đó cũng là lý do nhóm mình quyết định xây dựng **CloudCost Insight** - một hệ thống giúp tự động giám sát, phân tích và cảnh báo chi phí AWS, thay vì phải đăng nhập vào AWS Console để kiểm tra thủ công mỗi ngày.

Điều mình muốn chia sẻ trong bài viết này không phải là cách viết code, mà là những gì mình học được sau khi hoàn thành project.

### Vì sao lại là Serverless?

Lúc bắt đầu xây dựng hệ thống, mình từng nghĩ đến việc dùng một EC2 nhỏ để chạy cron job. Ý tưởng rất đơn giản: mỗi ngày EC2 chạy một script Python, lấy dữ liệu từ Cost Explorer rồi lưu lại.

Tuy nhiên, càng tìm hiểu mình càng thấy cách làm này không hợp lý. Hệ thống chỉ chạy một lần mỗi ngày, trong khi EC2 phải:

* Chạy 24/7.
* Tốn chi phí ngay cả khi không làm gì.
* Cần quản lý bản vá và trạng thái máy chủ.
* Tăng thêm công việc vận hành.

Trong khi đó, phần lớn thời gian hệ thống không có việc để làm. Vì vậy, nhóm mình quyết định chuyển sang kiến trúc **Serverless**.

Thay vì có một máy chủ luôn bật, AWS chỉ chạy code khi thực sự có sự kiện xảy ra. Lambda Collector được EventBridge kích hoạt theo lịch, sau đó tự động thu thập dữ liệu chi phí và tiếp tục luồng xử lý.

### Event-driven giúp các thành phần tách rời

Một điều mình học được rõ nhất trong project là cách xây dựng hệ thống theo kiến trúc **event-driven**.

Thay vì để các thành phần gọi trực tiếp lẫn nhau, nhóm mình tách chúng ra thông qua event:

* EventBridge chỉ biết kích hoạt Lambda Collector.
* Collector chỉ biết lấy dữ liệu và gửi message vào SQS.
* Analyzer chỉ biết đọc message từ SQS và phân tích dữ liệu.
* SNS chỉ biết gửi email cảnh báo.
* Dashboard chỉ biết gọi API để hiển thị dữ liệu.

Không thành phần nào phụ thuộc quá nhiều vào thành phần khác. Nhờ vậy, khi muốn thay đổi logic xử lý, nhóm chỉ cần chỉnh sửa đúng Lambda hoặc thành phần liên quan.

Đó là lần đầu tiên mình hiểu rõ thế nào là event-driven architecture sau khi trước đây chỉ đọc về nó trong tài liệu.

### Có những dịch vụ trước đây mình chỉ biết tên

Trước khi làm project này, mình từng học khá nhiều dịch vụ AWS theo kiểu:

* Lambda là gì?
* SNS dùng để làm gì?
* SQS hoạt động như thế nào?

Chỉ khi tự tay xây dựng hệ thống, mình mới hiểu chúng kết nối với nhau ra sao.

Ví dụ, Amazon SQS không chỉ là một hàng đợi. Nó giúp Lambda Collector không cần quan tâm Lambda Analyzer đang bận hay rảnh. Collector chỉ cần gửi event vào queue, Analyzer sẽ xử lý event khi có khả năng.

Tương tự, CloudWatch Alarm không chỉ để xem logs. Trong CloudCost Insight, CloudWatch được sử dụng để phát hiện:

* Lambda gặp lỗi.
* Message rơi vào Dead Letter Queue.
* Các sự cố cần được gửi email cảnh báo ngay lập tức.

Một điều thú vị mình phát hiện trong quá trình kiểm thử là CloudWatch Alarm không gửi email liên tục. Alarm chỉ gửi thông báo khi trạng thái chuyển từ `OK` sang `ALARM`, hoặc từ `ALARM` trở về `OK`.

### Infrastructure as Code với Terraform

Đây có lẽ là phần mình thích nhất trong project.

Toàn bộ CloudCost Insight được triển khai bằng Terraform. Điều đó có nghĩa là khi muốn dựng lại hệ thống, mình chỉ cần chạy:

```bash
terraform init
terraform plan
terraform apply
```

Sau vài phút, các tài nguyên cần thiết có thể được tạo lại trên AWS.

Không cần phải nhớ:

* Đã tạo S3 Bucket chưa.
* IAM Role tên gì.
* SQS Queue đã được cấu hình đúng chưa.
* Lambda đã có environment variables hay chưa.

Terraform giúp tự động hóa những công việc đó. Điều này càng rõ hơn khi đến giai đoạn viết Workshop. Mỗi thành viên trong nhóm đều phải tự triển khai lại project từ đầu. Nếu làm thủ công, chắc chắn sẽ mất rất nhiều thời gian. Nhưng nhờ Infrastructure as Code, việc tái tạo hệ thống trở nên đơn giản và nhất quán hơn rất nhiều.

### Serverless không chỉ giúp tiết kiệm tiền

Lúc đầu, mình nghĩ Serverless chỉ có lợi thế về chi phí. Sau khi hoàn thành project, mình nhận ra lợi ích lớn nhất nằm ở cách thiết kế hệ thống.

Serverless giúp:

* Không cần quản lý máy chủ.
* Tự động mở rộng theo tải.
* Dễ chia nhỏ chức năng.
* Dễ kiểm thử.
* Dễ triển khai lại.
* Chỉ trả tiền khi tài nguyên thực sự chạy.

Đối với một project học tập hoặc hệ thống có tần suất xử lý thấp, đây là một lựa chọn rất đáng cân nhắc.

### Những vấn đề gặp phải

Trong quá trình làm project, nhóm mình cũng gặp một số vấn đề thực tế:

* Cost Explorer không cập nhật dữ liệu theo thời gian thực.
* IAM thiếu quyền có thể khiến Lambda thất bại.
* CORS của API Gateway có thể làm frontend không gọi được API.
* SNS cần xác nhận email trước khi gửi cảnh báo.
* SQS cần được cấu hình retry và Dead Letter Queue để không bỏ sót message lỗi.

Những vấn đề này tuy không lớn, nhưng giúp mình hiểu rõ hơn cách các dịch vụ AWS hoạt động khi được kết hợp trong một hệ thống thực tế.

### Điều mình học được sau project này

Nếu chỉ nhìn vào danh sách dịch vụ, CloudCost Insight sử dụng khá nhiều thành phần. Tuy nhiên, điều mình thấy giá trị nhất không phải là học thêm nhiều dịch vụ AWS, mà là học được cách ghép những dịch vụ nhỏ thành một hệ thống hoàn chỉnh.

Mỗi dịch vụ chỉ giải quyết một bài toán riêng:

* EventBridge xử lý lập lịch.
* Lambda xử lý logic.
* S3 lưu dữ liệu.
* SQS tách rời các thành phần.
* SNS gửi cảnh báo.
* CloudWatch giám sát hệ thống.
* Terraform triển khai hạ tầng.

Khi ghép chúng lại đúng cách, chúng tạo nên một hệ thống tự động, dễ mở rộng và dễ bảo trì.

Hy vọng những chia sẻ này sẽ giúp các bạn có thêm một góc nhìn thực tế khi học và triển khai AWS.

![Blog 1](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

### Link bài viết

[CloudCost Insight - Điều mình học được khi xây dựng một hệ thống Serverless để giám sát chi phí AWS](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2223252578439702/?rdid=HXH21Uqn6t5ZQ4L4#)