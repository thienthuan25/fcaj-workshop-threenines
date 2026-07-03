---
title: "Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudCost Insight
## A Unified AWS Serverless Solution for Near Real-Time Cloud Cost Monitoring and Alerting

### 1. Executive Summary
CloudCost Insight is designed to help individuals, teams, or startups using AWS to proactively **monitor, analyze, and alert on** cloud service costs without any manual effort. The platform automatically collects cost data on a scheduled basis from AWS Cost Explorer, stores and analyzes it to detect anomalies (cost spikes, budget threshold breaches), and then sends alerts via Email/Slack. The system is built entirely on an AWS Serverless architecture — no server management, automatic scaling, and extremely low operating cost (under 1–2 USD/month) — and is deployed with Terraform so it can be easily reproduced and cleaned up.

### 2. Problem Statement
*Current Problem*
With AWS's pay-as-you-go pricing model, costs can easily spiral out of control: a single misconfiguration (forgetting to shut down EC2, enabling a NAT Gateway, excessive logging) can cause the bill to surge without anyone noticing until the end of the billing period. The Billing Console only displays figures and does not proactively alert, while manually tracking many services across multiple environments (dev/test/prod) is time-consuming and error-prone. Third-party FinOps tools are often expensive and overly complex for small-scale needs.

*Solution*
The platform uses the **AWS Cost Explorer API** as the cost data source, **Amazon EventBridge** to schedule periodic runs, **AWS Lambda** (Collector) to collect data, and **Amazon S3** for storage. An **Amazon SQS** queue buffers events to reduce coupling, then **AWS Lambda** (Analyzer) analyzes, compares against thresholds, and detects anomalies; failed processing events are routed to an **SQS Dead Letter Queue (DLQ)**. When costs exceed the threshold, **Amazon SNS** sends alerts via Email/Slack. **Amazon CloudWatch** monitors logs/metrics/alarms across the whole system, **AWS IAM** and **AWS Secrets Manager** ensure security, and **Amazon QuickSight** provides a dashboard to visualize cost trends. Users can customize alert thresholds and view centralized cost reports instead of manually checking each service.

*Benefits and Return on Investment (ROI)*
The solution helps detect abnormal costs early, avoiding end-of-month "bill shock" and saving time on manual tracking. The system establishes a basic FinOps foundation that can be extended with additional features (cost forecasting, cost allocation by tag/group, optimization recommendations). Monthly operating cost is estimated at under 1–2 USD (mostly within the Free Tier), with no hardware costs since everything runs on AWS. The payback period is almost immediate: catching just one cost anomaly already saves more than a full year of operating cost.

### 3. Solution Architecture
The platform adopts an AWS Serverless, event-driven, and resilient architecture. Cost data is collected periodically from the Cost Explorer API by the Lambda Collector, stored in S3, and pushed as events through SQS for the Lambda Analyzer to process and detect anomalies; alerts are sent via SNS, and the dashboard is displayed with QuickSight. The entire infrastructure is deployed using Terraform.


![CloudCost Insight Architecture](/static/images/2-Proposal/CloudCostInsight-diagram.png)


*AWS Services Used*
- *Amazon EventBridge*: Schedules periodic triggers (cron, e.g. once per day).
- *AWS Lambda*: Data processing — Collector (cost collection) and Analyzer (anomaly detection) (2 functions).
- *AWS Cost Explorer API*: AWS's official cost data source.
- *Amazon S3*: Stores cost data (partitioned by day/month).
- *Amazon SQS*: Event buffer queue + Dead Letter Queue (DLQ) for error handling.
- *Amazon SNS*: Sends alerts via Email/Slack when thresholds are exceeded.
- *Amazon CloudWatch*: Logs, Metrics, Alarms monitoring the whole system.
- *AWS IAM*: Manages permissions following the least-privilege principle for each Lambda.
- *AWS Secrets Manager*: Securely stores sensitive information (e.g. Slack webhook).
- *Amazon QuickSight*: Dashboard to visualize cost trends.

*Component Design*
- *Scheduling*: EventBridge triggers the Lambda Collector on a predefined cycle.
- *Data Collection*: The Lambda Collector calls the Cost Explorer API to retrieve cost data.
- *Data Storage*: Raw cost data is stored in S3, partitioned by day/month.
- *Event Buffering*: The Collector pushes events into the SQS Queue to decouple collection from analysis.
- *Processing & Detection*: The Lambda Analyzer reads data from S3, consumes events from SQS, compares against budget thresholds, and detects anomalies; failed events are pushed to the DLQ.
- *Alerting*: SNS sends Email/Slack notifications to users when costs exceed the threshold.
- *Monitoring*: CloudWatch collects logs/metrics from both Lambdas and triggers Alarms on errors.
- *Visualization*: QuickSight reads data from S3 to display a cost-trend dashboard.
- *Security*: Least-privilege IAM Roles for each component; Secrets Manager stores secrets; S3 blocks public access.

### 4. Technical Implementation
*Implementation Phases*
The project consists of 2 parts — building the base infrastructure and developing the processing logic — going through 4 phases:
1. *Research and architecture design*: Research the Cost Explorer API, the serverless model, and design the AWS architecture (Week 1).
2. *Provision base infrastructure with Terraform*: Create S3, IAM Role, SNS, SQS, EventBridge (Week 2).
3. *Develop Lambda functions*: Write the Lambda Collector (Cost Explorer API integration) and the Lambda Analyzer (anomaly detection & alerting logic) (Weeks 3–4).
4. *Dashboard, testing, deployment*: Build the QuickSight dashboard, perform end-to-end testing, write the bilingual report, and clean up (Weeks 5–6).

*Technical Requirements*
- *Infrastructure (IaC)*: Practical knowledge of Terraform to define all AWS resources (S3, IAM, Lambda, SQS, SNS, EventBridge, CloudWatch). The entire infrastructure must be reproducible with a single command and fully cleaned up with `terraform destroy`.
- *Processing Logic*: Lambdas written in Python (boto3), calling the Cost Explorer API (`ce:GetCostAndUsage`), processing and writing data to S3, and publishing SQS/SNS events. Anomaly detection logic is based on comparison against budget thresholds and historical cost trends.
- *Security*: A dedicated least-privilege IAM Role for each Lambda; no hard-coded access keys; secrets (Slack webhook) stored in Secrets Manager; S3 with Block Public Access and encryption enabled.

### 5. Roadmap & Milestones
- *Internship (Months 1–3)*:
    - *Month 1*: Learn about AWS and design the architecture.
    - *Month 2*: Build the system with Terraform.
    - *Month 3*: Deploy, test, and put into use.
- *Post-deployment*: Extend with additional features (cost forecasting, allocation by tag).

### 6. Budget Estimation
You can view the cost on the [AWS Pricing Calculator](https://calculator.aws/#/estimate)

*Infrastructure Cost*
- AWS Lambda: 0.00 USD/month (within Free Tier — a few dozen requests/day).
- Amazon S3: ~0.05 USD/month (small volume, cost data in JSON/CSV).
- Amazon SQS: 0.00 USD/month (within Free Tier — 1 million requests/month).
- Amazon SNS: 0.00 USD/month (within Free Tier — 1,000 emails/month).
- Amazon EventBridge: 0.00 USD/month (within Free Tier).
- AWS Cost Explorer API: ~0.30 USD/month (~0.01 USD/request, ~1 request/day).
- Amazon CloudWatch: ~0.10 USD/month (basic logs & alarms).
- Amazon QuickSight: cost depends on the author plan (Grafana can be used to save cost).

*Total*: approximately 0.5–2 USD/month, ~6–24 USD/12 months (excluding QuickSight)
- *Hardware*: 0 USD (everything runs on AWS, no physical devices required).

### 7. Risk Assessment
*Risk Matrix*
- Calling the Cost Explorer API too often → incurring costs: Medium impact, medium probability.
- Misconfigured IAM (missing/excessive permissions): High impact, low probability.
- False/spam alerts due to poorly set thresholds: Low impact, medium probability.
- Forgetting clean-up → unexpected costs: Medium impact, low probability.

*Mitigation Strategies*
- API cost: Limit call frequency (once/day), cache data, set a CloudWatch Alarm for costs.
- IAM: Apply least privilege, thoroughly test policies before deployment.
- Alerting: Fine-tune thresholds based on historical data, add deduplication logic.
- Clean-up: Use `terraform destroy` and an end-of-project cleanup checklist.

*Contingency Plan*
- Fall back to manual cost checking via the Billing Console if the system fails.
- Use Terraform (IaC) to quickly restore the entire infrastructure configuration.

### 8. Expected Outcomes
*Technical Improvements*: Automated, near real-time cost monitoring and alerting, replacing manual checks. A serverless, event-driven, resilient, and easily scalable architecture.
*Long-term Value*: A basic FinOps foundation that can be reused and extended for future projects (cost forecasting, cost allocation by department/project, resource optimization recommendations).