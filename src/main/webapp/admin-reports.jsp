<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monthly Analytics & Reports - Admin Console</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1200px; margin: 40px auto; padding: 0 32px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800;"><i class="ri-bar-chart-2-line"></i> Financial Analytics & Reports</h1>
                <p style="color: var(--text-muted);">Visual statistics and banking performance breakdown</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-action" style="flex-direction: row;"><i class="ri-arrow-left-line"></i> Dashboard</a>
        </div>

        <!-- Charts Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(500px, 1fr)); gap: 32px; margin-bottom: 32px;">
            <!-- Volume Chart -->
            <div class="glass-panel">
                <h3 style="font-size: 1.2rem; margin-bottom: 20px;">System Transaction Volumes (Rs.)</h3>
                <canvas id="txVolumeChart" height="250"></canvas>
            </div>

            <!-- Distribution Chart -->
            <div class="glass-panel">
                <h3 style="font-size: 1.2rem; margin-bottom: 20px;">Financial Flow Distribution</h3>
                <canvas id="flowDistributionChart" height="250"></canvas>
            </div>
        </div>

        <!-- Financial Summary Cards -->
        <div class="dashboard-grid">
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Net System Deposits</div>
                    <div class="stat-value" style="color: var(--accent-color);">Rs. ${stats.totalDeposits}</div>
                </div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Net System Withdrawals</div>
                    <div class="stat-value" style="color: var(--danger-color);">Rs. ${stats.totalWithdrawals}</div>
                </div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-label">Total System Liquidity</div>
                    <div class="stat-value" style="color: var(--primary-color);">Rs. ${stats.totalHoldings}</div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const totalDeposits = parseFloat("${stats.totalDeposits}" || 0);
            const totalWithdrawals = parseFloat("${stats.totalWithdrawals}" || 0);
            const totalTransfers = parseFloat("${stats.totalTransfers}" || 0);

            // Volume Bar Chart
            const ctx1 = document.getElementById('txVolumeChart').getContext('2d');
            new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: ['Deposits', 'Withdrawals', 'Transfers'],
                    datasets: [{
                        label: 'Volume (Rs.)',
                        data: [totalDeposits, totalWithdrawals, totalTransfers],
                        backgroundColor: ['#10b981', '#ef4444', '#2563eb'],
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } }
                }
            });

            // Flow Doughnut Chart
            const ctx2 = document.getElementById('flowDistributionChart').getContext('2d');
            new Chart(ctx2, {
                type: 'doughnut',
                data: {
                    labels: ['Deposits', 'Withdrawals', 'Transfers'],
                    datasets: [{
                        data: [totalDeposits, totalWithdrawals, totalTransfers],
                        backgroundColor: ['#10b981', '#ef4444', '#2563eb']
                    }]
                },
                options: {
                    responsive: true
                }
            });
        });
    </script>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
