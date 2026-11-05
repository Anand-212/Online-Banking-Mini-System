<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 900px; margin: 60px auto; padding: 0 32px;">
        <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 24px; text-align: center;">Frequently Asked Questions</h1>

        <div style="display: flex; flex-direction: column; gap: 20px;">
            <div class="glass-panel">
                <h3 style="font-size: 1.2rem; margin-bottom: 8px;">How do I open an account online?</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Click on 'Open Account' in the top navigation, fill in your personal details, select account type, and make your initial deposit.</p>
            </div>

            <div class="glass-panel">
                <h3 style="font-size: 1.2rem; margin-bottom: 8px;">Is my password secure?</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Yes. Passwords are salted and hashed using BCrypt prior to database storage. Plaintext passwords are never logged or stored.</p>
            </div>

            <div class="glass-panel">
                <h3 style="font-size: 1.2rem; margin-bottom: 8px;">What should I do if my account is frozen?</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">If your account status displays 'FROZEN', please contact customer support or visit your nearest branch with proof of identity.</p>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
