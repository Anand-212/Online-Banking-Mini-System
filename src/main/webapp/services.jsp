<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1200px; margin: 60px auto; padding: 0 32px;">
        <div style="text-align: center; margin-bottom: 48px;">
            <h1 style="font-size: 2.5rem; font-weight: 800;">Our Banking Services</h1>
            <p style="color: var(--text-muted); font-size: 1.1rem; margin-top: 8px;">Tailored accounts and financial solutions for individuals and enterprises.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 32px;">
            <div class="glass-panel">
                <i class="ri-bank-card-line" style="font-size: 2.5rem; color: var(--primary-color);"></i>
                <h2 style="font-size: 1.4rem; margin: 16px 0 8px;">Personal Savings Accounts</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">High-yield savings accounts earning up to 4.25% APY with no hidden maintenance fees.</p>
            </div>

            <div class="glass-panel">
                <i class="ri-briefcase-line" style="font-size: 2.5rem; color: var(--accent-color);"></i>
                <h2 style="font-size: 1.4rem; margin: 16px 0 8px;">Corporate Current Accounts</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Unlimited daily wire transfers, multi-user approval workflows, and automated payroll systems.</p>
            </div>

            <div class="glass-panel">
                <i class="ri-exchange-dollar-line" style="font-size: 2.5rem; color: var(--warning-color);"></i>
                <h2 style="font-size: 1.4rem; margin: 16px 0 8px;">Instant Wire Transfers</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Instant intra-bank and inter-bank fund transfers with live status notifications and PDF receipts.</p>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
