package com.bank.controller;

import com.bank.dao.AdminDAO;
import com.bank.dao.AuditLogDAO;
import com.bank.model.Admin;
import com.bank.util.CSRFUtil;
import com.bank.util.PasswordUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
        String password = request.getParameter("password");

        try {
            Admin admin = adminDAO.getAdminByUsername(username);

            if (admin == null || !PasswordUtil.verifyPassword(password, admin.getPasswordHash())) {
                AuditLogDAO.logAction(username, "ADMIN", "LOGIN_FAILED", "Invalid admin credentials", request.getRemoteAddr());
                request.setAttribute("error", "Invalid admin credentials.");
                request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("loggedAdmin", admin);
            session.setMaxInactiveInterval(1800);
            CSRFUtil.generateToken(session);

            AuditLogDAO.logAction(username, "ADMIN", "LOGIN_SUCCESS", "Admin authenticated", request.getRemoteAddr());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        }
    }
}
