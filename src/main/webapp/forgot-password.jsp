<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 480px; margin: 80px auto; padding: 0 20px;">
        <div class="glass-panel">
            <div style="text-align: center; margin-bottom: 32px;">
                <i class="ri-lock-unlock-line" style="font-size: 3rem; color: var(--warning-color);"></i>
                <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">Reset Password</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem;">Verification OTP code simulation</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${success}</div>
            </c:if>

            <c:choose>
                <c:when test="${step eq 'verifyOtp'}">
                    <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                        <input type="hidden" name="action" value="resetPassword">
                        
                        <div class="form-group">
                            <label>Enter 6-Digit OTP</label>
                            <input type="text" name="otp" class="form-control" placeholder="123456" value="${simulatedOtp}" required>
                        </div>

                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="••••••••" required>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px; background: var(--warning-color);">
                            Update Password
                        </button>
                    </form>
                </c:when>

                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                        <input type="hidden" name="action" value="sendOtp">

                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" class="form-control" placeholder="Enter your username" required autofocus>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px;">
                            Request OTP Simulation
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>

            <div style="text-align: center; margin-top: 24px; font-size: 0.9rem;">
                <a href="${pageContext.request.contextPath}/login.jsp"><i class="ri-arrow-left-line"></i> Back to Login</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
