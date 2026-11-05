<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1000px; margin: 60px auto; padding: 0 32px;">
        <div class="glass-panel" style="padding: 40px;">
            <h1 style="font-size: 2.4rem; font-weight: 800; margin-bottom: 20px;">About EasyBank</h1>
            <p style="color: var(--text-muted); font-size: 1.1rem; line-height: 1.8; margin-bottom: 24px;">
                Founded in 2026, EasyBank is an institutional pioneer in modern digital banking architecture. Built on Java Servlets, Jakarta EE 10, and high-performance Oracle Database backends, we deliver zero-latency financial operations for over 2 million accounts worldwide.
            </p>

            <h2 style="font-size: 1.5rem; margin: 32px 0 16px;">Our Core Philosophy</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                <div class="glass-panel nested-card">
                    <h3 style="color: var(--primary-color);">Integrity</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-top: 8px;">Uncompromising compliance, PCI-DSS security standard adherence, and complete data privacy.</p>
                </div>
                <div class="glass-panel nested-card">
                    <h3 style="color: var(--accent-color);">Innovation</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-top: 8px;">Next-gen glassmorphism interface with intuitive micro-interactions and instant financial tools.</p>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
