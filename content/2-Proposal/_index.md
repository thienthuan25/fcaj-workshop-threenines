---
title: "Project Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudCost Insight
## An AWS Serverless Solution for Near Real-Time Cloud Cost Monitoring and Alerting

### 1. Executive Summary

CloudCost Insight is designed to help individuals, teams, and startups using AWS proactively **monitor, analyze, and receive alerts for cloud costs** without manual intervention. The platform automatically collects cost data from AWS Cost Explorer on a scheduled basis, stores and analyzes the data to detect anomalies (such as sudden cost spikes or budget threshold violations), then sends email notifications and visualizes the results through a custom-built web dashboard. The system is built entirely on an AWS Serverless architecture, requiring no server management, automatically scaling based on demand, operating at an extremely low cost (approximately USD 1–2 per month), and deployed using Terraform for easy infrastructure provisioning, recreation, and cleanup.

### 2. Problem Statement

*Current Problem*

<br>With AWS's pay-as-you-go pricing model, cloud costs can quickly become difficult to control. A simple configuration mistake, such as forgetting to stop an EC2 instance, enabling a NAT Gateway, or generating excessive logs, can cause the monthly bill to increase dramatically without being noticed until the billing cycle ends. The AWS Billing Console only displays usage data and does not proactively notify users of unusual spending. In addition, manually monitoring multiple AWS services across different environments (development, testing, and production) is time-consuming and prone to oversight. Third-party FinOps solutions are often expensive and overly complex for small-scale users.

*Proposed Solution*

<br>The platform uses the **AWS Cost Explorer API** as its primary cost data source. **Amazon EventBridge** schedules periodic execution, while an **AWS Lambda** function (Collector) retrieves cost data and stores it in **Amazon S3**. An **Amazon SQS** queue serves as an event buffer, temporarily storing processing events. This design decouples the data collection and analysis stages, allowing both processes to operate independently without blocking each other. Next, another **AWS Lambda** function (Analyzer) consumes events from the queue, analyzes the collected data, compares costs against predefined budget thresholds, and detects anomalies. Failed processing events are redirected to an **Amazon SQS Dead Letter Queue (DLQ)**. Whenever spending exceeds the configured threshold, **Amazon SNS** sends email notifications. **Amazon CloudWatch** monitors logs and metrics and triggers alarms whenever system failures occur, while **AWS IAM** and **AWS Secrets Manager** provide security for permissions and sensitive information.

A key feature of the platform is its **custom-built web dashboard**, where **AWS Lambda** acts as the backend API, **Amazon API Gateway** exposes REST endpoints, the frontend is hosted on **Amazon S3**, and content is delivered through **Amazon CloudFront**. This dashboard enables users to visualize cost trends, configure alert thresholds, and view consolidated cost reports instead of manually checking individual AWS services.

*Benefits and Return on Investment (ROI)*

<br>The solution enables early detection of abnormal cloud spending, helping users avoid unexpectedly high monthly bills while significantly reducing the effort required for manual monitoring. It also provides a lightweight FinOps foundation that can be extended with advanced capabilities such as cost forecasting, cost allocation by tags or business units, and optimization recommendations. The estimated monthly operating cost is approximately USD 1–2 (primarily covered by the AWS Free Tier), with no hardware investment required because the entire solution runs on AWS. The return on investment is almost immediate—a single detected cost anomaly can save more money than the annual operating cost of the system.

### 3. Solution Architecture

The platform adopts an AWS Serverless, event-driven, and resilient architecture. Cost data is periodically collected from the AWS Cost Explorer API by the Lambda Collector, stored in Amazon S3, and forwarded through Amazon SQS for processing by the Lambda Analyzer to detect anomalies. Alerts are delivered via Amazon SNS. Cost information is visualized through a custom-built web dashboard, where the Lambda API provides data, Amazon API Gateway exposes the HTTP endpoints, the web interface is hosted on Amazon S3, and Amazon CloudFront distributes the frontend globally. The entire infrastructure is provisioned using Terraform.

![CloudCost Insight Architecture](/fcaj-workshop-threenines/images/2-Proposal/CloudCostInsight.jpg)

*AWS Services Used*

- *Amazon EventBridge*: Schedules periodic execution (cron schedule, e.g., once per day).
- *AWS Lambda*: Processes system logic, including the Collector (cost collection), Analyzer (anomaly detection), and API (dashboard backend) functions (three Lambda functions).
- *AWS Cost Explorer API*: The official AWS source for cloud cost data.
- *Amazon S3*: Stores cost data (partitioned by date/month) and hosts the static web frontend (two buckets).
- *Amazon SQS*: Event queue for decoupling components and a Dead Letter Queue (DLQ) for error handling.
- *Amazon SNS*: Sends email notifications when budget thresholds are exceeded or when system failures occur.
- *Amazon CloudWatch*: Collects logs and metrics and triggers alarms for the entire system (Lambda failures and DLQ messages).
- *Amazon API Gateway*: Exposes the Lambda API as an HTTP endpoint for the web dashboard.
- *Amazon CloudFront*: Delivers the web frontend through a secure HTTPS CDN.
- *AWS IAM*: Manages permissions according to the Principle of Least Privilege for each Lambda function.
- *AWS Secrets Manager*: Securely stores sensitive information (e.g., Slack webhook URLs).

*Component Design*

- *Scheduling*: Amazon EventBridge periodically triggers the Lambda Collector.
- *Data Collection*: The Lambda Collector retrieves cost data from the AWS Cost Explorer API.
- *Data Storage*: Raw cost data is stored in Amazon S3 using date/month partitions.
- *Event Buffering*: The Collector publishes events to an Amazon SQS queue to decouple data collection from data analysis.
- *Processing and Detection*: The Lambda Analyzer reads cost data from Amazon S3, consumes events from Amazon SQS, compares costs against predefined budget thresholds, and detects cost spikes based on historical averages. Failed events are redirected to the DLQ.
- *Alerting*: Amazon SNS sends email notifications when abnormal costs are detected, categorized as INFO, WARNING, or CRITICAL.
- *Monitoring*: Amazon CloudWatch collects Lambda logs and metrics and triggers alarms (via Amazon SNS) whenever Lambda execution fails or messages are sent to the DLQ.
- *Visualization*: The web dashboard retrieves data through Amazon API Gateway and the Lambda API, reads cost information from Amazon S3, and displays cost trends, thresholds, and anomaly indicators using interactive charts. The frontend is hosted on Amazon S3 and distributed through Amazon CloudFront.
- *Security*: Each Lambda function has its own IAM Role following the Principle of Least Privilege. AWS Secrets Manager stores sensitive secrets securely. Amazon S3 blocks public access, while the web bucket is protected using Origin Access Control (OAC).

### 4. Technical Implementation

*Implementation Phases*

<br>The project consists of three major components: infrastructure, processing logic, and the web dashboard, developed through the following phases:

1. *Research and Architecture Design*: Study the AWS Cost Explorer API, Serverless architecture, and design the overall AWS solution.
2. *Infrastructure Provisioning with Terraform*: Create Amazon S3, IAM Roles, Amazon SNS, Amazon SQS with DLQ, and Amazon EventBridge while managing remote state using HCP Terraform.
3. *Lambda Development*: Develop the Lambda Collector (integrating with the AWS Cost Explorer API) and the Lambda Analyzer (implementing anomaly detection, alerting logic, and three-level severity classification).
4. *Monitoring and Error Handling*: Add CloudWatch Alarms (Lambda failures and DLQ monitoring) and verify the Dead Letter Queue mechanism.
5. *Web Dashboard Development*: Develop the Lambda API and API Gateway backend, build the HTML/CSS/JavaScript frontend using Chart.js, and deploy it to Amazon S3 with Amazon CloudFront.
6. *End-to-End Testing, Bilingual Documentation, and Infrastructure Cleanup.*

*Technical Requirements*

- *Infrastructure (IaC)*: Practical knowledge of Terraform for defining all AWS resources. Remote state is managed using HCP Terraform to support collaborative development. The entire infrastructure can be provisioned with a single command and completely removed using `terraform destroy`.
- *Processing Logic*: Lambda functions are implemented in Python using boto3, invoking the AWS Cost Explorer API (`ce:GetCostAndUsage`), processing and storing cost data in Amazon S3, and publishing events to Amazon SQS and Amazon SNS. Anomaly detection is based on comparisons against both predefined budget thresholds and historical average costs.
- *Web Dashboard*: The Lambda API (Python) retrieves data from Amazon S3 and returns JSON responses with CORS support. Amazon API Gateway exposes HTTP endpoints. The frontend uses Chart.js to consume the API and visualize cost data, and is statically hosted on Amazon S3 with Amazon CloudFront.
- *Security*: Each Lambda function uses a dedicated IAM Role following the Principle of Least Privilege. AWS access keys are never hard-coded. Amazon S3 Block Public Access is enabled. The web bucket is protected with Origin Access Control, allowing access only through CloudFront.

### 5. Project Roadmap and Milestones

- *Internship Period (Months 1–3)*:
    - *Month 1*: Learn AWS services and design the solution architecture.
    - *Month 2*: Build the infrastructure and Lambda functions using Terraform.
    - *Month 3*: Add monitoring and alerting, develop the web dashboard, perform end-to-end testing, and deploy the solution.

- *Post-Deployment*: Extend the platform with additional capabilities such as cost forecasting, tag-based cost allocation, and a custom domain for the dashboard.

### 6. Budget Estimation

Cost estimates can be calculated using the [AWS Pricing Calculator](https://calculator.aws/#/estimate).

*Infrastructure Costs*

- AWS Lambda: USD 0.00/month (within the AWS Free Tier, a few dozen requests per day, three functions).
- Amazon S3: Approximately USD 0.05/month (small storage footprint for JSON cost data and static website files).
- Amazon SQS: USD 0.00/month (within the AWS Free Tier, up to one million requests per month).
- Amazon SNS: USD 0.00/month (within the AWS Free Tier, up to 1,000 email notifications per month).
- Amazon EventBridge: USD 0.00/month (within the AWS Free Tier).
- Amazon API Gateway: USD 0.00/month (within the AWS Free Tier, up to one million requests per month).
- Amazon CloudFront: Approximately USD 0.00–0.10/month (low traffic, generally within the AWS Free Tier).
- AWS Cost Explorer API: Approximately USD 0.30/month (about USD 0.01 per request, approximately one request per day).
- Amazon CloudWatch: Approximately USD 0.10/month (basic logs and alarms).

*Total*: Approximately USD 0.5–1.0 per month, or about USD 6–12 per year.

- *Hardware*: USD 0 (the entire solution runs on AWS and requires no physical hardware).

### 7. Risk Assessment

*Risk Matrix*

- Excessive AWS Cost Explorer API requests resulting in additional charges: Medium impact, medium probability.
- Incorrect IAM configuration (insufficient or excessive permissions): High impact, low probability.
- False alerts or excessive notifications due to inappropriate threshold settings: Low impact, medium probability.
- Forgetting to clean up AWS resources, resulting in unexpected charges: Medium impact, low probability.

*Mitigation Strategies*

- API Costs: Limit API calls (once per day), cache cost data, and configure CloudWatch Alarms for spending.
- IAM: Apply the Principle of Least Privilege and thoroughly test IAM policies before deployment.
- Alerts: Tune alert thresholds using historical data and implement duplicate alert suppression logic.
- Cleanup: Use `terraform destroy` and follow a project cleanup checklist.

*Contingency Plan*

- Fall back to manual cost monitoring through the AWS Billing Console if the system experiences failures.
- Use Terraform (Infrastructure as Code) to quickly restore the complete AWS infrastructure configuration.

### 8. Expected Outcomes

*Technical Improvements*: Automated near real-time cloud cost monitoring and alerting, replacing manual cost inspection. The solution provides a Serverless, event-driven, resilient, and highly scalable architecture, complemented by a custom-built web dashboard for intuitive data visualization.

<br>*Long-Term Value*: A complete FinOps Minimum Viable Product (MVP) that can be reused and extended for future projects, including features such as cost forecasting, departmental or project-based cost allocation, AWS resource optimization recommendations, and custom domain integration for the dashboard.