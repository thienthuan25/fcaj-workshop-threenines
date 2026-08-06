---
title: "Week 11 Worklog"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.11. </b> "
---

### Week 11 Objectives:

* Build a CI/CD pipeline for CloudCost Insight using GitHub Actions and HCP Terraform.
* Automatically check the Hugo Workshop, Python Lambda code, Terraform, and Dashboard JavaScript before merging.
* Automatically deploy Terraform infrastructure changes to AWS after they are merged into the `main` branch.
* Configure branch protection for `main` to ensure that changes must go through Pull Requests and CI checks.
* Redeploy, test the entire system, and fix any issues that arise.
* Complete the Workshop with step-by-step instructions based on the actual deployment, testing, and CI/CD process.
* Summarize the Workshop completion progress of team members at the end of the week.
* Maintain collaboration with the team: discuss plans before starting work and summarize results after each day.

### Implementation tasks during the week:

| Day | Tasks | Start date | Completion date | Reference materials |
| --- | --- | --- | --- | --- |
| 2 | - Study directly at the office and build the CI process: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Discuss project progress, the plan to complete the Workshop, and the need to automate source code checks. <br>&emsp; + Create the `.github/workflows/ci.yml` file using GitHub Actions. <br>&emsp; + Configure jobs to check the Hugo Workshop, Python Lambda syntax, Terraform formatting and configuration, and Dashboard JavaScript syntax. <br>&emsp; + Create a Pull Request to verify that the CI workflow works correctly. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 20/07/2026 | 20/07/2026 | - GitHub Actions Documentation: <br> https://docs.github.com/en/actions <br> - Terraform GitHub Actions: <br> https://developer.hashicorp.com/terraform/tutorials/automation/github-actions |
| 3 | - Complete automated testing and Terraform Plan CI: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Build unit tests for Lambda Collector, Analyzer, and API using pytest and mock AWS clients. <br>&emsp; + Configure linting, syntax checks, and unit test execution for Python Lambda code. <br>&emsp; + Configure Terraform fmt, validate, and Terraform plan on Pull Requests through HCP Terraform. <br>&emsp; + Fix linting, Terraform formatting, Terraform variable, and CI workflow errors that arise during testing. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 21/07/2026 | 21/07/2026 | - pytest Documentation: <br> https://docs.pytest.org/ <br> - Ruff Documentation: <br> https://docs.astral.sh/ruff/ <br> - HCP Terraform Documentation: <br> https://developer.hashicorp.com/terraform/cloud-docs |
| 4 | - Build CD, retest the system, and protect the `main` branch: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Create the `.github/workflows/terraform-apply.yml` workflow to automatically run Terraform Apply after Terraform changes are merged into `main`. <br>&emsp; + Configure the `production` GitHub Environment, the HCP Terraform API token, and the approval mechanism before deployment. <br>&emsp; + Enable branch protection for the `main` branch, requiring Pull Requests and mandatory CI checks before merging. <br>&emsp; + Redeploy and perform end-to-end testing of the entire system; check the Cognito, API Gateway, SQS, Lambda, SNS, CloudWatch, and Dashboard flow. <br>&emsp; + Fix issues that arise during deployment and testing. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 22/07/2026 | 22/07/2026 | - GitHub Environments: <br> https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments <br> - GitHub Branch Protection: <br> https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository |
| 5 | - Write and complete the step-by-step Workshop: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Agree with the team that each member will redeploy the project to build their own personal Workshop. <br>&emsp; + Write the steps for deploying the infrastructure, Lambda, Dashboard, Cognito, system testing, and CI/CD. <br>&emsp; + Add testing results such as SQS partial batch failure, S3 error handling, JWT authentication, and CORS. <br>&emsp; + Prepare illustrations, logs, and expected results for each step. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 23/07/2026 | 23/07/2026 | - FCAJ Workshop Template. |
| 6 | - Review the Workshop and summarize progress: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Complete the Workshop content and review the layout, images, code samples, and instruction steps. <br>&emsp; + Verify that the Hugo Workshop builds successfully and that the content is updated on GitHub Pages. <br>&emsp; + Summarize the Workshop completion progress of the remaining team members. <br>&emsp; + Share the results, review the documentation, and prepare for the acceptance phase. <br>&emsp; + Summarize and share the results with the team at the end of the day. | 24/07/2026 | 24/07/2026 | - FCAJ Workshop Template. <br> - Hugo Documentation: <br> https://gohugo.io/documentation/ |

### Week 11 Achievements:

* **Completed the CI process:** Built a GitHub Actions workflow in the `ci.yml` file to automatically check the source code when there is a Pull Request to the `main` branch. The CI process builds the Hugo Workshop, checks Python Lambda code, validates Terraform formatting and configuration, and checks the Dashboard JavaScript syntax.

* **Added unit tests and Terraform Plan CI:** Built unit tests for Lambda Collector, Analyzer, and API using pytest and mock AWS clients, making it possible to test processing logic without calling actual AWS resources. Terraform fmt, validate, and Terraform plan were also configured through HCP Terraform to detect infrastructure errors before merging.

* **Completed Terraform CD:** Created the `terraform-apply.yml` workflow to automatically deploy Terraform changes to AWS after changes are merged into the `main` branch. The workflow uses HCP Terraform to manage state and remote runs, while using the `production` GitHub Environment to manage tokens and control the deployment process.

* **Protected the main branch:** Configured branch protection for the `main` branch, requiring changes to go through Pull Requests and pass mandatory CI checks before merging. This mechanism helps prevent unverified changes and reduces the risk of deploying incorrect Terraform configurations to the production environment.

* **Redeployed, tested, and fixed issues:** Redeployed the CloudCost Insight system using Terraform and performed end-to-end testing. The data collection, cost analysis, SQS, DLQ, SNS, CloudWatch, Cognito, API Gateway, and Dashboard flows were tested to ensure correct operation. Issues that arose during testing were recorded and resolved.

* **Completed the Workshop documentation:** Wrote and reviewed the Workshop following step-by-step instructions, describing environment preparation, infrastructure deployment, Lambda development, Dashboard, Cognito, system testing, CI/CD, and resource cleanup. The content was supplemented with code samples, illustrations, logs, and expected results so that readers can follow along.

* **Summarized team progress:** At the end of the week, summarized the Workshop completion progress of the remaining team members. Team members discussed, reviewed, and shared deployment experience to improve the quality of the documentation.

* **Collaborated with the team:** Maintained effective teamwork throughout the week. Before starting work each day, I discussed the plan with team members, and at the end of each day, I summarized the completed work so that the team could track the overall progress.