---
title: "Blog 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

# Amazon EventBridge Scheduler - Dịch vụ nhỏ nhưng có thể thay thế rất nhiều cron job

Trong quá trình học AWS tại First Cloud AI Journey, mình có cơ hội tiếp cận rất nhiều dịch vụ. Có những dịch vụ rất nổi tiếng như EC2, Lambda hay S3, nhưng cũng có những dịch vụ ít được nhắc đến hơn dù lại rất hữu ích trong các hệ thống thực tế.

*Một trong số đó là Amazon EventBridge Scheduler.*

Lúc mới học AWS, mỗi khi cần chạy một tác vụ theo lịch, mình chỉ nghĩ đơn giản là tạo một EventBridge Rule với biểu thức `cron` hoặc `rate`. Sau khi tìm hiểu sâu hơn thông qua AWS Blog và tài liệu chính thức, mình mới biết AWS đã phát triển riêng một dịch vụ dành cho việc lập lịch có tên là Amazon EventBridge Scheduler, với nhiều tính năng mạnh mẽ hơn.

### Amazon EventBridge Scheduler là gì?

Amazon EventBridge Scheduler là dịch vụ Serverless giúp lập lịch thực thi các tác vụ trên AWS mà không cần tự xây dựng cron server hay quản lý hạ tầng.

Thay vì phải duy trì một máy chủ để chạy cron job, chúng ta chỉ cần cấu hình thời gian chạy và Scheduler sẽ tự động kích hoạt dịch vụ mong muốn.

Amazon EventBridge Scheduler có thể gọi trực tiếp nhiều dịch vụ AWS như:

* AWS Lambda.
* AWS Step Functions.
* Amazon ECS Tasks.
* AWS Batch Jobs.
* Amazon SQS.
* Amazon SNS.
* Amazon EventBridge Event Bus.
* API Destination.
* Và hơn 270 AWS services thông qua AWS SDK.

Điều mình thích nhất là gần như không cần viết thêm code trung gian.

### EventBridge Scheduler khác gì EventBridge Rule?

Đây là điều mình từng nhầm lẫn. Trước đây, mình luôn nghĩ EventBridge Rule chính là công cụ dùng để kích hoạt Lambda Collector mỗi ngày nhằm thu thập dữ liệu chi phí AWS trong project CloudCost Insight.

Sau khi tìm hiểu về EventBridge Scheduler, mình nhận ra rằng nếu xây dựng hoặc cải tiến project, mình sẽ cân nhắc sử dụng Scheduler thay cho EventBridge Rule.

Một số lợi ích của EventBridge Scheduler mà mình thấy có thể áp dụng:

* Hỗ trợ retry khi Lambda gặp lỗi.
* Có Dead Letter Queue để xử lý các request thất bại.
* Dễ cấu hình thời gian chạy theo múi giờ Việt Nam.
* Có Flexible Time Window để tránh nhiều tác vụ chạy cùng lúc.
* Dễ mở rộng khi hệ thống phát triển lớn hơn.

Đó là một thay đổi nhỏ nhưng giúp hệ thống chuyên nghiệp và linh hoạt hơn.

### Ứng dụng vào CloudCost Insight

Trong CloudCost Insight, Lambda Collector được chạy định kỳ để lấy dữ liệu chi phí từ AWS Cost Explorer. Hiện tại, EventBridge Rule có thể đáp ứng yêu cầu kích hoạt Lambda theo lịch.

Tuy nhiên, EventBridge Scheduler là một hướng cải tiến phù hợp vì có thể giúp hệ thống:

* Cấu hình lịch chạy theo múi giờ cụ thể.
* Retry khi Lambda Collector gặp lỗi tạm thời.
* Gửi request thất bại vào Dead Letter Queue để kiểm tra sau.
* Giảm nguy cơ nhiều scheduled tasks chạy cùng thời điểm.
* Quản lý lịch chạy độc lập và rõ ràng hơn.

Ví dụ, thay vì chạy Collector vào một thời điểm cố định theo UTC, chúng ta có thể cấu hình Scheduler chạy vào một giờ cụ thể theo múi giờ Việt Nam. Điều này giúp việc theo dõi và vận hành hệ thống thuận tiện hơn.

### Mình học được những gì?

Trước đây, mình có suy nghĩ rằng nếu đã biết EventBridge thì không cần tìm hiểu thêm. Nhưng sau khi đọc AWS Blog và tài liệu chính thức, mình nhận ra AWS liên tục phát triển các dịch vụ mới để giải quyết những bài toán rất cụ thể.

Amazon EventBridge Scheduler là một ví dụ điển hình. Đây không phải là một dịch vụ quá phức tạp, nhưng lại giúp đơn giản hóa rất nhiều công việc trong quá trình xây dựng hệ thống Serverless.

Mình nghĩ đây là một dịch vụ đáng để tìm hiểu nếu mọi người đang học AWS hoặc đang xây dựng các ứng dụng có tác vụ chạy theo lịch.

![Blog 2](/workshop-fcaj-intern/images/3-Blog/3.2-Blog-2/blog_2.png)

### Link bài viết

[Amazon EventBridge Scheduler - Dịch vụ nhỏ nhưng có thể thay thế rất nhiều cron job](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2225954698169490/?rdid=gj7NEFNAmPKdfzze#)

### Tài liệu tham khảo

- [Introducing Amazon EventBridge Scheduler](https://aws.amazon.com/vi/blogs/compute/introducing-amazon-eventbridge-scheduler/)
- [Amazon EventBridge Scheduler Documentation](https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html)