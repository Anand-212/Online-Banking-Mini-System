<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open New Account - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 700px; margin: 60px auto; padding: 0 20px;">
        <div class="glass-panel">
            <div style="text-align: center; margin-bottom: 32px;">
                <i class="ri-user-add-line" style="font-size: 3rem; color: var(--accent-color);"></i>
                <h1 style="font-size: 1.8rem; font-weight: 700; margin-top: 8px;">Open a New Bank Account</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem;">Join thousands of satisfied EasyBank customer accounts worldwide</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="ri-error-warning-line"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Enter full name" required>
                    </div>

                    <div class="form-group">
                        <label>Desired Username</label>
                        <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="Enter email address" required>
                    </div>

                    <div class="form-group">
                        <label>Mobile Phone</label>
                        <input type="tel" name="mobileNumber" class="form-control" placeholder="9876543210" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="passwordInput" name="password" class="form-control" placeholder="••••••••" required>
                        <small id="passwordStrengthMeter" style="font-size: 0.8rem; margin-top: 4px; font-weight: 600;"></small>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>4-Digit Security MPIN</label>
                        <input type="password" name="mpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" required title="Must be exactly 4 numeric digits">
                        <small style="font-size: 0.75rem; color: var(--text-muted);">Used to authorize financial transactions</small>
                    </div>

                    <div class="form-group">
                        <label>Confirm 4-Digit MPIN</label>
                        <input type="password" name="confirmMpin" class="form-control" placeholder="••••" maxlength="4" pattern="\d{4}" inputmode="numeric" required title="Must match MPIN">
                        <small style="font-size: 0.75rem; color: var(--text-muted);">Re-enter 4 digits</small>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender" class="form-control" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Residential Address</label>
                    <input type="text" name="address" class="form-control" placeholder="Enter residential address" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Account Type</label>
                        <select name="accountTypeId" class="form-control" required>
                            <option value="1">Savings Account (Min Rs. 500)</option>
                            <option value="2">Current Account (Min Rs. 1000)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Initial Deposit (Rs.)</label>
                        <input type="number" name="initialDeposit" class="form-control" value="1000.00" min="500" step="100" required>
                    </div>
                </div>

                <button type="submit" id="submitBtn" class="btn-primary" style="width: 100%; padding: 14px; margin-top: 16px; background: var(--accent-color);">
                    <i class="ri-user-add-line"></i> Create Account Now
                </button>
            </form>

            <div style="text-align: center; margin-top: 24px; font-size: 0.9rem; color: var(--text-muted);">
                Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight: 600;">Sign In</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>
        document.getElementById('registerForm')?.addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="ri-loader-4-line"></i> Creating Account...';
            }
        });
    </script>
</body>
</html>
