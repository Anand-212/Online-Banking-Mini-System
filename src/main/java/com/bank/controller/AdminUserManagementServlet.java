package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.NotificationDAO;
import com.bank.dao.UserDAO;
import com.bank.model.Admin;
import com.bank.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserManagementServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        try {
            List<User> users = userDAO.getAllUsers(search, status);
            request.setAttribute("users", users);
            request.setAttribute("search", search);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching user directory: " + e.getMessage());
            request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Admin admin = (Admin) session.getAttribute("loggedAdmin");

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        try {
            Long userId = Long.parseLong(userIdStr);
            User user = userDAO.getUserById(userId);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=User+not+found");
                return;
            }

            if ("freeze".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(userId, "FROZEN");
                NotificationDAO.createNotification(userId, "Account Frozen", "Your bank account has been frozen by administration.");
                AuditLogDAO.logAction(admin.getUsername(), "ADMIN", "FREEZE_USER", "Frozen account: " + user.getAccountNumber(), request.getRemoteAddr());
                response.sendRedirect(request.getContextPath() + "/admin/users?success=User+account+frozen+successfully.");

            } else if ("activate".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(userId, "ACTIVE");
                NotificationDAO.createNotification(userId, "Account Activated", "Your bank account has been re-activated by administration.");
                AuditLogDAO.logAction(admin.getUsername(), "ADMIN", "ACTIVATE_USER", "Activated account: " + user.getAccountNumber(), request.getRemoteAddr());
                response.sendRedirect(request.getContextPath() + "/admin/users?success=User+account+activated+successfully.");

            } else if ("delete".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(userId, "DELETED");
                AuditLogDAO.logAction(admin.getUsername(), "ADMIN", "DELETE_USER", "Deleted account: " + user.getAccountNumber(), request.getRemoteAddr());
                response.sendRedirect(request.getContextPath() + "/admin/users?success=User+account+deleted.");
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Operation+failed:+" + e.getMessage());
        }
    }
}
