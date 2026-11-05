package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.NotificationDAO;
import com.bank.dao.TransactionDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.CSRFUtil;
import com.bank.util.MpinUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/withdraw")
public class WithdrawServlet extends HttpServlet {
    private TransactionDAO transactionDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User user = (User) session.getAttribute("loggedUser");
            try {
                User freshUser = userDAO.getUserById(user.getUserId());
                if (freshUser != null) {
                    session.setAttribute("loggedUser", freshUser);
                }
            } catch (Exception ignored) {}
        }
        request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!CSRFUtil.validateToken(request)) {
            request.setAttribute("error", "Security violation: Invalid CSRF Token.");
            request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        try {
            User freshUser = userDAO.getUserById(user.getUserId());
            if (freshUser != null) {
                user = freshUser;
                session.setAttribute("loggedUser", user);
            }
        } catch (Exception ignored) {}

        // 1. Check if user has an MPIN set
        if (!user.hasMpin()) {
            response.sendRedirect(request.getContextPath() + "/set-mpin?error=Please+configure+your+4-digit+MPIN+to+enable+withdrawals.");
            return;
        }

        // 2. Check if user is locked out
        if (user.isMpinLocked()) {
            long remaining = MpinUtil.getRemainingLockoutMinutes(user.getMpinLockoutUntil());
            request.setAttribute("error", "Withdrawals temporarily locked due to repeated incorrect MPIN attempts. Please wait " + remaining + " minute(s).");
            request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
            return;
        }

        String amountStr = request.getParameter("amount");
        String description = ValidationUtil.sanitizeInput(request.getParameter("description"));
        String mpin = request.getParameter("mpin");

        // 3. Validate MPIN Format
        if (!ValidationUtil.isValidMpin(mpin)) {
            request.setAttribute("error", "Security MPIN must be exactly 4 numeric digits.");
            request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
            return;
        }

        // 4. Verify MPIN using BCrypt
        if (!MpinUtil.verifyMpin(mpin, user.getMpinHash())) {
            try {
                int attempts = userDAO.recordFailedMpinAttempt(user.getUserId());
                AuditLogDAO.logAction(user.getUsername(), "USER", "MPIN_FAIL_WITHDRAW", "Failed MPIN attempt (" + attempts + ")", request.getRemoteAddr());
                int remainingAttempts = MpinUtil.MAX_FAILED_ATTEMPTS - attempts;

                if (remainingAttempts <= 0) {
                    request.setAttribute("error", "Incorrect MPIN. Withdrawals are now locked for 15 minutes.");
                } else {
                    request.setAttribute("error", "Incorrect MPIN. " + remainingAttempts + " attempt(s) remaining.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error validating security credentials.");
            }
            request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
            return;
        }

        // 5. Successful MPIN verification: reset attempts if any
        try {
            if (user.getMpinAttempts() > 0) {
                userDAO.resetMpinAttempts(user.getUserId());
            }
        } catch (Exception ignored) {}

        // 6. Execute withdrawal
        try {
            BigDecimal amount = new BigDecimal(amountStr);
            if (!ValidationUtil.isValidAmount(amount)) {
                request.setAttribute("error", "Withdrawal amount must be greater than zero.");
                request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
                return;
            }

            if (user.getBalance().compareTo(amount) < 0) {
                request.setAttribute("error", "Insufficient funds for withdrawal. Current Balance: Rs. " + user.getBalance());
                request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
                return;
            }

            boolean success = transactionDAO.withdraw(user.getAccountNumber(), amount, description);
            if (success) {
                User updatedUser = userDAO.getUserById(user.getUserId());
                session.setAttribute("loggedUser", updatedUser);
                NotificationDAO.createNotification(user.getUserId(), "Withdrawal Successful", "You withdrew Rs. " + amount + " from account " + user.getAccountNumber());
                AuditLogDAO.logAction(user.getUsername(), "USER", "WITHDRAWAL", "Withdrew Rs. " + amount + " with MPIN verification", request.getRemoteAddr());

                request.setAttribute("success", "Successfully withdrew Rs. " + amount + ". New Balance: Rs. " + updatedUser.getBalance());
            } else {
                request.setAttribute("error", "Withdrawal failed. Please try again.");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/withdraw.jsp").forward(request, response);
    }
}
