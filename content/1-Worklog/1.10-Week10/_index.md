---
title: "Week 10 Worklog"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* Develop the web frontend for the dashboard (`index.html`, `style.css`, `script.js`), using Chart.js to visualize cost data.
* Host the frontend on AWS (S3 Web Hosting + CloudFront) with a publicly accessible HTTPS URL.
* Perform end-to-end testing of the entire web dashboard workflow (from the browser to the API and data retrieval).
* Finalize and enhance the dashboard by refining the charts, adding light/dark mode, and supporting English/Vietnamese language switching.
* Continue effective collaboration with the team by discussing the daily plan before work and summarizing progress at the end of each day.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | References |
| --- | --- | --- | --- | --- |
| Mon | - Develop the web frontend (UI and logic): <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Create `index.html` (page structure) and `style.css` (user interface). <br>&emsp; + Develop `script.js` to call the API endpoint, process JSON data, and render charts using Chart.js. <br>&emsp; + Implement charts for cost trends (including a threshold line and anomaly markers), service cost distribution, top-cost services, and KPI metrics. <br>&emsp; + Summarize and share the day's progress with the team. | 13/07/2026 | 13/07/2026 | - Chart.js Documentation: <br> https://www.chartjs.org/docs/latest/ <br> - MDN Fetch API: <br> https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API |
| Tue | - Host the frontend on AWS (S3 + CloudFront): <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Create an S3 bucket for Web Hosting and upload the three frontend files using Terraform. <br>&emsp; + Configure CloudFront (HTTPS) with Origin Access Control (OAC) to secure the site and block direct public access to the S3 bucket. <br>&emsp; + Obtain the public CloudFront URL for accessing the dashboard. <br>&emsp; + Summarize and share the day's progress with the team. | 14/07/2026 | 14/07/2026 | - Amazon CloudFront + S3: <br> https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.SimpleDistribution.html <br> - Terraform aws_cloudfront_distribution: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution |
| Wed | - Perform end-to-end testing of the web dashboard: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Access the dashboard through the CloudFront URL in a web browser. <br>&emsp; + Verify the complete workflow: Browser → CloudFront/S3 (load the frontend) and Browser → API Gateway → Lambda API → S3 (retrieve cost data). <br>&emsp; + Confirm that all charts correctly display cost data and anomaly status. <br>&emsp; + Summarize and share the day's progress with the team. | 15/07/2026 | 15/07/2026 | - Testing web applications & browser Developer Tools. |
| Thu | - Refine charts and add light/dark mode: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Resize the donut chart (service distribution) for a more balanced layout. <br>&emsp; + Add tooltips displaying monetary values with the `$` symbol. <br>&emsp; + Implement a light/dark mode toggle using CSS custom properties (variables). <br>&emsp; + Summarize and share the day's progress with the team. | 16/07/2026 | 16/07/2026 | - MDN CSS Custom Properties (variables): <br> https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties |
| Fri | - Add bilingual language support (EN/VI): <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Create an English/Vietnamese translation dictionary for labels, titles, and chart text. <br>&emsp; + Add a language switch button that updates the interface and redraws the charts based on the selected language. <br>&emsp; + Retest the entire dashboard in both languages. <br>&emsp; + Summarize and share the day's progress with the team. | 17/07/2026 | 17/07/2026 | - JavaScript knowledge (DOM manipulation, event handling). |

### Week 10 Achievements:

* **Completed the web frontend for the dashboard:** Successfully developed the dashboard frontend using three separate files (`index.html`, `style.css`, and `script.js`) following the principle of separation of concerns. The dashboard uses the Chart.js library to visualize AWS cost data through a complete set of charts, including daily cost trends (with threshold lines and anomaly markers), service cost distribution, top cost-consuming services, and KPI metrics.

* **Successfully hosted the frontend on AWS:** Deployed the web dashboard to Amazon S3 (Web Hosting) with CloudFront, making it accessible through a public HTTPS URL. Applied Origin Access Control (OAC) so that only CloudFront can access the S3 bucket, effectively blocking direct public access. As a result, CloudCost Insight became a complete product that users can access directly through a web browser using a public URL.

* **Successfully performed end-to-end testing of the web dashboard:** Verified the complete dashboard workflow, where the browser loads the frontend from CloudFront/S3 while simultaneously calling the API Gateway, which invokes the Lambda API to retrieve cost data from S3 for visualization. The entire workflow operated smoothly, with all charts displaying accurate cost information and anomaly statuses.

* **Enhanced the user interface with light/dark mode:** Refined the dashboard by resizing the donut chart for a more balanced layout and adding tooltips that display monetary values with the `$` symbol. Implemented a light/dark mode toggle using CSS custom properties, allowing users to choose their preferred theme and improving the overall user experience.

* **Added bilingual support (English/Vietnamese):** Implemented a bilingual language-switching mechanism for the entire dashboard, including labels, titles, and chart text. This feature not only improves the user experience but also aligns with the bilingual requirements of the FCAJ program. After implementation, the dashboard was successfully tested in both English and Vietnamese, completing CloudCost Insight as a professional, user-friendly, and fully automated end-to-end product.

* **Team collaboration:** Maintained an effective teamwork routine throughout the week. Before starting work each day, I discussed the daily plan with my teammates, and at the end of each day, I summarized the completed work so that everyone could stay updated on the project's progress.