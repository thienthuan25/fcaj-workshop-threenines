---
title: "Published Blog Posts"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

During my internship at First Cloud AI Journey, I wrote and published 3 blog posts on the [AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj). The articles focus on AWS knowledge, practical experiences while working on the CloudCost Insight project, and directions for future system development.

### [Blog 1 - CloudCost Insight: What I Learned from Building a Serverless System to Monitor AWS Costs](3.1-Blog1/)

This blog shares the knowledge and practical experiences gained after building CloudCost Insight. The content focuses on the reasons for choosing a Serverless architecture, how to apply an event-driven architecture, the roles of services such as EventBridge, Lambda, S3, SQS, SNS, and CloudWatch, as well as the benefits of Infrastructure as Code with Terraform for consistently recreating infrastructure.

### [Blog 2 - Amazon EventBridge Scheduler: A Small Service That Can Replace Many Cron Jobs](3.2-Blog2/)

This blog introduces Amazon EventBridge Scheduler, a Serverless service that helps schedule task execution on AWS without managing a cron server. The article compares EventBridge Scheduler with EventBridge Rule, while also analyzing capabilities such as retries, Dead Letter Queue, time zone configuration, and Flexible Time Window. The content also proposes Scheduler as a future improvement direction for CloudCost Insight.

### [Blog 3 - From CloudCost Insight to an AI FinOps Agent with Amazon Bedrock AgentCore](3.3-Blog3/)

This blog introduces Amazon Bedrock AgentCore and the idea of expanding CloudCost Insight into an AI FinOps Agent. The article analyzes the differences between AI Agents and traditional chatbots, components such as AgentCore Runtime, Gateway, Identity, Memory, and Observability, as well as how an Agent can query cost data, analyze anomalies, and recommend optimization directions to users.