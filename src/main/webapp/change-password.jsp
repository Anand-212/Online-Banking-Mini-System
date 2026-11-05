<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <div style="max-width: 500px; margin: 20px auto;">
                <div class="glass-panel">
                    <h1 style="font-size: 1.8rem; font-weight: 700; margin-bottom: 8px;"><i class="ri-key-2-line"></i> Change Password</h1>
                    <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 24px;">Update your password regularly to maintain account safety</p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${success}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/change-password" method="POST">
                        <div class="form-group">
                            <label>Current Password</label>
                            <input type="password" name="currentPassword" class="form-control" placeholder="••••••••" required autofocus>
                        </div>

                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" id="passwordInput" name="newPassword" class="form-control" placeholder="••••••••" required>
                            <small id="passwordStrengthMeter" style="font-size: 0.8rem; margin-top: 4px; font-weight: 600;"></small>
                        </div>

                        <div class="form-group">
                            <label>Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px; background: var(--warning-color);">
                            Update Password
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
