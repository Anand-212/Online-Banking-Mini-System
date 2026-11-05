package com.bank.filter;

import com.bank.model.Admin;
import com.bank.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/dashboard", "/deposit", "/withdraw", "/transfer", "/transactions", "/profile", "/change-password", "/set-mpin", "/admin/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();

        boolean isAdminRoute = uri.contains("/admin/") || uri.endsWith("/admin");
        boolean isAdminLoginRoute = uri.endsWith("/admin/login") || uri.endsWith("/admin-login.jsp");

        if (isAdminRoute && !isAdminLoginRoute) {
            Admin admin = (session != null) ? (Admin) session.getAttribute("loggedAdmin") : null;
            if (admin == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin-login.jsp?error=Unauthorized+access");
                return;
            }
        } else if (!isAdminRoute) {
            User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
            if (user == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Session+expired.+Please+login.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
