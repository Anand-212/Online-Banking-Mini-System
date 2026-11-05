<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EasyBank - Next Gen Banking Experience</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <!-- Hero Splash Banner -->
    <section style="padding: 100px 32px; text-align: center; max-width: 1000px; margin: 0 auto;">
        <div class="glass-panel hero-card">
            <span style="background: var(--primary-light); color: var(--primary-color); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">
                Secure. Fast. Global.
            </span>
            <h1 style="font-size: 3.2rem; font-weight: 800; margin: 24px 0 16px; line-height: 1.2;">
                The Future of Digital Banking is Here
            </h1>
            <p style="font-size: 1.2rem; color: var(--text-muted); max-width: 700px; margin: 0 auto 32px;">
                Experience seamless money transfers, real-time analytics, competitive interest rates, and institutional-grade security.
            </p>
            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-primary" style="padding: 14px 32px; font-size: 1.1rem;">
                    Open An Account <i class="ri-arrow-right-line"></i>
                </a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-action" style="padding: 14px 32px; font-size: 1.1rem; flex-direction: row;">
                    Sign In <i class="ri-login-circle-line"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Key Features Grid -->
    <section style="max-width: 1200px; margin: 0 auto 80px; padding: 0 32px;">
        <div style="text-align: center; margin-bottom: 48px;">
            <h2 style="font-size: 2.2rem; font-weight: 700;">Why Millions Trust EasyBank</h2>
            <p style="color: var(--text-muted); margin-top: 8px;">Designed for personal financial freedom and commercial agility.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 32px;">
            <div class="glass-panel">
                <i class="ri-shield-keyhole-line" style="font-size: 2.5rem; color: var(--primary-color);"></i>
                <h3 style="margin: 16px 0 8px;">Military-Grade Security</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">BCrypt password hashing, session encryption, and real-time anti-fraud alerts.</p>
            </div>

            <div class="glass-panel">
                <i class="ri-flashlight-line" style="font-size: 2.5rem; color: var(--accent-color);"></i>
                <h3 style="margin: 16px 0 8px;">Instant Transfers</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Send money anywhere globally in seconds with atomic database transaction safety.</p>
            </div>

            <div class="glass-panel">
                <i class="ri-line-chart-line" style="font-size: 2.5rem; color: var(--warning-color);"></i>
                <h3 style="margin: 16px 0 8px;">Smart Financial Tools</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Built-in EMI loan calculators, interest estimator, and PDF statement generation.</p>
            </div>
        </div>
    </section>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>

    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
