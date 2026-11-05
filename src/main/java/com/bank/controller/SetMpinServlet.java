package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.NotificationDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.CSRFUtil;
import com.bank.util.MpinUtil;
import com.bank.util.PasswordUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/set-mpin")
public class SetMpinServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SetMpinServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+login+first.");
            return;
        }
        request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!CSRFUtil.validateToken(request)) {
            request.setAttribute("error", "Security violation: Invalid CSRF Token.");
            request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session+expired.");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String currentPassword = request.getParameter("currentPassword");
        String currentMpin = request.getParameter("currentMpin");
        String newMpin = request.getParameter("newMpin");
        String confirmMpin = request.getParameter("confirmMpin");

        boolean hasExistingMpin = user.hasMpin();

        // Verification of existing identity
        if (hasExistingMpin) {
            boolean verified = false;
            if (currentMpin != null && !currentMpin.trim().isEmpty()) {
                verified = MpinUtil.verifyMpin(currentMpin, user.getMpinHash());
            } else if (currentPassword != null && !currentPassword.trim().isEmpty()) {
                verified = PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash());
            }

            if (!verified) {
                request.setAttribute("error", "Current MPIN or account password is incorrect.");
                request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
                return;
            }
        } else {
            // Initial setup requires account login password verification
            if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
                request.setAttribute("error", "Account login password is incorrect.");
                request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
                return;
            }
        }

        // Validate new MPIN format
        if (!ValidationUtil.isValidMpin(newMpin)) {
            request.setAttribute("error", "New MPIN must be exactly 4 numeric digits.");
            request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
            return;
        }

        if (newMpin == null || !newMpin.equals(confirmMpin)) {
            request.setAttribute("error", "New MPIN and Confirm MPIN do not match.");
            request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
            return;
        }

        try {
            String newMpinHash = MpinUtil.hashMpin(newMpin);
            boolean updated = userDAO.updateMpin(user.getUserId(), newMpinHash);

            if (updated) {
                User updatedUser = userDAO.getUserById(user.getUserId());
                session.setAttribute("loggedUser", updatedUser);

                NotificationDAO.createNotification(user.getUserId(), "Security Update", "Your 4-digit transaction MPIN was configured successfully.");
                AuditLogDAO.logAction(user.getUsername(), "USER", "SET_MPIN", "Updated 4-digit security MPIN", request.getRemoteAddr());

                request.setAttribute("success", "4-Digit Transaction MPIN updated successfully! You can now securely perform transactions.");
            } else {
                request.setAttribute("error", "Failed to update MPIN. Please try again.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error setting MPIN", e);
            request.setAttribute("error", "A database error occurred: " + e.getMessage());
        }

        request.getRequestDispatcher("/set-mpin.jsp").forward(request, response);
    }
}
