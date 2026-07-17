---
title: "Week 10 Worklog"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* Develop the web frontend for the dashboard (`index.html`, `style.css`, `script.js`), using Chart.js to visualize AWS cost data.
* Host the frontend on AWS (Amazon S3 Static Website Hosting + CloudFront) with a publicly accessible HTTPS URL.
* Perform end-to-end testing of the entire web dashboard workflow (from the browser to the API and cost data).
* Finalize and enhance the dashboard by refining the charts, adding light/dark mode, and implementing English/Vietnamese language switching.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Develop the web frontend (UI & application logic): <br>&emsp; + Create `index.html` (page structure) and `style.css` (user interface). <br>&emsp; + Develop `script.js` to call the API endpoint, process JSON responses, and render charts using Chart.js. <br>&emsp; + Implement visualizations including: cost trend (with threshold line and anomaly markers), service cost distribution, top-cost services, and KPI cards. | 13/07/2026 | 13/07/2026 | - Chart.js Documentation: <br> https://www.chartjs.org/docs/latest/ <br> - MDN Fetch API: <br> https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API |
| Tue | - Host the frontend on AWS (Amazon S3 + CloudFront): <br>&emsp; + Create an Amazon S3 bucket for Static Website Hosting and upload the three frontend files using Terraform. <br>&emsp; + Configure CloudFront (HTTPS) with Origin Access Control (OAC) to secure the bucket and block direct public access to Amazon S3. <br>&emsp; + Obtain the public CloudFront URL for accessing the dashboard. | 14/07/2026 | 14/07/2026 | - Amazon CloudFront + Amazon S3: <br> https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.SimpleDistribution.html <br> - Terraform aws_cloudfront_distribution: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution |
| Wed | - Perform end-to-end testing of the web dashboard: <br>&emsp; + Access the dashboard through the CloudFront URL in a web browser. <br>&emsp; + Verify the complete workflow: Browser → CloudFront/Amazon S3 (load the web interface) and Browser → API Gateway → Lambda API → Amazon S3 (retrieve cost data). <br>&emsp; + Verify that all charts correctly display cost data and anomaly status. | 15/07/2026 | 15/07/2026 | - Web application testing and browser Developer Tools. |
| Thu | - Refine the charts and add light/dark mode: <br>&emsp; + Resize the donut chart (service cost distribution) for a more balanced layout. <br>&emsp; + Add tooltips that display cost values with the `$` currency symbol. <br>&emsp; + Implement a light/dark theme switch using CSS custom properties (variables). | 16/07/2026 | 16/07/2026 | - MDN CSS Custom Properties (variables): <br> https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties |
| Fri | - Implement bilingual language switching (EN/VI): <br>&emsp; + Build an English/Vietnamese translation dictionary for labels, titles, and chart elements. <br>&emsp; + Add a language switch button to update the user interface and re-render the charts according to the selected language. <br>&emsp; + Re-test the entire dashboard in both English and Vietnamese. | 17/07/2026 | 17/07/2026 | - JavaScript concepts (DOM manipulation and event handling). |

### Week 10 Achievements:

* **Completed the web frontend for the dashboard:** Successfully developed the dashboard frontend using three separate files (`index.html`, `style.css`, and `script.js`) following the principle of separation of concerns. The dashboard uses Chart.js to visualize AWS cost data through multiple charts, including daily cost trends (with a threshold line and anomaly markers), service cost distribution, top-cost services, and KPI metrics.

* **Successfully hosted the frontend on AWS:** Successfully deployed the web dashboard to Amazon S3 Static Website Hosting integrated with CloudFront, providing a publicly accessible HTTPS URL. Origin Access Control (OAC) was implemented so that only CloudFront can access the S3 bucket, preventing direct public access. As a result, CloudCost Insight became a complete product that can be accessed through a public web browser.

* **Successfully performed end-to-end testing of the web dashboard:** Successfully verified the complete dashboard workflow: the browser loads the user interface from CloudFront/Amazon S3 while simultaneously retrieving cost data through API Gateway → Lambda API → Amazon S3 to render the charts. The entire workflow operated smoothly, with all charts displaying accurate cost information and anomaly status.

* **Refined the user interface and added light/dark mode:** Improved the dashboard by resizing the donut chart for better visual balance and adding tooltips that display cost values with the `$` currency symbol. A light/dark mode toggle was also implemented using CSS custom properties, allowing users to choose their preferred theme and improving the overall user experience.

* **Implemented bilingual support (EN/VI):** Successfully developed an English/Vietnamese language-switching feature covering the entire dashboard, including labels, titles, and chart elements. This feature not only improves the user experience but also satisfies the bilingual requirements of the FCAJ program. After implementation, the dashboard was thoroughly tested in both languages, completing CloudCost Insight as a professional, user-friendly, and fully automated end-to-end product.