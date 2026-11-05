<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <div style="max-width: 650px; margin: 20px auto;">
                <div class="glass-panel">
                    <h1 style="font-size: 1.8rem; font-weight: 700; margin-bottom: 8px;"><i class="ri-user-settings-line"></i> Profile Details</h1>
                    <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 24px;">View your account details and update contact information</p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${success}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>Account Number (Fixed)</label>
                                <input type="text" class="form-control" value="${sessionScope.loggedUser.accountNumber}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Username (Fixed)</label>
                                <input type="text" class="form-control" value="${sessionScope.loggedUser.username}" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" class="form-control" value="${sessionScope.loggedUser.fullName}" readonly>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="email" class="form-control" value="${sessionScope.loggedUser.email}" required>
                            </div>
                            <div class="form-group">
                                <label>Mobile Phone</label>
                                <input type="tel" name="mobileNumber" class="form-control" value="${sessionScope.loggedUser.mobileNumber}" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Residential Address</label>
                            <input type="text" name="address" class="form-control" value="${sessionScope.loggedUser.address}" required>
                        </div>

                        <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 12px;">Save Profile Changes</button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
