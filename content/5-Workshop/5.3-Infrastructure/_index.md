---
title : "Provision Infrastructure with Terraform"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Introduction

In this section, you will provision the core infrastructure for the CloudCost Insight system using Terraform. These foundational resources will be used by the Lambda functions in the following sections. They include storage for cost data, an event queue, a notification service, and a scheduling service.

![S3, IAM, SNS, SQS + DLQ, EventBridge](/fcaj-workshop-threenines/images/5-Workshop/5.3-Infrastructure/Infrastructure_diagram.jpg)

#### Contents

- [Declare Input Variables](5.3.1-Variables/)
- [Create an Amazon S3 Bucket for Cost Data Storage](5.3.2-S3-bucket/)