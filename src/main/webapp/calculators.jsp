<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Calculators - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 1100px; margin: 60px auto; padding: 0 32px;">
        <h1 style="font-size: 2.2rem; font-weight: 800; text-align: center; margin-bottom: 40px;">Financial Calculators</h1>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 32px;">
            
            <!-- Loan EMI Calculator -->
            <div class="glass-panel">
                <h2 style="font-size: 1.4rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="ri-calculator-line" style="color: var(--primary-color);"></i> Loan EMI Calculator
                </h2>

                <div class="form-group">
                    <label>Loan Amount (Rs.)</label>
                    <input type="number" id="loanAmount" class="form-control" value="10000" min="1000" step="500">
                </div>
                <div class="form-group">
                    <label>Annual Interest Rate (%)</label>
                    <input type="number" id="interestRate" class="form-control" value="8.5" step="0.1">
                </div>
                <div class="form-group">
                    <label>Tenure (Years)</label>
                    <input type="number" id="tenureYears" class="form-control" value="3" min="1" max="30">
                </div>

                <button class="btn-primary" onclick="calculateEMI()" style="width: 100%; margin-top: 10px;">Calculate EMI</button>

                <div class="nested-card" style="margin-top: 24px; padding: 16px; border-radius: var(--radius-sm);">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                        <span>Monthly EMI:</span>
                        <strong id="monthlyEmiResult" style="color: var(--accent-color);">Rs. 0.00</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                        <span>Total Interest Payable:</span>
                        <strong id="totalInterestResult" style="color: var(--warning-color);">Rs. 0.00</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Total Amount Payable:</span>
                        <strong id="totalPaymentResult" style="color: var(--primary-color);">Rs. 0.00</strong>
                    </div>
                </div>
            </div>

            <!-- Currency Converter -->
            <div class="glass-panel">
                <h2 style="font-size: 1.4rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="ri-money-dollar-circle-line" style="color: var(--accent-color);"></i> Currency Converter
                </h2>

                <div class="form-group">
                    <label>Amount</label>
                    <input type="number" id="currAmount" class="form-control" value="100" min="1">
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label>From Currency</label>
                        <select id="fromCurr" class="form-control">
                            <option value="USD">USD ($)</option>
                            <option value="EUR">EUR (€)</option>
                            <option value="GBP">GBP (£)</option>
                            <option value="INR">INR (₹)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>To Currency</label>
                        <select id="toCurr" class="form-control">
                            <option value="EUR">EUR (€)</option>
                            <option value="USD">USD ($)</option>
                            <option value="GBP">GBP (£)</option>
                            <option value="INR">INR (₹)</option>
                        </select>
                    </div>
                </div>

                <button class="btn-primary" onclick="convertCurrency()" style="width: 100%; margin-top: 10px; background: var(--accent-color);">Convert</button>

                <div class="nested-card" style="margin-top: 24px; padding: 20px; border-radius: var(--radius-sm); text-align: center;">
                    <span style="font-size: 0.9rem; color: var(--text-muted);">Live Converted Result</span>
                    <h3 id="currResult" style="font-size: 1.5rem; margin-top: 6px; color: var(--accent-color);">100 USD = 92.00 EUR</h3>
                </div>
            </div>

        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
