<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - EasyBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <%@ include file="/WEB-INF/jsp/include/navbar.jsp" %>

    <div style="max-width: 900px; margin: 60px auto; padding: 0 32px;">
        <div class="glass-panel" style="padding: 40px;">
            <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 8px;">Contact Customer Support</h1>
            <p style="color: var(--text-muted); margin-bottom: 32px;">Have questions? Reach out to our 24/7 dedicated support team.</p>

            <form action="#" method="POST" onsubmit="event.preventDefault(); showToast('Thank you! Your message has been sent.', 'success');">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Your Name</label>
                        <input type="text" class="form-control" placeholder="Your full name" required>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" class="form-control" placeholder="yourname@example.com" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" class="form-control" placeholder="Inquiry regarding transaction..." required>
                </div>
                <div class="form-group">
                    <label>Message</label>
                    <textarea class="form-control" rows="5" placeholder="Type your message here..." required></textarea>
                </div>
                <button type="submit" class="btn-primary" style="padding: 12px 32px;"><i class="ri-send-plane-line"></i> Send Message</button>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
