---
title: "Project Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---


# CloudCost Insight
## An AWS Serverless Solution for Cloud Cost Monitoring, Analysis, and Alerting

### 1. Executive Summary
CloudCost Insight is a solution that helps individuals, teams, and startups proactively monitor, analyze, and receive alerts for AWS costs. The system automatically collects cost data on a scheduled basis from AWS Cost Explorer, stores the data, analyzes instances of threshold violations or sudden spikes, and then sends email alerts and visualizes the results on a Web Dashboard.

The solution is built on an AWS Serverless and event-driven architecture, requires no server management, has automatic scaling capabilities, and is suitable for small-scale deployments. The entire infrastructure is defined using Terraform, with remote state managed on HCP Terraform and automated deployment via GitHub Actions. The Dashboard is secured using Amazon Cognito, JWT Authorizer, and CORS configuration that only allows API access from the project's CloudFront domain.

### 2. Problem Statement
*Current Problem*
<br>With AWS's pay-as-you-go pricing model, costs can increase rapidly due to misconfigurations or uncontrolled resources, such as forgetting to stop EC2 instances, using unnecessary NAT Gateways, or generating excessive CloudWatch Logs. Users often only discover issues when checking the Billing Console or receiving their monthly invoice.

Manually tracking multiple services is time-consuming and prone to oversight. Meanwhile, specialized FinOps platforms can be complex or unsuitable for the needs of individuals, small teams, and learning environments.

*Solution*
<br>CloudCost Insight uses the AWS Cost Explorer API to retrieve daily cost data by service. Amazon EventBridge periodically triggers the Lambda Collector to gather data, store it in Amazon S3, and send an event to Amazon SQS.

The Lambda Analyzer receives events from SQS, reads data from S3, and compares costs against budget thresholds and historical averages to detect anomalies. Error messages are handled using the SQS partial batch failure mechanism, which only retries failed messages and moves them to a Dead Letter Queue (DLQ) if the allowed retry limit is exceeded.

Upon detecting anomalies or operational issues, the system uses Amazon SNS to send alert emails. Amazon CloudWatch collects logs, metrics, and triggers alarms when Lambda encounters errors or the DLQ receives messages.

Cost data is provided via the Web Dashboard. The Lambda API reads data from S3, Amazon API Gateway provides the HTTP API, and the web interface is hosted on Amazon S3 and distributed via Amazon CloudFront. Users must log in using Amazon Cognito to obtain a valid JWT before they can access cost data.

*Benefits and Return on Investment (ROI)*
<br>The solution enables early detection of threshold violations or cost spikes, reducing the risk of unexpected bills and saving time on manual monitoring. The system establishes a basic FinOps foundation that can be expanded with cost forecasting, tag-based cost allocation, or resource optimization recommendations.

With low collection frequency and a serverless architecture, operational costs are well-suited for workshop environments or small scales. Detecting and preventing just one significant cost incident can yield benefits that far exceed the system's operational costs.

### 3. Solution Architecture
The platform adopts an AWS Serverless, event-driven, and fault-tolerant architecture. The Lambda Collector periodically collects data from Cost Explorer, stores it in S3, and sends events to SQS. The Lambda Analyzer processes events, analyzes costs, sends alerts via SNS, and utilizes a DLQ for messages that cannot be processed successfully.

The Web Dashboard fetches data via API Gateway and Lambda API. Amazon Cognito secures the Dashboard using JWT authentication; CORS only allows valid CloudFront domains to call the API from the browser. The entire infrastructure is deployed using Terraform and automated via GitHub Actions.


![CloudCost Insight Architecture](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

*AWS Services Used*
- *Amazon EventBridge*: Schedules periodic triggers for the Lambda Collector.
- *AWS Lambda*: Includes Collector, Analyzer, and API for providing data to the Dashboard.
- *AWS Cost Explorer API*: The source for AWS cost and usage data.
- *Amazon S3*: Stores cost data in a year/month/day partitioned structure and hosts the static web interface.
- *Amazon SQS*: Intermediate queue between Collector and Analyzer.
- *Amazon SQS Dead Letter Queue*: Stores messages that fail processing after retries.
- *Amazon SNS*: Sends email alerts for costs and system issues.
- *Amazon CloudWatch*: Collects logs, metrics, and creates alarms to monitor Lambda or DLQ.
- *Amazon API Gateway*: Provides the HTTP API for the Web Dashboard.
- *Amazon CloudFront*: Distributes the web interface via HTTPS.
- *Amazon Cognito*: Manages users, login, and issues JWTs for the Dashboard.
- *AWS IAM*: Grants permissions based on the least privilege principle for each component.
- *HCP Terraform*: Manages remote state and performs Terraform remote runs.
- *GitHub Actions*: Automates source code testing and infrastructure deployment.

*Component Design*
- *Scheduling*: EventBridge triggers the Lambda Collector on a predefined schedule.
- *Data Collection*: The Lambda Collector calls the Cost Explorer API to retrieve daily costs by service.
- *Data Storage*: Cost data is stored in S3 using a year/month/day structure.
- *Event Buffering*: The Collector sends events to SQS to decouple the collection and analysis processes.
- *Processing and Detection*: The Analyzer reads data from S3, comparing it with budget thresholds and historical averages to determine INFO, WARNING, or CRITICAL levels.
- *Error Handling*: When a message in a batch fails, the Analyzer returns `batchItemFailures` so SQS only retries the failed message. Messages that fail multiple times are moved to the DLQ.
- *Alerting*: SNS sends emails when costs exceed thresholds, spike suddenly, or when system issues occur.
- *Monitoring*: CloudWatch tracks logs, Lambda errors, and the number of messages in the DLQ.
- *Visualization*: The Dashboard displays KPIs, cost trends, alert thresholds, and the highest-cost services.
- *Security*: Cognito authenticates users; API Gateway validates JWTs; CORS restricts to CloudFront domains; S3 Block Public Access and CloudFront Origin Access Control protect the web bucket.

### 4. Technical Implementation
*Implementation Phases*
<br>The project is implemented in the following phases:
1. *Research and Architecture Design*: Research the AWS Cost Explorer API, serverless and event-driven models, and design the system architecture.
2. *Infrastructure Construction using Terraform*: Create S3, IAM Roles, SNS, SQS, DLQ, EventBridge, CloudWatch, API Gateway, CloudFront, and Cognito.
3. *Lambda Development*: Build the Lambda Collector, Analyzer, and API using Python and boto3.
4. *Adding Fault Tolerance*: Configure SQS partial batch failure, DLQ, S3 read error handling, and CloudWatch Alarms.
5. *Web Dashboard Construction*: Develop the frontend with HTML/CSS/JavaScript and Chart.js, integrating API Gateway, Cognito, and CloudFront.
6. *System Testing*: Test data collection workflows, anomaly detection, DLQ, partial batch failure, S3 errors, CloudWatch Alarms, Cognito/JWT security, CORS, and frontend caching.
7. *CI/CD Automation*: Configure GitHub Actions to test Hugo Workshop, Python, Terraform, and JavaScript; automate Terraform Apply after changes are merged into main.
8. *Resource Cleanup*: Perform terraform destroy after completing the workshop to avoid incurring costs.

*Technical Requirements*
- *Infrastructure (IaC)*: Terraform defines all AWS resources; remote state is managed on HCP Terraform; infrastructure can be reproduced with `terraform apply` and cleaned up with `terraform destroy`.
- *Processing Logic*: Python Lambdas use boto3 to call `ce:GetCostAndUsage`, save to S3, send SQS messages, and send SNS alerts.
- *Web Dashboard*: The Lambda API reads data from S3 and returns JSON; API Gateway provides endpoints; the frontend uses Chart.js for data visualization.
- *Security*: IAM least privilege, S3 Block Public Access, CloudFront Origin Access Control, Cognito User Pool, JWT Authorizer, and CORS domain restrictions.
- *Testing*: Unit testing using pytest and AWS client mocking; system testing performed on AWS Console, CloudWatch Logs, SQS, Cognito, and Dashboard.
- *CI/CD*: GitHub Actions checks source code prior to merging and deploys Terraform via HCP Terraform.

### 5. Roadmap and Milestones
- *Internship (Months 1 to 3)*:
    - *Month 1*: Learn about AWS and architectural design.
    - *Month 2*: Build infrastructure, Lambda Collector, Analyzer, SQS, DLQ, SNS, and CloudWatch.
    - *Month 3*: Develop the Dashboard, add Cognito, perform system testing, build CI/CD, and finalize the workshop.
- *Post-Deployment*: Expand the project with cost forecasting, tag-based cost allocation, resource optimization recommendations, or a custom domain for the Dashboard.

### 6. Budget Estimation
Costs can be reviewed on the [AWS Pricing Calculator](https://calculator.aws/#/estimate)

*Infrastructure Costs*
- AWS Lambda: USD 0.00/month (within Free Tier, a few dozen requests/day, 3 functions).
- Amazon S3: ~USD 0.05/month (small storage including JSON cost data and static web).
- Amazon SQS: USD 0.00/month (within Free Tier, 1 million requests/month).
- Amazon SNS: USD 0.00/month (within Free Tier, 1,000 emails/month).
- Amazon EventBridge: USD 0.00/month (within Free Tier).
- Amazon API Gateway: USD 0.00/month (within Free Tier, 1 million requests/month).
- Amazon CloudFront: ~USD 0.00 to 0.10/month (low traffic, within Free Tier).
- AWS Cost Explorer API: ~USD 0.30/month (~USD 0.01/request, ~1 request/day).
- Amazon CloudWatch: ~USD 0.10/month (basic logs and alarms).
- Amazon Cognito: USD 0.00/month (free for 50,000 MAU/month).

*Total*: ~USD 0.5 to 1/month, ~USD 6 to 12/12 months.
- *Hardware*: USD 0 (fully runs on AWS, no physical equipment needed).

### 7. Risk Assessment
*Risk Matrix*
- Excessive Cost Explorer API calls leading to increased costs: Medium Impact, Low Probability.
- Incorrect IAM or Cognito configuration: High Impact, Low Probability.
- Inappropriate alerts due to inadequate thresholds or historical data: Medium Impact, Medium Probability.
- Error processing messages retried too many times: Medium Impact, Low Probability.
- Forgetting to clean up AWS resources: Medium Impact, Medium Probability.
- Deploying faulty Terraform changes to production: High Impact, Low Probability.

*Mitigation Strategy*
- API Costs: Limit Collector to run on a scheduled basis, avoid unnecessary Cost Explorer calls, and monitor the Billing Dashboard.
- Security: Apply IAM least privilege, Cognito JWT Authorizer, CORS restricted to CloudFront, and avoid storing tokens directly in source code.
- Alerts: Adjust budget thresholds and historical days to align with actual data.
- Error Handling: Use partial batch failure, DLQ, and CloudWatch Alarms to ensure failed messages are not missed.
- Deployment: Use Pull Requests, CI, branch protection, and GitHub Environments prior to Terraform Apply.
- Clean-up: Review `terraform plan -destroy`, then run `terraform destroy` when no longer in use.

*Contingency Plan*
- Manually check costs on AWS Billing Console or Cost Explorer when the system encounters issues.
- Check CloudWatch Logs, SQS, and DLQ to identify error messages.
- Use Terraform to recreate the entire infrastructure if necessary.
- Revoke or replace tokens and secrets if credential exposure risks are detected.

### 8. Expected Outcomes
*Technical Improvements*: A system that automatically collects, analyzes, and alerts on AWS costs periodically; featuring a serverless, event-driven, fault-tolerant architecture, an intuitive Web Dashboard, and Cognito authentication to protect cost data.

*Long-term Value*: CloudCost Insight is a FinOps MVP that can be reused and further developed in the future, such as cost forecasting, cost allocation by department/project, tag-based analysis, resource optimization recommendations, or integrating additional alerting channels.