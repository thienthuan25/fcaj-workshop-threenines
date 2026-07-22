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

// Ngôn ngữ hiện tại
let currentLang = "en";
let latestData = null;
let charts = {};

// Màu theo trạng thái
const statusColor = (s) =>
    s === "CRITICAL" ? "#e53e3e" : s === "WARNING" ? "#dd6b20" : "#38a169";

// Áp dụng ngôn ngữ vào các nhãn tĩnh (không phải biểu đồ)
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

// Vẽ lại các biểu đồ theo ngôn ngữ
function renderCharts(data) {
    const t = translations[currentLang];

    Object.values(charts).forEach(c => c && c.destroy());

    const labels = data.daily_costs.map(d => d.date);
    const totals = data.daily_costs.map(d => d.total);
    const colors = data.daily_costs.map(d => statusColor(d.status));
    const threshold = Number(data.threshold);

    // Biểu đồ xu hướng
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

    // Biểu đồ donut
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

    // Biểu đồ top dịch vụ
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

// Nút chuyển ngôn ngữ
const langToggle = document.getElementById("lang-toggle");
langToggle.addEventListener("click", () => {
    currentLang = currentLang === "vi" ? "en" : "vi";
    langToggle.textContent = currentLang === "vi" ? "VI" : "EN";
    applyStaticText();
    if (latestData) renderCharts(latestData); // vẽ lại biểu đồ với nhãn ngôn ngữ mới
});

// Nút dark mode
const themeToggle = document.getElementById("theme-toggle");
themeToggle.addEventListener("click", () => {
    document.body.classList.toggle("dark-mode");
    themeToggle.textContent = document.body.classList.contains("dark-mode") ? "☀️" : "🌙";
    Chart.defaults.color = document.body.classList.contains("dark-mode") ? "#ffffff" : "#666";
    Object.values(charts).forEach(c => c && c.update());
});

// Khởi tạo nhãn ngôn ngữ ban đầu
applyStaticText();
loadDashboard();
