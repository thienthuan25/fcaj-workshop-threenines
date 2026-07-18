---
title : "Introduction"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

#### Introduction to Serverless and Event Driven Architecture

- A Serverless architecture allows you to build and run applications without managing servers. Services such as AWS Lambda, Amazon S3, Amazon SQS, and Amazon SNS are fully managed services that automatically scale according to demand and charge only for actual usage. This approach is well suited for lightweight applications that require low operating costs.

- An Event driven architecture enables system components to communicate through events instead of making direct service calls. This approach decouples individual components, making the system more flexible, easier to scale, and more resilient to failures. In CloudCost Insight, Amazon SQS serves as the event buffer between the data collection stage and the data analysis stage.

#### Workshop Overview

In this workshop, we will build the CloudCost Insight system, which consists of three main workflows. The entire solution is provisioned with Terraform by following the Infrastructure as Code approach.

- **Data collection and analysis workflow** is responsible for automatically retrieving cost data from the AWS Cost Explorer API. Amazon EventBridge schedules the Lambda Collector to run periodically, collect cost data, store it in Amazon S3, and publish events to Amazon SQS. The Lambda Analyzer then consumes these events, analyzes the data, and detects abnormal spending based on predefined budget thresholds and historical average costs.

- **Monitoring and alerting workflow** is responsible for monitoring the health of the system and notifying users when issues occur. Amazon SNS sends email notifications whenever costs exceed the configured threshold. At the same time, Amazon CloudWatch collects logs and metrics and triggers alarms when a Lambda function fails or when an event is sent to the Dead Letter Queue. This mechanism ensures that the system remains reliable and that operational issues are not overlooked.

- **Data visualization workflow** provides a custom web dashboard that allows users to monitor cost trends through an intuitive interface. Cost data is delivered by the Lambda API through Amazon API Gateway. The web application is hosted on Amazon S3 and distributed through Amazon CloudFront over HTTPS. To minimize operating costs, the entire solution runs on a Serverless architecture and remains almost entirely within the AWS Free Tier.

![overview](/fcaj-workshop-template/images/5-Workshop/5.1-Workshop-overview/CloudCostInsight1.jpg)