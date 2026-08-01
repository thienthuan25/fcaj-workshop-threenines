const API_ENDPOINT = "REPLACE_MY_API_ENDPOINT";

const COGNITO_DOMAIN = "REPLACE_MY_COGNITO_DOMAIN";
const COGNITO_CLIENT_ID = "REPLACE_MY_COGNITO_CLIENT_ID";
const REDIRECT_URI = window.location.origin + "/";

const loginButton = document.getElementById("login-button");
const logoutButton = document.getElementById("logout-button");

function base64Url(bytes) {
    let value = "";
    bytes.forEach((byte) => { value += String.fromCharCode(byte); });
    return btoa(value).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function randomValue(size = 32) {
    const bytes = new Uint8Array(size);
    crypto.getRandomValues(bytes);
    return base64Url(bytes);
}

async function createCodeChallenge(verifier) {
    const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(verifier));
    return base64Url(new Uint8Array(digest));
}

async function signIn() {
    const verifier = randomValue(64);
    const state = randomValue(32);
    const challenge = await createCodeChallenge(verifier);
    sessionStorage.setItem("pkce_verifier", verifier);
    sessionStorage.setItem("oauth_state", state);

    const params = new URLSearchParams({
        response_type: "code",
        client_id: COGNITO_CLIENT_ID,
        redirect_uri: REDIRECT_URI,
        scope: "openid email profile",
        state,
        code_challenge_method: "S256",
        code_challenge: challenge,
    });
    window.location.assign(COGNITO_DOMAIN + "/oauth2/authorize?" + params.toString());
}

async function exchangeAuthorizationCode(code) {
    const verifier = sessionStorage.getItem("pkce_verifier");
    if (!verifier) throw new Error("Login session expired. Please sign in again.");

    const body = new URLSearchParams({
        grant_type: "authorization_code",
        client_id: COGNITO_CLIENT_ID,
        code,
        redirect_uri: REDIRECT_URI,
        code_verifier: verifier,
    });
    const response = await fetch(COGNITO_DOMAIN + "/oauth2/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body,
    });
    const tokens = await response.json();
    if (!response.ok) throw new Error(tokens.error_description || tokens.error || "Token exchange failed");

    sessionStorage.setItem("id_token", tokens.id_token);
    sessionStorage.removeItem("pkce_verifier");
    sessionStorage.removeItem("oauth_state");
    return tokens.id_token;
}

async function getAuthenticatedToken() {
    const url = new URL(window.location.href);
    const code = url.searchParams.get("code");
    if (!code) return sessionStorage.getItem("id_token");

    const expectedState = sessionStorage.getItem("oauth_state");
    if (!expectedState || url.searchParams.get("state") !== expectedState) {
        throw new Error("Invalid login state. Please sign in again.");
    }

    const token = await exchangeAuthorizationCode(code);
    window.history.replaceState({}, document.title, REDIRECT_URI);
    return token;
}

function showAuthenticationState(isAuthenticated) {
    loginButton.style.display = isAuthenticated ? "none" : "inline-block";
    logoutButton.style.display = isAuthenticated ? "inline-block" : "none";
}

function signOut() {
    sessionStorage.removeItem("id_token");
    sessionStorage.removeItem("pkce_verifier");
    sessionStorage.removeItem("oauth_state");
    const params = new URLSearchParams({ client_id: COGNITO_CLIENT_ID, logout_uri: REDIRECT_URI });
    window.location.assign(COGNITO_DOMAIN + "/logout?" + params.toString());
}

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
        signIn: "Sign in",
        signOut: "Sign out",
        authenticationRequired: "Please sign in to view cost data.",
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
        signIn: "Đăng nhập",
        signOut: "Đăng xuất",
        authenticationRequired: "Vui lòng đăng nhập để xem dữ liệu chi phí.",
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
    loginButton.textContent = t.signIn;
    logoutButton.textContent = t.signOut;

    const status = document.getElementById("status");
    if (status.dataset.translationKey === "authenticationRequired") {
        status.textContent = t.authenticationRequired;
    }
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

async function loadDashboard(idToken) {
    try {
        const res = await fetch(API_ENDPOINT, { headers: { Authorization: "Bearer " + idToken } });
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

// Khởi tạo dashboard sau khi Cognito trả về JWT hợp lệ.
async function initializeDashboard() {
    applyStaticText();
    try {
        const token = await getAuthenticatedToken();
        showAuthenticationState(Boolean(token));
        if (!token) {
            const status = document.getElementById("status");
            status.dataset.translationKey = "authenticationRequired";
            status.textContent = translations[currentLang].authenticationRequired;
            return;
        }
        await loadDashboard(token);
    } catch (err) {
        sessionStorage.removeItem("id_token");
        showAuthenticationState(false);
        document.getElementById("status").textContent = "Authentication error: " + err.message;
    }
}

loginButton.addEventListener("click", signIn);
logoutButton.addEventListener("click", signOut);
initializeDashboard();
