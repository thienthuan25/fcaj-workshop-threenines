---
title : "Frontend"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.6.2 </b> "
---

We will create the Web interface in the `lambda/web` directory:

1. The `index.html` file contains the page structure:

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CloudCost Insight — Dashboard</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <link rel="stylesheet" href="style.css" />
</head>

<body>
    <header>
        <div>
            <h1>☁️ CloudCost Insight</h1>
            <p id="header-subtitle">AWS Cost Monitoring &amp; Alert Dashboard — Near Real-Time</p>
        </div>
        <div class="header-controls">
            <button id="lang-toggle">🇻🇳 VI</button>
            <button id="theme-toggle">🌙</button>
        </div>
    </header>

    <div id="status" class="status">Loading cost data...</div>

    <div id="content" style="display:none;">
        <!-- KPI -->
        <div class="kpi-row">
            <div class="kpi-card">
                <div class="label" id="label-total">Total Cost (Period)</div>
                <div class="value" id="kpi-total">$0.00</div>
            </div>
            <div class="kpi-card">
                <div class="label" id="label-threshold">Alert Threshold per Day</div>
                <div class="value" id="kpi-threshold">$0.00</div>
            </div>
            <div class="kpi-card">
                <div class="label" id="label-days">Monitored Days</div>
                <div class="value" id="kpi-days">0</div>
            </div>
            <div class="kpi-card">
                <div class="label" id="label-anomalies">Anomalous Days</div>
                <div class="value danger" id="kpi-anomalies">0</div>
            </div>
        </div>

        <!-- Charts -->
        <div class="chart-grid">
            <div class="chart-card full-width">
                <h3 id="title-trend">📈 Daily Cost Trend (Threshold Line + Anomaly Markers)</h3>
                <canvas id="trendChart" height="90"></canvas>
            </div>
            <div class="chart-card">
                <h3 id="title-service">🍩 Cost Distribution by Service</h3>
                <div class="chart-small">
                    <canvas id="serviceChart"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h3 id="title-top">📊 Top Cost Services</h3>
                <canvas id="topChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Separate JavaScript file -->
    <script src="script.js"></script>
</body>

</html>
```

2. The `style.css` file contains all the styling definitions for the user interface:

```css
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

:root {
    --bg-color: #f0f2f5;
    --text-color: #1a202c;
    --card-bg: #fff;
    --label-color: #718096;
    --heading-color: #2d3748;
    --shadow-color: rgba(0, 0, 0, 0.08);
    --header-bg: linear-gradient(135deg, #232f3e, #ff9900);
}

body.dark-mode {
    --bg-color: #1a202c;
    --text-color: #ffffff;
    --card-bg: #2d3748;
    --label-color: #a0aec0;
    --heading-color: #ffffff;
    --shadow-color: rgba(0, 0, 0, 0.3);
}

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: var(--bg-color);
    color: var(--text-color);
    padding: 24px;
    transition: background 0.3s, color 0.3s;
}

header {
    background: var(--header-bg);
    color: #fff;
    padding: 20px 28px;
    border-radius: 12px;
    margin-bottom: 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-controls {
    display: flex;
    gap: 10px;
    align-items: center;
}

#theme-toggle,
#lang-toggle {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    padding: 8px 16px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
    transition: background 0.2s;
}

#theme-toggle:hover,
#lang-toggle:hover {
    background: rgba(255, 255, 255, 0.3);
}

header h1 {
    font-size: 24px;
}

header p {
    opacity: 0.9;
    font-size: 14px;
    margin-top: 4px;
}

.kpi-row {
    display: flex;
    gap: 16px;
    margin-bottom: 24px;
    flex-wrap: wrap;
}

.kpi-card {
    background: var(--card-bg);
    border-radius: 12px;
    padding: 20px 24px;
    flex: 1;
    min-width: 200px;
    box-shadow: 0 1px 4px var(--shadow-color);
    transition: background 0.3s, box-shadow 0.3s;
}

.kpi-card .label {
    font-size: 13px;
    color: var(--label-color);
}

.kpi-card .value {
    font-size: 28px;
    font-weight: 700;
    margin-top: 6px;
}

.kpi-card .value.danger {
    color: #e53e3e;
}

.kpi-card .value.ok {
    color: #38a169;
}

.chart-grid {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
}

.chart-card {
    background: var(--card-bg);
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 1px 4px var(--shadow-color);
    transition: background 0.3s, box-shadow 0.3s;
}

.chart-card h3 {
    font-size: 16px;
    margin-bottom: 16px;
    color: var(--heading-color);
}

.full-width {
    grid-column: 1 / -1;
}

.chart-small {
    max-width: 850px;
    margin: 0 auto;
}

.status {
    text-align: center;
    padding: 40px;
    color: #718096;
}

@media (max-width: 900px) {
    .chart-grid {
        grid-template-columns: 1fr;
    }
}
```

3. The `script.js` file contains the logic for calling the API and rendering charts using **Chart.js**:

```javascript
const API_ENDPOINT = "REPLACE_MY_API_ENDPOINT";

// EN/VI
const translations = {
    en: {
        subtitle: "AWS Cost Monitoring & Alert Dashboard — Near Real-Time",
        labelTotal: "Total Cost (Period)",
        labelThreshold: "Alert Threshold/Day",
        labelDays: "Monitored Days",
        labelAnomalies: "Anomalous Days",
        titleTrend: "📈 Daily Cost Trend (Threshold Line + Anomaly Markers)",
        titleService: "🍩 Cost Share by Service",
        titleTop: "📊 Top Cost Services",
        loading: "Loading cost data...",
        dailyCost: "Daily Cost",
        budgetThreshold: "Budget Threshold",
        cost: "Cost ($)",
        error: "Error loading data: ",
    },
    vi: {
        subtitle: "Bảng giám sát & cảnh báo chi phí AWS — Thời gian gần thực",
        labelTotal: "Tổng chi phí (kỳ)",
        labelThreshold: "Ngưỡng cảnh báo/ngày",
        labelDays: "Số ngày theo dõi",
        labelAnomalies: "Số ngày bất thường",
        titleTrend: "📈 Xu hướng chi phí theo ngày (đường ngưỡng + đánh dấu bất thường)",
        titleService: "🍩 Tỷ trọng theo dịch vụ",
        titleTop: "📊 Top dịch vụ tốn chi phí",
        loading: "Đang tải dữ liệu chi phí...",
        dailyCost: "Chi phí/ngày",
        budgetThreshold: "Ngưỡng ngân sách",
        cost: "Chi phí ($)",
        error: "Lỗi tải dữ liệu: ",
    },  
};

// Current language
let currentLang = "en";
let latestData = null;
let charts = {};

// Color based on status
const statusColor = (s) =>
    s === "CRITICAL" ? "#e53e3e" : s === "WARNING" ? "#dd6b20" : "#38a169";

// Apply translations to static labels (excluding charts)
function applyStaticText() {
    const t = translations[currentLang];
    document.getElementById("header-subtitle").textContent = t.subtitle;
    document.getElementById("label-total").textContent = t.labelTotal;
    document.getElementById("label-threshold").textContent = t.labelThreshold;
    document.getElementById("label-days").textContent = t.labelDays;
    document.getElementById("label-anomalies").textContent = t.labelAnomalies;
    document.getElementById("title-trend").textContent = t.titleTrend;
    document.getElementById("title-service").textContent = t.titleService;
    document.getElementById("title-top").textContent = t.titleTop;
}

// Re-render charts according to the selected language
function renderCharts(data) {
    const t = translations[currentLang];

    Object.values(charts).forEach(c => c && c.destroy());

    const labels = data.daily_costs.map(d => d.date);
    const totals = data.daily_costs.map(d => d.total);
    const colors = data.daily_costs.map(d => statusColor(d.status));
    const threshold = Number(data.threshold);

    // Trend chart
    charts.trend = new Chart(document.getElementById("trendChart"), {
        type: "line",
        data: {
            labels,
            datasets: [
                {
                    label: t.dailyCost,
                    data: totals,
                    borderColor: "#3182ce",
                    backgroundColor: "rgba(49,130,206,0.1)",
                    fill: true,
                    tension: 0.3,
                    pointBackgroundColor: colors,
                    pointRadius: 5,
                },
                {
                    label: t.budgetThreshold,
                    data: labels.map(() => threshold),
                    borderColor: "#e53e3e",
                    borderDash: [6, 4],
                    pointRadius: 0,
                    fill: false,
                },
            ],
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: "top" },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const label = context.dataset.label || "";
                            let value = context.parsed.y;
                            if (value === null || value === undefined) value = context.parsed;
                            return label + ": $" + Number(value).toFixed(2);
                        }
                    }
                }
            }
        },
    });

    // Donut chart
    charts.service = new Chart(document.getElementById("serviceChart"), {
        type: "doughnut",
        data: {
            labels: data.top_services.map(s => s.service),
            datasets: [{
                data: data.top_services.map(s => s.cost),
                backgroundColor: ["#ff9900", "#3182ce", "#38a169", "#e53e3e", "#805ad5", "#dd6b20", "#00a4a6", "#d53f8c", "#718096", "#2b6cb0"],
            }],
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: "bottom" },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            return (context.label || "") + ": $" + context.parsed.toFixed(2);
                        }
                    }
                }
            }
        },
    });

    // Top services chart
    charts.top = new Chart(document.getElementById("topChart"), {
        type: "bar",
        data: {
            labels: data.top_services.map(s => s.service),
            datasets: [{
                label: t.cost,
                data: data.top_services.map(s => s.cost),
                backgroundColor: "#ff9900",
            }],
        },
        options: {
            indexAxis: "y",
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const label = context.dataset.label || "";
                            let value = context.parsed.x;
                            if (value === null || value === undefined) value = context.parsed;
                            return label + ": $" + Number(value).toFixed(2);
                        }
                    }
                }
            }
        },
    });
}

async function loadDashboard() {
    try {
        const res = await fetch(API_ENDPOINT);
        if (!res.ok) throw new Error("HTTP " + res.status);
        const data = await res.json();
        latestData = data;

        document.getElementById("status").style.display = "none";
        document.getElementById("content").style.display = "block";

        // KPI
        document.getElementById("kpi-total").textContent = "$" + data.grand_total.toFixed(2);
        document.getElementById("kpi-threshold").textContent = "$" + Number(data.threshold).toFixed(2);
        document.getElementById("kpi-days").textContent = data.days_count;
        const anomalies = data.daily_costs.filter(d => d.status !== "NORMAL").length;
        document.getElementById("kpi-anomalies").textContent = anomalies;

        applyStaticText();
        renderCharts(data);

    } catch (err) {
        document.getElementById("status").textContent =
            "❌ " + translations[currentLang].error + err.message;
    }
}

// Language toggle button
const langToggle = document.getElementById("lang-toggle");
langToggle.addEventListener("click", () => {
    currentLang = currentLang === "vi" ? "en" : "vi";
    langToggle.textContent = currentLang === "vi" ? "VI" : "EN";
    applyStaticText();
    if (latestData) renderCharts(latestData); // Re-render charts with the new language labels
});

// Dark mode toggle button
const themeToggle = document.getElementById("theme-toggle");
themeToggle.addEventListener("click", () => {
    document.body.classList.toggle("dark-mode");
    themeToggle.textContent = document.body.classList.contains("dark-mode") ? "☀️" : "🌙";
    Chart.defaults.color = document.body.classList.contains("dark-mode") ? "#ffffff" : "#666";
    Object.values(charts).forEach(c => c && c.update());
});

// Initialize default language labels
applyStaticText();
loadDashboard();
```

The interface includes multiple charts, such as a daily cost trend chart with a threshold line and anomaly markers, a service cost distribution chart, and a set of overall KPI indicators. It also supports switching between light and dark themes, as well as toggling between English and Vietnamese.

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_1.png)

#### Host the Web Application on S3 and CloudFront

Next, we will create the `terraform/web_hosting.tf` file to host the web interface on **S3** and distribute it through **CloudFront** over HTTPS. For security, the web bucket is **not** publicly accessible. Instead, only **CloudFront** is allowed to read its contents using **Origin Access Control (OAC)**.

```hcl
# Host the website on S3 + CloudFront

# S3 bucket for static website files
resource "aws_s3_bucket" "web" {
  bucket = "${var.project_name}-web-${data.aws_caller_identity.current.account_id}"
}

# Static website hosting configuration
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

# CloudFront + Origin Access Control
resource "aws_cloudfront_origin_access_control" "web" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Block direct public access to the bucket
resource "aws_s3_bucket_public_access_block" "web" {
  bucket                  = aws_s3_bucket.web.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  default_root_object = "index.html"
  comment             = "CloudCost Insight Web Dashboard"

  origin {
    domain_name              = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id                = "s3-web"
    origin_access_control_id = aws_cloudfront_origin_access_control.web.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-web"
    viewer_protocol_policy = "redirect-to-https" # Automatically redirect insecure HTTP requests to HTTPS
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    # No geographic restrictions
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Default free SSL certificate provided by CloudFront
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100" # Low-cost pricing tier
}

# Bucket policy: Allow CloudFront to read objects from S3
data "aws_iam_policy_document" "web_bucket_policy" {
  statement {
    sid       = "AllowCloudFrontRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.web.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.web_bucket_policy.json
}

# Upload index.html to S3
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.web.id
  key          = "index.html"
  source       = "${path.module}/web/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/web/index.html")
}

# Upload style.css to S3
resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.web.id
  key          = "style.css"
  source       = "${path.module}/web/style.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/web/style.css")
}

# Upload script.js to S3
resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.web.id
  key          = "script.js"

  # Automatically inject the API Gateway URL into the JavaScript file
  content = replace(
    file("${path.module}/web/script.js"),
    "REPLACE_MY_API_ENDPOINT",
    "${trim(aws_apigatewayv2_stage.default.invoke_url, "/")}/costs"
  )

  content_type = "application/javascript"
  etag = filemd5("${path.module}/web/script.js")
}
```

Using **Origin Access Control (OAC)** is an important security measure. The web bucket is never exposed directly to the public. All access must go through CloudFront over HTTPS, preventing the bucket contents from being directly exposed to the Internet.

#### Deploying and Accessing the Dashboard

1. In the Terminal, deploy the Frontend:

```bash
terraform apply
```

2. Retrieve the Dashboard URL:

```bash
terraform output web_dashboard_url
```

![Script](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_2.png)

3. Open the URL displayed in the Terminal to access the Dashboard:

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_3.png)

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_4.png)

The dashboard displays the **total cost**, **alert threshold**, **number of monitored days**, **number of anomalous days**, and three visualization charts:

**Chart 1: Daily Cost Trend (Trend Chart):**

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_5en.png)

- The X-axis (horizontal) represents the monitored days.
- The Y-axis (vertical) represents the daily cost ($).
- The blue line represents the actual daily cost trend.
- The red dashed line is a fixed line representing the budget threshold. If the cost rises above this line, it exceeds the configured threshold.
- The blue shaded area beneath the line highlights the cost trend.

**Chart 2: Cost Share by Service (Service Chart):**

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_6en.png)

- Each slice of the pie chart represents the cost of an AWS service. The larger the slice, the higher the cost of that service.
- The name of each service is displayed when you hover over or select its slice.
- Each service is represented by a distinct color.
- A legend below the chart shows the corresponding service names and colors.

**Chart 3: Top Cost Services (Bar Chart):**

![Dashboard](/fcaj-workshop-threenines/images/5-Workshop/5.6-Dashboard/5.6.2-Frontend/frontend_7en.png)

- The chart displays the top 5 services with the highest costs.
- The X-axis (horizontal) represents the service cost.
- The Y-axis (vertical) represents the corresponding service names.

#### Next Content

- [Testing](5-Workshop/5.7-Testing/)