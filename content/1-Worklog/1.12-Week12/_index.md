---
title: "Week 12 Worklog"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.12. </b> "
---

### Week 12 Objectives:

* Continue writing, reviewing, and completing the CloudCost Insight Workshop following step-by-step instructions.
* Verify that Hugo can build successfully and update the Workshop on GitHub Pages.
* Research topics, content, and how to publish blog posts on AWS Study Group.
* Write blog posts that share AWS knowledge, experiences from building CloudCost Insight, and directions for expanding the system.
* Prepare the script, data, and environment for recording the project demo.
* Record a demo video presenting the entire CloudCost Insight workflow.
* Maintain collaboration with the team: discuss plans before working and summarize results after each day.

### Tasks Implemented During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| 2 | - Continue writing the step-by-step Workshop: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Complete the infrastructure deployment, Lambda Collector, Lambda Analyzer, monitoring, and alerting sections. <br>&emsp; + Add testing instructions for SQS partial batch failure, Dead Letter Queue, and error handling when Analyzer cannot read data from S3. <br>&emsp; + Prepare illustrative images, logs, and expected results for each testing step. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 27/07/2026 | 27/07/2026 | - FCAJ Workshop Template. <br> - AWS Lambda Documentation: <br> https://docs.aws.amazon.com/lambda/ |
| 3 | - Complete the Workshop on Dashboard, security, and CI/CD: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Complete the instructions for building the Web Dashboard, authentication with Amazon Cognito, and API Gateway JWT Authorizer configuration. <br>&emsp; + Add testing content for JWT authentication, CORS, and frontend version updates on CloudFront. <br>&emsp; + Complete the CI/CD, branch protection, and resource cleanup sections. <br>&emsp; + Verify that the Hugo Workshop builds successfully and update the content on GitHub Pages. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 28/07/2026 | 28/07/2026 | - Amazon Cognito Documentation: <br> https://docs.aws.amazon.com/cognito/ <br> - GitHub Actions Documentation: <br> https://docs.github.com/en/actions |
| 4 | - Research and write Blog 1 and Blog 2: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Research how to develop content and publish posts on AWS Study Group. <br>&emsp; + Write Blog 1 about the knowledge and practical experiences gained from building CloudCost Insight with a Serverless architecture. <br>&emsp; + Research Amazon EventBridge Scheduler and write Blog 2 about its ability to replace cron jobs in AWS systems. <br>&emsp; + Review the content, images, and reference materials before publishing. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 29/07/2026 | 29/07/2026 | - AWS Study Group. <br> - AWS Compute Blog: <br> https://aws.amazon.com/blogs/compute/ <br> - Amazon EventBridge Scheduler Documentation: <br> https://docs.aws.amazon.com/scheduler/ |
| 5 | - Research and write Blog 3; prepare to record the project demo: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Research Amazon Bedrock AgentCore and the idea of expanding CloudCost Insight into an AI FinOps Agent. <br>&emsp; + Write Blog 3 about Amazon Bedrock AgentCore, AgentCore Runtime, Gateway, Identity, Memory, and Observability. <br>&emsp; + Prepare the demo script and recheck the AWS environment, simulated cost data, Dashboard, and alert emails. <br>&emsp; + Identify the content to present in the video: architecture, processing flow, security, testing, and CI/CD. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 30/07/2026 | 30/07/2026 | - Amazon Bedrock AgentCore Documentation. <br> - CloudCost Insight Workshop. |
| 6 | - Record the CloudCost Insight demo and review documentation: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Record a demo video of the entire CloudCost Insight system. <br>&emsp; + Present the Serverless architecture, cost collection flow, cost analysis, SNS alerts, DLQ, CloudWatch Alarm, Dashboard, and Cognito authentication. <br>&emsp; + Present the CI/CD process using GitHub Actions, HCP Terraform, and branch protection. <br>&emsp; + Recheck the Workshop, blog posts, and demo results before submission. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 31/07/2026 | 31/07/2026 | - CloudCost Insight Workshop. <br> - AWS Management Console. <br> - GitHub Repository. |

### Results Achieved in Week 12:

* **Completed the step-by-step Workshop:** Continued writing, reviewing, and completing the CloudCost Insight Workshop based on step-by-step instructions. The Workshop describes the entire process, from environment preparation, infrastructure deployment using Terraform, Lambda development, Dashboard, Cognito, system testing, and CI/CD to resource cleanup.

* **Added complete testing and security content:** Added important testing sections, including SQS partial batch failure, Dead Letter Queue, S3 error handling in Analyzer, JWT authentication using Amazon Cognito, CORS testing, and frontend updates to avoid using old cached versions. These sections include expected results, logs, and illustrative images.

* **Verified and updated the Workshop:** Verified that the Hugo Workshop builds successfully and reviewed its structure, code samples, images, and content links. The Workshop was updated on GitHub Pages so that it can be accessed and followed.

* **Researched and published blog posts:** Researched how to develop technical blog content and completed three posts on AWS Study Group. The posts share experiences from building CloudCost Insight, introduce Amazon EventBridge Scheduler, and propose a direction for expanding the system into an AI FinOps Agent using Amazon Bedrock AgentCore.

* **Prepared the project demo:** Prepared the demo script and checked the AWS environment, simulated cost data, Dashboard, Cognito authentication, SNS alerts, and monitoring components. The demo content was organized according to the actual operational flow of the system.

* **Completed the CloudCost Insight demo recording:** Recorded a demo video presenting the architecture and main workflows of CloudCost Insight, including cost data collection, anomaly analysis, alerts, error handling, monitoring, a Dashboard with user authentication, and the automated CI/CD process.

* **Collaborated with the team:** Maintained discussions about work plans before implementation and summarized results at the end of each day. Sharing progress helped team members stay informed about the implementation status of the Workshop, blog posts, and group demo video.