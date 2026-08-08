---
title : "Introduction"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

### Introduction to Serverless and Event-driven Architecture

+ **Serverless architecture** allows you to build and operate applications without managing servers. Services such as AWS Lambda, Amazon S3, Amazon SQS, Amazon SNS, and Amazon API Gateway are managed services that can automatically scale based on load and charge according to usage. This architecture is suitable for CloudCost Insight because the system has a low number of requests, runs on a scheduled basis, and needs to optimize operational costs.

+ **Event-driven architecture** allows components to communicate with each other through events instead of calling each other directly. Components are decoupled, easier to scale, and more resilient to failures. In CloudCost Insight, Amazon SQS acts as an intermediate queue between Lambda Collector and Lambda Analyzer; the Dead Letter Queue stores messages that cannot be processed successfully after the allowed number of retries.

### Workshop overview

In this workshop, we will build the **CloudCost Insight** system to automatically monitor, analyze, and alert on AWS costs. The entire infrastructure is deployed using **Terraform** following the **Infrastructure as Code** model, making it possible to recreate, update, and clean up resources consistently.

The system includes the following main workflows:

+ **Cost collection and analysis workflow:** Amazon EventBridge triggers Lambda Collector on a scheduled basis. The Collector calls AWS Cost Explorer to retrieve cost data, stores the data in Amazon S3 using a year/month/day partition structure, and sends events to Amazon SQS. Lambda Analyzer receives events from SQS, reads data from S3, and compares it with the budget threshold and historical average to detect abnormal cost cases.

+ **Error handling, monitoring, and alerting workflow:** Lambda Analyzer uses the **SQS partial batch failure** mechanism to retry only messages that fail to be processed. If it cannot read the main data file from S3, the Analyzer records an error log and returns the failed message to SQS instead of ignoring the error. Messages that continue to fail will be moved to the **Dead Letter Queue**. Amazon CloudWatch collects logs and metrics and triggers Alarms when Lambda errors occur or when the DLQ contains messages. Amazon SNS sends email alerts when costs exceed the threshold, increase abnormally, or when the system encounters an issue.

+ **Visualization and security workflow:** The Web Dashboard displays KPIs, cost trends, alert thresholds, and the services with the highest costs. Lambda API reads data from S3, and Amazon API Gateway then provides an HTTP API for the frontend. The web interface is hosted on Amazon S3 and distributed through Amazon CloudFront with HTTPS. Amazon Cognito manages users and issues JWTs after login; API Gateway only allows requests with valid JWTs to access data. CORS is also restricted so that only the Dashboard's CloudFront domain can call the API from a browser.

+ **Testing and CI/CD workflow:** The source code is automatically checked by GitHub Actions before being merged into the `main` branch, including the Hugo Workshop, Python Lambda, Terraform, and Dashboard JavaScript. Terraform changes, after being merged into `main`, are automatically deployed through HCP Terraform. Branch protection and GitHub Environment help control changes before updating the AWS production infrastructure.

![overview](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

After completing the workshop, you will have a basic FinOps system that can automatically collect cost data, detect anomalies, send alerts, visualize data, protect the Dashboard with user authentication, and deploy infrastructure through a CI/CD process.

### Next content

- [Prerequisites](5-Workshop/5.2-Prerequisite/)