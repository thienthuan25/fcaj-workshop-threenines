---
title: "Week 4 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---

### Week 4 Objectives:

* Brainstorm and finalize the topic for the project, ensuring it addresses a practical problem on AWS.
* Research and select an appropriate infrastructure architecture (prioritizing Serverless) for building the system.
* Complete the project Proposal with a clear technology direction and development roadmap.
* Visualize the solution using detailed Architecture Diagrams.
* Prepare the source code environment and resolve project template issues (Git submodule errors).

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Brainstorm project ideas: <br>&emsp; + Analyze the problem of AWS cost management and alerting. <br>&emsp; + Study AWS Cost Anomaly Detection to shape the project idea. <br>&emsp; + Finalize the project topic: **CloudCost Insight**. | 01/06/2026 | 01/06/2026 | - AWS Cost Management (Cost Anomaly Detection): <br> https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html |
| Tue | - Research and design the system: <br>&emsp; + Explore the advantages of Serverless architecture (scalability and operational cost optimization). <br>&emsp; + Design the data collection, analysis, and alerting workflow. <br>&emsp; + Finalize the implementation technology: Serverless combined with Infrastructure as Code (Terraform). | 02/06/2026 | 02/06/2026 | - AWS Serverless Architecture: <br> https://aws.amazon.com/serverless/ <br> - AWS Well-Architected – Cost Optimization Pillar |
| Wed | - Write the project Proposal: <br>&emsp; + Prepare the project introduction, scope, and objectives. <br>&emsp; + Justify the project selection based on real-world needs and learning objectives. <br>&emsp; + Define custom budget thresholds and configurable alerting logic. | 03/06/2026 | 03/06/2026 | - Knowledge synthesized from AWS system design and cost management research materials. |
| Thu | - Create architecture diagrams: <br>&emsp; + Draw the High-level Architecture Diagram. <br>&emsp; + Draw the Data Flow Diagram illustrating how Serverless components interact to detect abnormal costs. | 04/06/2026 | 04/06/2026 |  |
| Fri | - Set up the development environment and fix template issues: <br>&emsp; + Review and verify the initial project directory structure. <br>&emsp; + Resolve Git submodule issues in the project template (corrupted submodule, incomplete repository configuration, and inability to push the source code to GitHub Pages). <br>&emsp; + Reconfigure the project correctly to prepare for the development (coding) phase. | 05/06/2026 | 05/06/2026 |  |

### Week 4 Achievements:

* **Finalized the project idea and established the project direction:** Successfully completed the ideation process and finalized **CloudCost Insight**—an AWS cost monitoring and alerting system. The project originated from a practical challenge: under the pay-as-you-go pricing model, AWS costs can easily become difficult to control without proactive monitoring.

* **Reason for selecting the project:** During the research phase, I studied **AWS Cost Anomaly Detection**, AWS's built-in service for detecting abnormal cost spikes. This confirmed that cost monitoring is a real-world problem officially recognized by AWS. Based on this insight, I decided to develop the core functionality independently. Instead of relying on the managed service, the project will **build the entire data collection, analysis, and alerting pipeline using a Serverless architecture combined with Terraform (Infrastructure as Code)**. This approach serves three primary objectives: (1) gain a comprehensive understanding of AWS infrastructure architecture; (2) strengthen Infrastructure as Code skills; and (3) enable fully customizable anomaly detection logic based on user-defined budget thresholds, which is less flexible with the managed solution.

* **Completed the project proposal documentation:** Finished writing a comprehensive project Proposal, clearly defining the project objectives, scope, and technology direction. Additionally, completed the architecture diagrams (High-level Architecture and Data Flow Diagram), providing a clear visualization of how the Serverless services interact to detect and alert abnormal AWS costs.

* **Resolved development environment issues:** Successfully fixed the Git submodule issues in the project template (caused by a corrupted submodule and missing configuration files), established a stable and synchronized development environment, and prepared the project for the implementation and infrastructure configuration phases in the following weeks.