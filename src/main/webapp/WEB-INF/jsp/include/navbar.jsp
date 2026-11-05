<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo">
        <i class="ri-bank-line"></i> EasyBank
    </a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/about.jsp">About Us</a></li>
        <li><a href="${pageContext.request.contextPath}/services.jsp">Services</a></li>
        <li><a href="${pageContext.request.contextPath}/calculators.jsp">Financial Calculators</a></li>
        <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
        
        <c:choose>
            <c:when test="${not empty sessionScope.loggedUser}">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="btn-primary">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </c:when>
            <c:when test="${not empty sessionScope.loggedAdmin}">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-primary">Admin Console</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp" class="btn-primary">Open Account</a></li>
            </c:otherwise>
        </c:choose>
        <li>
            <button class="theme-toggle" id="themeToggleBtn" title="Toggle Theme">
                <i class="ri-moon-line" id="themeIcon"></i>
            </button>
        </li>
    </ul>
</nav>
