<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div class="app-container">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <main class="main-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800;">Transaction Statement</h1>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Filter, search, and download official PDF statements</p>
                </div>
                <a href="${pageContext.request.contextPath}/export-pdf?type=${txType}&startDate=${startDate}&endDate=${endDate}" class="btn-primary" style="background: #a855f7;">
                    <i class="ri-file-pdf-line"></i> Download PDF Statement
                </a>
            </div>

            <!-- Filter Panel -->
            <div class="glass-panel" style="margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/transactions" method="GET" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; align-items: end;">
                    <div class="form-group" style="margin:0;">
                        <label>Transaction Type</label>
                        <select name="type" class="form-control">
                            <option value="ALL" ${txType eq 'ALL' ? 'selected' : ''}>All Types</option>
                            <option value="DEPOSIT" ${txType eq 'DEPOSIT' ? 'selected' : ''}>Deposit</option>
                            <option value="WITHDRAWAL" ${txType eq 'WITHDRAWAL' ? 'selected' : ''}>Withdrawal</option>
                            <option value="TRANSFER" ${txType eq 'TRANSFER' ? 'selected' : ''}>Transfer</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin:0;">
                        <label>Start Date</label>
                        <input type="date" name="startDate" class="form-control" value="${startDate}">
                    </div>

                    <div class="form-group" style="margin:0;">
                        <label>End Date</label>
                        <input type="date" name="endDate" class="form-control" value="${endDate}">
                    </div>

                    <div class="form-group" style="margin:0;">
                        <label>Search Keyword</label>
                        <input type="text" name="search" class="form-control" placeholder="ID or Description..." value="${search}">
                    </div>

                    <button type="submit" class="btn-primary" style="height: 45px;"><i class="ri-filter-3-line"></i> Apply Filter</button>
                </form>
            </div>

            <!-- Transactions Table -->
            <div class="glass-panel">
                <div class="table-responsive">
                    <table class="bank-table">
                        <thead>
                            <tr>
                                <th>Tx ID</th>
                                <th>Timestamp</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Sender</th>
                                <th>Receiver</th>
                                <th>Description</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty transactions}">
                                    <c:forEach var="tx" items="${transactions}">
                                        <tr>
                                            <td style="font-family: monospace; font-size: 0.85rem; font-weight: 700;">${tx.transactionId}</td>
                                            <td style="font-size: 0.85rem; color: var(--text-muted);">${tx.transactionDate}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${tx.transactionType eq 'DEPOSIT'}"><span style="color: var(--accent-color); font-weight: 600;">Deposit</span></c:when>
                                                    <c:when test="${tx.transactionType eq 'WITHDRAWAL'}"><span style="color: var(--danger-color); font-weight: 600;">Withdrawal</span></c:when>
                                                    <c:otherwise><span style="color: var(--primary-color); font-weight: 600;">Transfer</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-weight: 700;">Rs. ${tx.amount}</td>
                                            <td style="font-size: 0.85rem;">${tx.senderAccount != null ? tx.senderAccount : 'N/A'}</td>
                                            <td style="font-size: 0.85rem;">${tx.receiverAccount != null ? tx.receiverAccount : 'N/A'}</td>
                                            <td style="font-size: 0.85rem; color: var(--text-muted);">${tx.description}</td>
                                            <td><span class="badge badge-success">${tx.status}</span></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">No transaction records matched your filter criteria.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
