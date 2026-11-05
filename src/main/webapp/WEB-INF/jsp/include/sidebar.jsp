<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar">
    <div style="display: flex; align-items: center; gap: 12px; padding-bottom: 20px; border-bottom: 1px solid var(--glass-border);">
        <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--primary-color); color: #ffffff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.2rem;">
            ${sessionScope.loggedUser.fullName.substring(0, 1)}
        </div>
        <div>
            <div style="font-weight: 700; font-size: 0.95rem;">${sessionScope.loggedUser.fullName}</div>
            <div style="font-size: 0.75rem; color: var(--text-muted);">Acc: ${sessionScope.loggedUser.accountNumber}</div>
        </div>
    </div>

    <ul style="list-style: none; display: flex; flex-direction: column; gap: 8px;">
        <li><a href="${pageContext.request.contextPath}/dashboard" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-dashboard-3-line"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/deposit" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-download-2-line"></i> Deposit Funds</a></li>
        <li><a href="${pageContext.request.contextPath}/withdraw" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-upload-2-line"></i> Withdraw Cash</a></li>
        <li><a href="${pageContext.request.contextPath}/transfer" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-send-plane-line"></i> Transfer Money</a></li>
        <li><a href="${pageContext.request.contextPath}/transactions" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-history-line"></i> Transaction History</a></li>
        <li><a href="${pageContext.request.contextPath}/profile" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
        <li><a href="${pageContext.request.contextPath}/change-password" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-key-2-line"></i> Change Password</a></li>
        <li><a href="${pageContext.request.contextPath}/set-mpin" class="btn-action" style="flex-direction: row; justify-content: flex-start;"><i class="ri-shield-keyhole-line"></i> Manage MPIN</a></li>
        <li style="margin-top: 20px;"><a href="${pageContext.request.contextPath}/logout" class="btn-action" style="flex-direction: row; justify-content: flex-start; background: rgba(239, 68, 68, 0.15); color: #ef4444;"><i class="ri-logout-box-r-line"></i> Logout</a></li>
    </ul>
</aside>
