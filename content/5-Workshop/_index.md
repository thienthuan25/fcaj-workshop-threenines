---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Building an AWS Cost Monitoring and Alerting System with a Serverless Architecture

#### Overview

**CloudCost Insight** is a Serverless system that automatically monitors, analyzes, and alerts users about AWS service costs in near real time without requiring any manual intervention. Instead of signing in to the AWS Billing Console every day to check cloud spending, the system automatically collects cost data, detects anomalies, and proactively sends email notifications whenever spending exceeds a predefined threshold.

In this lab, we will learn how to build a complete FinOps solution on AWS using a Serverless and event driven architecture. The entire infrastructure is provisioned with Terraform as Infrastructure as Code. The solution is designed to fully automate the entire workflow, from collecting and analyzing cost data to sending alerts and visualizing the results.

The system consists of three main workflows. Each workflow has a specific responsibility while working together as part of a complete solution.

- **Data collection and analysis workflow**: Amazon EventBridge schedules the Lambda Collector to run periodically and retrieve cost data from the AWS Cost Explorer API. The collected data is stored in Amazon S3, and an event is published to Amazon SQS. The Lambda Analyzer then processes the event, analyzes the cost data, detects budget threshold violations or unusual cost spikes, and sends notifications through Amazon SNS.

- **Monitoring and error handling workflow**: Amazon CloudWatch collects logs and metrics from the Lambda functions and triggers alarms whenever the system encounters failures. Failed processing events are redirected to the Amazon SQS Dead Letter Queue to ensure that no data is lost.

- **Data visualization workflow**: A custom web dashboard retrieves cost data through the Lambda API and Amazon API Gateway. The frontend is hosted on Amazon S3 and delivered through Amazon CloudFront, allowing users to monitor cost trends through an intuitive interface.

#### Contents

1. [Introduction](5.1-Workshop-overview/)
2. [Prerequisites](5.2-Prerequisite/)
3. [Provisioning the Infrastructure with Terraform](5.3-Infrastructure/)
4. [Deploying the Lambda Collector and Lambda Analyzer](5.4-Lambda/)
5. [Configuring Monitoring and Alerts with CloudWatch Alarms](5.5-Monitoring/)
6. [Building the Web Dashboard](5.6-Dashboard/)
7. [System Testing](5.7-Testing/)
8. [Cleaning Up Resources](5.8-Cleanup/)