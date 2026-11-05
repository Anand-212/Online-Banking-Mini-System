<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1300px; margin: 40px auto; padding: 0 32px;">
        <!-- Admin Nav Bar -->
        <div class="glass-panel" style="margin-bottom: 32px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
            <div>
                <span style="color: #ef4444; font-weight: 700; font-size: 0.85rem; letter-spacing: 1px; text-transform: uppercase;">Super Admin Console</span>
                <h1 style="font-size: 2rem; font-weight: 800; margin-top: 2px;">System Overview</h1>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-primary"><i class="ri-user-search-line"></i> User Directory</a>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="btn-primary" style="background: var(--accent-color);"><i class="ri-exchange-line"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="btn-primary" style="background: var(--warning-color);"><i class="ri-bar-chart-2-line"></i> Monthly Reports</a>
            </div>
        </div>

        <!-- System Financial Metrics Cards -->
        <div class="dashboard-grid">
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Active Users</div>
                    <div class="stat-value">${stats.totalActiveUsers}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-group-line"></i></div>
            </div>

            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Total Deposits</div>
                    <div class="stat-value" style="color: var(--accent-color);">Rs. ${stats.totalDeposits}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-download-2-line"></i></div>
            </div>

            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Total Withdrawals</div>
                    <div class="stat-value" style="color: var(--danger-color);">Rs. ${stats.totalWithdrawals}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-upload-2-line"></i></div>
            </div>

            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Total Transfers</div>
                    <div class="stat-value" style="color: var(--primary-color);">Rs. ${stats.totalTransfers}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-send-plane-line"></i></div>
            </div>

            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Today's Transactions</div>
                    <div class="stat-value">${stats.todayTxCount}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-calendar-event-line"></i></div>
            </div>

            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Bank Total Holdings</div>
                    <div class="stat-value" style="color: #a855f7;">Rs. ${stats.totalHoldings}</div>
                </div>
                <div class="icon-wrapper"><i class="ri-safe-2-line"></i></div>
            </div>
        </div>

        <!-- Recent System Audit Log -->
        <div class="glass-panel" style="margin-top: 32px;">
            <h2 style="font-size: 1.3rem; margin-bottom: 16px;"><i class="ri-history-line"></i> System Audit Stream</h2>
            <div class="table-responsive">
                <table class="bank-table">
                    <thead>
                        <tr>
                            <th>Log ID</th>
                            <th>Performed By</th>
                            <th>Role</th>
                            <th>Action</th>
                            <th>Details</th>
                            <th>IP Address</th>
                            <th>Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentLogs}">
                                <c:forEach var="log" items="${recentLogs}">
                                    <tr>
                                        <td>#${log.logId}</td>
                                        <td style="font-weight: 600;">${log.performedBy}</td>
                                        <td><span class="badge ${log.role eq 'ADMIN' ? 'badge-danger' : 'badge-warning'}">${log.role}</span></td>
                                        <td style="font-weight: 600;">${log.action}</td>
                                        <td style="font-size: 0.85rem; color: var(--text-muted);">${log.details}</td>
                                        <td style="font-family: monospace; font-size: 0.85rem;">${log.ipAddress}</td>
                                        <td style="font-size: 0.85rem; color: var(--text-muted);">${log.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; color: var(--text-muted);">No audit events.</td>
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
