<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Transaction MPIN - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <div style="max-width: 540px; margin: 20px auto;">
                <div class="glass-panel">
                    <div style="text-align: center; margin-bottom: 24px;">
                        <i class="ri-shield-keyhole-line" style="font-size: 3rem; color: var(--accent-color);"></i>
                        <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">
                            <c:choose>
                                <c:when test="${sessionScope.loggedUser.hasMpin()}">Change 4-Digit MPIN</c:when>
                                <c:otherwise>Set Up 4-Digit MPIN</c:otherwise>
                            </c:choose>
                        </h1>
                        <p style="color: var(--text-muted); font-size: 0.9rem;">
                            Your 4-digit MPIN secures deposits, withdrawals, and fund transfers
                        </p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${success}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/set-mpin" method="POST" id="mpinForm">
                        <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

                        <c:choose>
                            <c:when test="${sessionScope.loggedUser.hasMpin()}">
                                <div class="form-group">
                                    <label>Current 4-Digit MPIN</label>
                                    <input type="password" name="currentMpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" autofocus>
                                    <small style="font-size: 0.75rem; color: var(--text-muted);">Or enter your account password below if you forgot your MPIN</small>
                                </div>
                                <div class="form-group">
                                    <label>Account Login Password (Alternative verification)</label>
                                    <input type="password" name="currentPassword" class="form-control" placeholder="••••••••">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="form-group">
                                    <label>Account Login Password (Identity Verification)</label>
                                    <input type="password" name="currentPassword" class="form-control" placeholder="••••••••" required autofocus>
                                    <small style="font-size: 0.75rem; color: var(--text-muted);">Confirm your account password to authorize MPIN setup</small>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="form-group">
                            <label>New 4-Digit MPIN</label>
                            <input type="password" name="newMpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" required title="Must be exactly 4 numeric digits">
                            <small style="font-size: 0.75rem; color: var(--text-muted);">Exactly 4 numeric digits (e.g. 0456, 1234)</small>
                        </div>

                        <div class="form-group">
                            <label>Confirm New 4-Digit MPIN</label>
                            <input type="password" name="confirmMpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" required title="Must match new MPIN">
                        </div>

                        <button type="submit" id="submitMpinBtn" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px; background: var(--accent-color);">
                            <i class="ri-shield-check-line"></i> Save 4-Digit MPIN
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        document.getElementById('mpinForm')?.addEventListener('submit', function() {
            var btn = document.getElementById('submitMpinBtn');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="ri-loader-4-line"></i> Saving MPIN...';
            }
        });
    </script>
</body>
</html>
