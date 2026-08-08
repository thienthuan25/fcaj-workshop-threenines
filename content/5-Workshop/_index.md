---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Building an AWS Cost Monitoring, Analysis, and Alerting System with Serverless Architecture

### Overview

**CloudCost Insight** is a Serverless FinOps system that automatically collects, analyzes, visualizes, and alerts on AWS service usage costs on a scheduled basis. Instead of manually checking the AWS Billing Console, the system retrieves cost data from AWS Cost Explorer, detects cases where costs exceed thresholds or increase abnormally, and then proactively sends email alerts.

In this workshop, we will build the system using a **Serverless** and **event-driven** architecture, using **Terraform** to deploy the entire infrastructure as **Infrastructure as Code**. The system is designed with error handling, operational monitoring, user authentication for the Dashboard, and an automated CI/CD process.

The system consists of four main workflows that work together:

+ **Cost collection and analysis workflow:** Amazon EventBridge triggers Lambda Collector on a scheduled basis to call AWS Cost Explorer and retrieve cost data. The Collector stores data in Amazon S3 and sends events through Amazon SQS. Lambda Analyzer receives events, reads data from S3, and compares costs with the budget threshold and historical average to detect abnormal costs.

+ **Error handling, monitoring, and alerting workflow:** Lambda Analyzer uses the SQS partial batch failure mechanism to retry only failed messages. Messages that cannot be processed after multiple retries are moved to the SQS Dead Letter Queue. Amazon CloudWatch collects logs and metrics and triggers Alarms when Lambda encounters errors or when the DLQ contains messages. Amazon SNS sends emails when costs exceed thresholds, increase abnormally, or when the system encounters an issue.

+ **Visualization and security workflow:** The Web Dashboard displays KPIs, cost trend charts, alert thresholds, and the services with the highest costs. Lambda API reads data from S3, Amazon API Gateway provides an HTTP API, and the interface is hosted on Amazon S3 and distributed through Amazon CloudFront with HTTPS. Amazon Cognito authenticates users and issues JWTs; API Gateway only allows requests with valid JWTs to access data. CORS is also restricted so that only the Dashboard's CloudFront domain is allowed to call the API from a browser.

+ **Testing and CI/CD workflow:** Source code is automatically checked by GitHub Actions before being merged into the `main` branch, including the Hugo Workshop, Python Lambda, Terraform, and Dashboard JavaScript. After Terraform changes are merged into `main`, GitHub Actions automatically performs Terraform Apply through HCP Terraform. Branch protection and GitHub Environment help control changes before updating the AWS production infrastructure.

### Content

1. [Introduction](5.1-Workshop-overview/)
2. [Prerequisites](5.2-Prerequisite/)
3. [Build the Core Infrastructure with Terraform](5.3-Infrastructure/)
4. [Deploy Lambda Collector and Lambda Analyzer](5.4-Lambda/)
5. [Configure Monitoring and Alerting (CloudWatch Alarm)](5.5-Monitoring/)
6. [Build the Web Dashboard](5.6-Dashboard/)
7. [System Testing](5.7-Testing/)
8. [CI/CD](5.8-CI-CD/)
9. [Clean Up Resources](5.9-Cleanup/)