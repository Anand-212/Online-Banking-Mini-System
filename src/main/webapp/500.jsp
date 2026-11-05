<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 Internal Error - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 600px; margin: 100px auto; text-align: center; padding: 0 20px;">
        <div class="glass-panel" style="padding: 60px 40px; border-color: rgba(239, 68, 68, 0.3);">
            <i class="ri-bug-line" style="font-size: 4rem; color: var(--danger-color);"></i>
            <h1 style="font-size: 3rem; font-weight: 800; margin-top: 16px; color: var(--danger-color);">500</h1>
            <h2 style="font-size: 1.4rem; margin-bottom: 12px;">Internal Server Error</h2>
            <p style="color: var(--text-muted); margin-bottom: 24px;">An internal exception occurred. Please verify database connectivity to Oracle XE and Tomcat server logs.</p>
            <div style="font-family: monospace; font-size: 0.8rem; background: rgba(15,23,42,0.8); padding: 12px; border-radius: 6px; color: #f87171; text-align: left; margin-bottom: 24px; overflow-x: auto;">
                ${pageContext.exception != null ? pageContext.exception.message : 'Database or Server Connection Exception'}
            </div>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary"><i class="ri-home-4-line"></i> Back to Safety</a>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
