<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <!-- Header Welcome Card -->
            <div class="glass-panel welcome-card">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <span style="font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;">Online Banking Portal</span>
                        <h1 style="font-size: 2.2rem; font-weight: 800; margin-top: 4px;">Welcome back, ${sessionScope.loggedUser.fullName}! 👋</h1>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-size: 0.85rem; color: var(--text-muted);">Account Number</span>
                        <div class="account-num">${sessionScope.loggedUser.accountNumber}</div>
                    </div>
                </div>
            </div>

            <c:if test="${not sessionScope.loggedUser.hasMpin()}">
                <div class="alert alert-warning" style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <i class="ri-shield-keyhole-line" style="font-size: 1.2rem;"></i>
                        <strong>Security Setup Recommended:</strong> You have not configured your 4-digit Transaction MPIN yet.
                    </div>
                    <a href="${pageContext.request.contextPath}/set-mpin" class="btn-primary" style="padding: 6px 16px; font-size: 0.85rem; text-decoration: none;">Set MPIN Now</a>
                </div>
            </c:if>
            <c:if test="${sessionScope.loggedUser.isMpinLocked()}">
                <div class="alert alert-danger" style="margin-bottom: 24px;">
                    <i class="ri-lock-line" style="font-size: 1.2rem;"></i>
                    <strong>Transaction Alert:</strong> Your MPIN is currently locked due to repeated incorrect entries.
                </div>
            </c:if>

            <!-- Stats Grid -->
            <div class="dashboard-grid">
                <div class="glass-panel stat-card">
                    <div>
                        <div class="stat-label">Current Balance</div>
                        <div class="stat-value" style="color: var(--accent-color);">Rs. ${sessionScope.loggedUser.balance}</div>
                    </div>
                    <div class="icon-wrapper"><i class="ri-wallet-3-line"></i></div>
                </div>

                <div class="glass-panel stat-card">
                    <div>
                        <div class="stat-label">Account Type</div>
                        <div class="stat-value" style="font-size: 1.3rem;">${sessionScope.loggedUser.accountTypeName}</div>
                    </div>
                    <div class="icon-wrapper"><i class="ri-bank-card-line"></i></div>
                </div>

                <div class="glass-panel stat-card">
                    <div>
                        <div class="stat-label">Total Transactions</div>
                        <div class="stat-value">${totalTransactions}</div>
                    </div>
                    <div class="icon-wrapper"><i class="ri-exchange-funds-line"></i></div>
                </div>

                <div class="glass-panel stat-card">
                    <div>
                        <div class="stat-label">Account Status</div>
                        <div class="stat-value" style="font-size: 1.2rem;">
                            <span class="badge badge-success">${sessionScope.loggedUser.status}</span>
                        </div>
                    </div>
                    <div class="icon-wrapper"><i class="ri-shield-check-line"></i></div>
                </div>
            </div>

            <!-- Quick Action Buttons -->
            <h2 style="font-size: 1.3rem; margin-bottom: 16px;">Quick Actions</h2>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/deposit" class="btn-action">
                    <i class="ri-download-2-line" style="font-size: 1.5rem; color: var(--accent-color);"></i>
                    <span>Deposit</span>
                </a>
                <a href="${pageContext.request.contextPath}/withdraw" class="btn-action">
                    <i class="ri-upload-2-line" style="font-size: 1.5rem; color: var(--danger-color);"></i>
                    <span>Withdraw</span>
                </a>
                <a href="${pageContext.request.contextPath}/transfer" class="btn-action">
                    <i class="ri-send-plane-line" style="font-size: 1.5rem; color: var(--primary-color);"></i>
                    <span>Transfer</span>
                </a>
                <a href="${pageContext.request.contextPath}/transactions" class="btn-action">
                    <i class="ri-file-text-line" style="font-size: 1.5rem; color: var(--warning-color);"></i>
                    <span>History</span>
                </a>
                <a href="${pageContext.request.contextPath}/export-pdf" class="btn-action">
                    <i class="ri-file-pdf-line" style="font-size: 1.5rem; color: #a855f7;"></i>
                    <span>Export PDF</span>
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="btn-action">
                    <i class="ri-user-settings-line" style="font-size: 1.5rem; color: var(--text-muted);"></i>
                    <span>Profile</span>
                </a>
            </div>

            <!-- Recent Transactions & Notifications Split -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 32px; margin-top: 32px;">
                <!-- Recent 5 Transactions -->
                <div class="glass-panel">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <h3 style="font-size: 1.2rem;">Recent Transactions</h3>
                        <a href="${pageContext.request.contextPath}/transactions" style="font-size: 0.85rem; font-weight: 600;">View All <i class="ri-arrow-right-s-line"></i></a>
                    </div>

                    <div class="table-responsive">
                        <table class="bank-table">
                            <thead>
                                <tr>
                                    <th>Tx ID</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentTransactions}">
                                        <c:forEach var="tx" items="${recentTransactions}">
                                            <tr>
                                                <td style="font-family: monospace; font-size: 0.85rem;">${tx.transactionId}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${tx.transactionType eq 'DEPOSIT'}"><span style="color: var(--accent-color); font-weight: 600;">Deposit</span></c:when>
                                                        <c:when test="${tx.transactionType eq 'WITHDRAWAL'}"><span style="color: var(--danger-color); font-weight: 600;">Withdrawal</span></c:when>
                                                        <c:otherwise><span style="color: var(--primary-color); font-weight: 600;">Transfer</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-weight: 700;">Rs. ${tx.amount}</td>
                                                <td style="font-size: 0.85rem; color: var(--text-muted);">${tx.transactionDate}</td>
                                                <td><span class="badge badge-success">${tx.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: var(--text-muted);">No transactions recorded yet.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- System Notifications Panel -->
                <div class="glass-panel">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <h3 style="font-size: 1.2rem;"><i class="ri-notification-3-line"></i> Notifications</h3>
                        <form action="${pageContext.request.contextPath}/notifications" method="POST" style="margin:0;">
                            <button type="submit" style="background: none; border: none; color: var(--primary-color); font-size: 0.8rem; cursor: pointer;">Mark Read</button>
                        </form>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 12px; max-height: 300px; overflow-y: auto;">
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <c:forEach var="n" items="${notifications}">
                                    <div class="notification-item" style="border-left: 3px solid ${n.read ? 'var(--text-muted)' : 'var(--primary-color)'};">
                                        <div class="notif-title">${n.title}</div>
                                        <div class="notif-msg">${n.message}</div>
                                        <div class="notif-time">${n.createdAt}</div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; color: var(--text-muted); padding: 20px;">No notifications.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
