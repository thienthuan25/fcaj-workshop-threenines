---
title: "Blog 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---
# Từ CloudCost Insight đến AI FinOps Agent với Amazon Bedrock AgentCore

Trong thời gian học tập tại FCAJ và thực hiện project nhóm CloudCost Insight, mục tiêu ban đầu của tôi và các thành viên trong nhóm khá rõ ràng: tự động thu thập chi phí AWS, phát hiện bất thường, gửi cảnh báo qua email và trực quan hóa dữ liệu trên Dashboard.

Hệ thống hiện sử dụng Amazon EventBridge, AWS Lambda, Amazon S3, Amazon SQS, Amazon SNS, Amazon CloudWatch, Amazon API Gateway, Amazon CloudFront và Amazon Cognito. Khi chi phí vượt ngưỡng hoặc tăng đột biến, Lambda Analyzer sẽ phát hiện và gửi cảnh báo.

Tuy nhiên, sau khi hoàn thiện phiên bản này, tôi nhận ra một câu hỏi thú vị:

> Nếu người dùng không chỉ muốn nhận cảnh báo, mà còn muốn hỏi: “Tại sao chi phí EC2 tăng?” hoặc “Tôi nên tối ưu gì trước?” thì sao?

Đó là lúc tôi tìm hiểu về Amazon Bedrock AgentCore.

### Amazon Bedrock AgentCore là gì?

Amazon Bedrock AgentCore là nền tảng managed của AWS giúp xây dựng, triển khai và vận hành AI Agent trong môi trường production.

Thay vì chỉ gọi một Large Language Model để trả lời câu hỏi, AgentCore hỗ trợ Agent truy cập công cụ, dữ liệu và API, đồng thời thực hiện nhiều bước xử lý để hoàn thành một nhiệm vụ.

AgentCore không yêu cầu người triển khai phải tự quản lý hạ tầng runtime cho Agent. Nền tảng này hỗ trợ nhiều framework và model khác nhau, đồng thời cung cấp các thành phần cho runtime, memory, identity, tool integration và observability.

### Vì sao AI Agent khác chatbot thông thường?

Một chatbot cơ bản thường hoạt động theo mô hình:

```text
Người dùng
→ Prompt
→ LLM
→ Câu trả lời
```

Trong khi đó, AI Agent có thể thực hiện một chuỗi hành động:

```text
Người dùng đặt câu hỏi
→ Agent phân tích yêu cầu
→ Gọi công cụ hoặc API phù hợp
→ Truy vấn dữ liệu
→ Phân tích kết quả
→ Đưa ra câu trả lời hoặc đề xuất hành động
```

Ví dụ, với CloudCost Insight, người dùng có thể hỏi:

> “Tại sao chi phí ngày hôm nay tăng cao hơn trung bình?”

Một FinOps Agent có thể:

* Gọi API của CloudCost Insight để lấy dữ liệu chi phí.
* Xác định các dịch vụ có mức tăng cao nhất.
* So sánh chi phí hiện tại với dữ liệu lịch sử trong S3.
* Phân tích xem chi phí tăng do vượt ngưỡng hay do tăng đột biến.
* Trả lời bằng ngôn ngữ tự nhiên và đề xuất hướng kiểm tra tiếp theo.

### Các thành phần đáng chú ý của AgentCore

#### AgentCore Runtime

Runtime cung cấp môi trường để chạy Agent một cách tách biệt và có khả năng mở rộng. Đây là nơi Agent thực hiện suy luận, gọi tool và xử lý các tác vụ có thể kéo dài.

Thay vì phải tự triển khai Agent trên EC2, ECS hoặc Kubernetes, nhà phát triển có thể tập trung vào logic Agent và để AWS quản lý phần runtime.

#### AgentCore Gateway

Gateway giúp kết nối Agent với các công cụ và dịch vụ hiện có. Một API hoặc Lambda function có thể được chuyển thành tool mà Agent có thể khám phá và gọi thông qua Model Context Protocol (MCP).

Đây là thành phần đặc biệt phù hợp với CloudCost Insight. Các API như lấy chi phí theo ngày, lấy top services hoặc kiểm tra trạng thái bất thường có thể trở thành tool cho FinOps Agent.

```text
FinOps Agent
→ AgentCore Gateway / MCP
→ Lambda API
→ S3 Cost Data
```

#### AgentCore Identity

Khi Agent cần truy cập tài nguyên AWS hoặc công cụ bên thứ ba, identity là thành phần rất quan trọng. AgentCore Identity hỗ trợ cơ chế xác thực và phân quyền để Agent có thể hành động an toàn thay mặt người dùng hoặc hệ thống.

Trong CloudCost Insight, phần này có thể kết hợp với Amazon Cognito hiện có để bảo đảm Agent chỉ truy cập dữ liệu chi phí mà người dùng đã được cấp quyền xem.

#### AgentCore Memory

Memory giúp Agent duy trì ngữ cảnh trong các cuộc hội thoại hoặc lưu lại thông tin cần thiết giữa các phiên làm việc.

Ví dụ, nếu người dùng đã hỏi về chi phí EC2 của tuần này, Agent có thể hiểu câu hỏi tiếp theo như:

> “Còn Lambda thì sao?”

mà không cần người dùng lặp lại toàn bộ ngữ cảnh.

#### AgentCore Observability

Khi đưa AI Agent vào production, câu hỏi không chỉ là Agent có trả lời được hay không, mà còn là:

* Agent đã gọi tool nào?
* Tool call có thành công không?
* Agent mất bao lâu để hoàn thành một tác vụ?
* Agent có đưa ra câu trả lời sai hoặc vượt ngoài phạm vi không?

AgentCore Observability cung cấp khả năng theo dõi hoạt động end-to-end của Agent và tích hợp với Amazon CloudWatch. Đây là yếu tố quan trọng để debug, đánh giá và cải thiện Agent theo thời gian.

### Ý tưởng mở rộng CloudCost Insight

Phiên bản hiện tại của project nhóm đã có khả năng:

* Thu thập dữ liệu chi phí AWS theo lịch.
* Phát hiện chi phí vượt ngưỡng và tăng đột biến.
* Gửi cảnh báo qua SNS Email.
* Hiển thị Dashboard có xác thực Cognito.
* Xử lý lỗi với SQS partial batch failure, DLQ và CloudWatch Alarm.
* Triển khai hạ tầng bằng Terraform và CI/CD.

Trong phiên bản tiếp theo, tôi muốn thử nghiệm mô hình AI FinOps Agent:

```text
User
→ Dashboard
→ Amazon Cognito
→ FinOps Agent on Bedrock AgentCore
→ AgentCore Gateway / MCP
→ CloudCost Insight APIs
→ S3 Cost Data
→ Phân tích và đề xuất tối ưu
```

Agent có thể hỗ trợ người dùng trả lời các câu hỏi như:

* Dịch vụ nào tốn nhiều chi phí nhất trong 7 ngày qua?
* Ngày nào có chi phí bất thường?
* Chi phí hôm nay tăng so với trung bình lịch sử bao nhiêu phần trăm?
* Tôi nên kiểm tra tài nguyên nào trước để tối ưu chi phí?

### Kết luận

AI Agent không thay thế các kỹ sư Cloud hoặc FinOps. Tuy nhiên, nếu được thiết kế đúng về bảo mật, dữ liệu và khả năng quan sát, Agent có thể trở thành một cộng sự hữu ích, giúp giảm thời gian điều tra và đưa thông tin cần thiết đến người dùng nhanh hơn.

Amazon Bedrock AgentCore mở ra một hướng phát triển thú vị cho CloudCost Insight: từ một hệ thống tự động giám sát và cảnh báo chi phí, có thể phát triển thành một AI FinOps Agent hỗ trợ phân tích chi phí và đề xuất hướng tối ưu.

### Link bài viết

[Từ CloudCost Insight đến AI FinOps Agent với Amazon Bedrock AgentCore](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2237361750362118/?rdid=XfoUyid6NZXJYRyp#)