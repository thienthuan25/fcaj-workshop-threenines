---
title: "Week 4 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---

### Week 4 Objectives:

* Hold a team meeting to discuss, propose, and finalize the topic for the individual project.
* Brainstorm ideas and ensure the project addresses a practical problem on AWS.
* Research and select a suitable infrastructure architecture (prioritizing Serverless) for building the system.
* Complete the project proposal with a clear technology direction and development roadmap.
* Visualize the solution using detailed architecture diagrams.
* Prepare the source code environment and resolve issues related to the project template (Git submodule error).

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Team meeting and project ideation: <br>&emsp; + Held a team meeting to discuss, propose, and define the project direction. <br>&emsp; + Analyzed the problem of AWS cost management and alerting. <br>&emsp; + Studied AWS Cost Anomaly Detection to validate the project idea. <br>&emsp; + Finalized the individual project topic: **CloudCost Insight**. | 01/06/2026 | 01/06/2026 | - AWS Cost Management (Cost Anomaly Detection): <br> https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html |
| Tue | - System research and design: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Studied the advantages of a Serverless architecture (scalability and cost optimization). <br>&emsp; + Designed the data collection, analysis, and alerting workflow. <br>&emsp; + Finalized the implementation approach: Serverless combined with Infrastructure as Code (Terraform). <br>&emsp; + Summarized and shared the day's progress with the team. | 02/06/2026 | 02/06/2026 | - AWS Serverless Architecture: <br> https://aws.amazon.com/serverless/ <br> - AWS Well-Architected – Cost Optimization Pillar |
| Wed | - Writing the project proposal: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Wrote the project introduction, scope, and objectives. <br>&emsp; + Explained the rationale for choosing the topic based on real-world needs and learning objectives. <br>&emsp; + Defined custom budget thresholds and alerting logic. <br>&emsp; + Summarized and shared the day's progress with the team. | 03/06/2026 | 03/06/2026 | - Consolidated knowledge from research materials on system design and AWS cost management. |
| Thu | - Creating architecture diagrams: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Created the high-level architecture diagram. <br>&emsp; + Created the data flow diagram illustrating how Serverless components interact to detect abnormal costs. <br>&emsp; + Summarized and shared the day's progress with the team. | 04/06/2026 | 04/06/2026 |  |
| Fri | - Environment setup and template issue resolution: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Reviewed the initial project directory structure. <br>&emsp; + Resolved the Git submodule issue in the project template (broken configuration, incomplete repository setup, and inability to push the source code to GitHub Pages). <br>&emsp; + Reconfigured the project correctly to prepare for the development phase. <br>&emsp; + Summarized and shared the day's progress with the team. | 05/06/2026 | 05/06/2026 |  |

### Week 4 Achievements:

* **Team discussion and project topic selection:** The week began with a team meeting to discuss, propose, and define project ideas. After the discussion, I finalized my individual project topic, **CloudCost Insight**, a Serverless AWS cost monitoring and alerting system. The idea originated from a real-world problem: under the pay-as-you-go pricing model, AWS costs can quickly become difficult to control without proactive monitoring.

* **Reason for choosing the project:** During the research phase, I studied **AWS Cost Anomaly Detection**, AWS's built-in service for detecting abnormal cost increases. This confirmed that cost monitoring is a real-world requirement recognized by AWS itself. Based on this, I decided that instead of relying on an existing managed service, the project would **build the entire data collection, analysis, and alerting pipeline from scratch using a Serverless architecture and Terraform (Infrastructure as Code)**. This approach serves three main objectives: gaining a deep understanding of AWS infrastructure architecture, strengthening Infrastructure as Code skills, and implementing customizable anomaly detection logic based on user-defined budget thresholds.

* **Completed the project proposal:** Finished writing a comprehensive project proposal, clearly defining the objectives, scope, and technology stack. I also completed the high-level architecture diagram and the data flow diagram, providing a clear visualization of how the Serverless services interact to detect and alert on abnormal AWS costs.

* **Resolved development environment issues:** Successfully fixed the Git submodule issue in the project template, established a consistent development environment, and prepared the project for the implementation and infrastructure configuration phases in the following weeks.

* **Team collaboration:** Maintained effective collaboration throughout the week. Before starting work each day, I discussed the daily plan with team members, and at the end of each day, I summarized the completed work so that everyone could stay updated on the project's progress.