---
title: "Các bài blogs đã đăng"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

Trong quá trình thực tập tại First Cloud AI Journey, em đã viết và đăng 3 bài blog trên [AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj). Các bài viết tập trung vào kiến thức AWS, trải nghiệm thực tế khi thực hiện project CloudCost Insight và định hướng phát triển hệ thống trong tương lai.

### [Blog 1 - CloudCost Insight: Điều mình học được khi xây dựng một hệ thống Serverless để giám sát chi phí AWS](3.1-Blog1/)

Blog chia sẻ những kiến thức và trải nghiệm thực tế sau khi xây dựng CloudCost Insight. Nội dung tập trung vào lý do lựa chọn kiến trúc Serverless, cách áp dụng event-driven architecture, vai trò của các dịch vụ như EventBridge, Lambda, S3, SQS, SNS, CloudWatch và lợi ích của Infrastructure as Code với Terraform trong việc tái tạo hạ tầng một cách nhất quán.

### [Blog 2 - Amazon EventBridge Scheduler: Dịch vụ nhỏ nhưng có thể thay thế rất nhiều cron job](3.2-Blog2/)

Blog giới thiệu Amazon EventBridge Scheduler, một dịch vụ Serverless giúp lập lịch thực thi các tác vụ trên AWS mà không cần quản lý cron server. Bài viết so sánh EventBridge Scheduler với EventBridge Rule, đồng thời phân tích các khả năng như retry, Dead Letter Queue, cấu hình múi giờ và Flexible Time Window. Nội dung cũng đề xuất Scheduler như một hướng cải tiến trong tương lai cho CloudCost Insight.

### [Blog 3 - Từ CloudCost Insight đến AI FinOps Agent với Amazon Bedrock AgentCore](3.3-Blog3/)

Blog giới thiệu Amazon Bedrock AgentCore và ý tưởng mở rộng CloudCost Insight thành một AI FinOps Agent. Bài viết phân tích sự khác biệt giữa AI Agent và chatbot thông thường, các thành phần như AgentCore Runtime, Gateway, Identity, Memory và Observability, cũng như cách Agent có thể truy vấn dữ liệu chi phí, phân tích bất thường và đề xuất hướng tối ưu cho người dùng.