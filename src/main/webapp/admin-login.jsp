<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 450px; margin: 80px auto; padding: 0 20px;">
        <div class="glass-panel" style="border-color: rgba(239, 68, 68, 0.3);">
            <div style="text-align: center; margin-bottom: 24px;">
                <i class="ri-admin-line" style="font-size: 3rem; color: #ef4444;"></i>
                <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">Admin Console Login</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem;">Restricted to authorized system administrators</p>
            </div>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${param.error}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                <div class="form-group">
                    <label>Admin Username</label>
                    <input type="text" name="username" class="form-control" placeholder="admin" required autofocus>
                </div>

                <div class="form-group">
                    <label>Admin Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px; background: #ef4444;">
                    <i class="ri-lock-2-line"></i> Authenticate Administrator
                </button>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
