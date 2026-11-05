<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Console</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1300px; margin: 40px auto; padding: 0 32px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800;"><i class="ri-group-line"></i> Customer Directory & Controls</h1>
                <p style="color: var(--text-muted);">Manage customer accounts, freeze suspicious activities, and activate services.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-action" style="flex-direction: row;"><i class="ri-arrow-left-line"></i> Dashboard</a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="ri-checkbox-circle-line"></i> ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${param.error}</div>
        </c:if>

        <!-- Search Bar -->
        <div class="glass-panel" style="margin-bottom: 24px;">
            <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display: flex; gap: 16px; align-items: center;">
                <div class="form-group" style="margin:0; flex:1;">
                    <input type="text" name="search" class="form-control" placeholder="Search by name, email, username, or account number..." value="${search}">
                </div>
                <div class="form-group" style="margin:0; width: 180px;">
                    <select name="status" class="form-control">
                        <option value="ALL" ${status eq 'ALL' ? 'selected' : ''}>All Statuses</option>
                        <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="FROZEN" ${status eq 'FROZEN' ? 'selected' : ''}>Frozen</option>
                    </select>
                </div>
                <button type="submit" class="btn-primary" style="height: 45px;"><i class="ri-search-line"></i> Search</button>
            </form>
        </div>

        <!-- Users Directory Table -->
        <div class="glass-panel">
            <div class="table-responsive">
                <table class="bank-table">
                    <thead>
                        <tr>
                            <th>Acc Number</th>
                            <th>Full Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Account Type</th>
                            <th>Balance</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty users}">
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td style="font-family: monospace; font-weight: 700;">${u.accountNumber}</td>
                                        <td style="font-weight: 600;">${u.fullName}</td>
                                        <td>${u.username}</td>
                                        <td style="font-size: 0.85rem;">${u.email}</td>
                                        <td>${u.accountTypeName}</td>
                                        <td style="font-weight: 700; color: var(--accent-color);">Rs. ${u.balance}</td>
                                        <td>
                                            <span class="badge ${u.status eq 'ACTIVE' ? 'badge-success' : 'badge-danger'}">${u.status}</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <c:choose>
                                                    <c:when test="${u.status eq 'ACTIVE'}">
                                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="margin:0;">
                                                            <input type="hidden" name="action" value="freeze">
                                                            <input type="hidden" name="userId" value="${u.userId}">
                                                            <button type="submit" class="btn-action" style="padding: 6px 12px; font-size: 0.75rem; background: rgba(245, 158, 11, 0.2); color: #f59e0b; flex-direction: row;">Freeze</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="margin:0;">
                                                            <input type="hidden" name="action" value="activate">
                                                            <input type="hidden" name="userId" value="${u.userId}">
                                                            <button type="submit" class="btn-action" style="padding: 6px 12px; font-size: 0.75rem; background: rgba(16, 185, 129, 0.2); color: #10b981; flex-direction: row;">Activate</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this account?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                    <button type="submit" class="btn-action" style="padding: 6px 12px; font-size: 0.75rem; background: rgba(239, 68, 68, 0.2); color: #ef4444; flex-direction: row;">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">No user accounts found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
