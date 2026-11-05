<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Transactions - Admin Console</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1300px; margin: 40px auto; padding: 0 32px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800;"><i class="ri-exchange-line"></i> Master Transaction Ledger</h1>
                <p style="color: var(--text-muted);">Real-time audit log of all system deposits, withdrawals, and inter-bank transfers</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-action" style="flex-direction: row;"><i class="ri-arrow-left-line"></i> Dashboard</a>
        </div>

        <div class="glass-panel">
            <div class="table-responsive">
                <table class="bank-table">
                    <thead>
                        <tr>
                            <th>Tx ID</th>
                            <th>Timestamp</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Sender Acc</th>
                            <th>Receiver Acc</th>
                            <th>Closing Balances (S/R)</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty transactions}">
                                <c:forEach var="tx" items="${transactions}">
                                    <tr>
                                        <td style="font-family: monospace; font-weight: 700;">${tx.transactionId}</td>
                                        <td style="font-size: 0.85rem; color: var(--text-muted);">${tx.transactionDate}</td>
                                        <td>
                                            <span style="font-weight: 600; color: ${tx.transactionType eq 'DEPOSIT' ? 'var(--accent-color)' : (tx.transactionType eq 'WITHDRAWAL' ? 'var(--danger-color)' : 'var(--primary-color)')};">
                                                ${tx.transactionType}
                                            </span>
                                        </td>
                                        <td style="font-weight: 700;">Rs. ${tx.amount}</td>
                                        <td style="font-size: 0.85rem;">${tx.senderAccount != null ? tx.senderAccount : 'N/A'}</td>
                                        <td style="font-size: 0.85rem;">${tx.receiverAccount != null ? tx.receiverAccount : 'N/A'}</td>
                                        <td style="font-size: 0.8rem; color: var(--text-muted);">
                                            Rs. ${tx.senderClosingBalance != null ? tx.senderClosingBalance : '-'} / Rs. ${tx.receiverClosingBalance != null ? tx.receiverClosingBalance : '-'}
                                        </td>
                                        <td><span class="badge badge-success">${tx.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">No transactions recorded.</td>
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
