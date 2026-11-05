<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Page Not Found - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 600px; margin: 100px auto; text-align: center; padding: 0 20px;">
        <div class="glass-panel" style="padding: 60px 40px;">
            <i class="ri-compass-4-line" style="font-size: 4rem; color: var(--warning-color);"></i>
            <h1 style="font-size: 3rem; font-weight: 800; margin-top: 16px;">404</h1>
            <h2 style="font-size: 1.4rem; margin-bottom: 12px;">Resource Not Found</h2>
            <p style="color: var(--text-muted); margin-bottom: 32px;">The page or banking route you requested does not exist or has been moved.</p>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary"><i class="ri-home-4-line"></i> Return to Homepage</a>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
