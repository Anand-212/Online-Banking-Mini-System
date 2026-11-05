<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Funds - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <div style="max-width: 600px; margin: 20px auto;">
                <div class="glass-panel">
                    <div style="text-align: center; margin-bottom: 24px;">
                        <i class="ri-download-2-line" style="font-size: 3rem; color: var(--accent-color);"></i>
                        <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">Deposit Funds</h1>
                        <p style="color: var(--text-muted); font-size: 0.9rem;">Add funds directly to your active EasyBank account</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${success}</div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not sessionScope.loggedUser.hasMpin()}">
                            <div class="alert alert-warning" style="margin-bottom: 20px;">
                                <i class="ri-information-line"></i> <strong>MPIN Setup Required:</strong> You need to set a 4-digit MPIN before making deposits. 
                                <a href="${pageContext.request.contextPath}/set-mpin" style="font-weight: 600; text-decoration: underline; margin-left: 6px;">Set MPIN Now</a>
                            </div>
                        </c:when>
                        <c:when test="${sessionScope.loggedUser.isMpinLocked()}">
                            <div class="alert alert-danger" style="margin-bottom: 20px;">
                                <i class="ri-lock-line"></i> <strong>Transactions Locked:</strong> Your MPIN has been locked due to repeated incorrect attempts. Please wait 15 minutes.
                            </div>
                        </c:when>
                    </c:choose>

                    <form action="${pageContext.request.contextPath}/deposit" method="POST" id="depositForm">
                        <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

                        <div class="form-group">
                            <label>Target Account Number</label>
                            <input type="text" class="form-control" value="${sessionScope.loggedUser.accountNumber}" readonly>
                        </div>

                        <div class="form-group">
                            <label>Current Available Balance</label>
                            <input type="text" class="form-control" value="Rs. ${sessionScope.loggedUser.balance}" readonly style="font-weight: 700; color: var(--accent-color);">
                        </div>

                        <div class="form-group">
                            <label>Deposit Amount (Rs.)</label>
                            <input type="number" name="amount" class="form-control" placeholder="100.00" min="1" step="0.01" required autofocus>
                        </div>

                        <div class="form-group">
                            <label>Transaction Description (Optional)</label>
                            <input type="text" name="description" class="form-control" placeholder="e.g. Salary Deposit / Cheque Credit">
                        </div>

                        <div class="form-group">
                            <label><i class="ri-shield-keyhole-line"></i> 4-Digit Security MPIN</label>
                            <input type="password" name="mpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" required title="Must be exactly 4 numeric digits">
                            <small style="font-size: 0.75rem; color: var(--text-muted);">Authorize this deposit with your 4-digit PIN</small>
                        </div>

                        <button type="submit" id="depositBtn" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px; background: var(--accent-color);">
                            <i class="ri-download-2-line"></i> Complete Deposit
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        document.getElementById('depositForm')?.addEventListener('submit', function() {
            var btn = document.getElementById('depositBtn');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="ri-loader-4-line"></i> Processing Deposit...';
            }
        });
    </script>
</body>
</html>
