package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.PasswordUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirm password do not match.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isStrongPassword(newPassword)) {
            request.setAttribute("error", "New password does not meet strength requirements.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        try {
            String newHash = PasswordUtil.hashPassword(newPassword);
            boolean success = userDAO.updatePassword(user.getUserId(), newHash);
            if (success) {
                user.setPasswordHash(newHash);
                session.setAttribute("loggedUser", user);
                AuditLogDAO.logAction(user.getUsername(), "USER", "CHANGE_PASSWORD", "Successfully changed password", request.getRemoteAddr());
                request.setAttribute("success", "Password changed successfully.");
            } else {
                request.setAttribute("error", "Failed to update password.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }
}
