<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Login - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 480px; margin: 80px auto; padding: 0 20px;">
        <div class="glass-panel">
            <div style="text-align: center; margin-bottom: 32px;">
                <i class="ri-shield-user-line" style="font-size: 3rem; color: var(--primary-color);"></i>
                <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">Customer Portal</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem;">Enter your credentials to access your account</p>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${param.success}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${param.error}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Enter your username" required autofocus>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <label>Password</label>
                        <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: 0.85rem;">Forgot Password?</a>
                    </div>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px;">
                    <i class="ri-login-box-line"></i> Sign In to Account
                </button>
            </form>

            <div style="text-align: center; margin-top: 24px; font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp" style="font-weight: 600;">Register Now</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
