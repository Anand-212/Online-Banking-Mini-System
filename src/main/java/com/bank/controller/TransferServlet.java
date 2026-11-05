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

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {
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
        request.getRequestDispatcher("/transfer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!CSRFUtil.validateToken(request)) {
            request.setAttribute("error", "Security violation: Invalid CSRF Token.");
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User sender = (User) session.getAttribute("loggedUser");

        try {
            User freshUser = userDAO.getUserById(sender.getUserId());
            if (freshUser != null) {
                sender = freshUser;
                session.setAttribute("loggedUser", sender);
            }
        } catch (Exception ignored) {}

        // 1. Check if user has an MPIN set
        if (!sender.hasMpin()) {
            response.sendRedirect(request.getContextPath() + "/set-mpin?error=Please+configure+your+4-digit+MPIN+to+enable+transfers.");
            return;
        }

        // 2. Check if user is locked out
        if (sender.isMpinLocked()) {
            long remaining = MpinUtil.getRemainingLockoutMinutes(sender.getMpinLockoutUntil());
            request.setAttribute("error", "Transfers temporarily locked due to repeated incorrect MPIN attempts. Please wait " + remaining + " minute(s).");
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        String receiverAccount = ValidationUtil.sanitizeInput(request.getParameter("receiverAccount"));
        String amountStr = request.getParameter("amount");
        String description = ValidationUtil.sanitizeInput(request.getParameter("description"));
        String mpin = request.getParameter("mpin");

        // 3. Validate MPIN Format
        if (!ValidationUtil.isValidMpin(mpin)) {
            request.setAttribute("error", "Security MPIN must be exactly 4 numeric digits.");
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        // 4. Verify MPIN using BCrypt
        if (!MpinUtil.verifyMpin(mpin, sender.getMpinHash())) {
            try {
                int attempts = userDAO.recordFailedMpinAttempt(sender.getUserId());
                AuditLogDAO.logAction(sender.getUsername(), "USER", "MPIN_FAIL_TRANSFER", "Failed MPIN attempt (" + attempts + ")", request.getRemoteAddr());
                int remainingAttempts = MpinUtil.MAX_FAILED_ATTEMPTS - attempts;

                if (remainingAttempts <= 0) {
                    request.setAttribute("error", "Incorrect MPIN. Fund transfers are now locked for 15 minutes.");
                } else {
                    request.setAttribute("error", "Incorrect MPIN. " + remainingAttempts + " attempt(s) remaining.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error validating security credentials.");
            }
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        // 5. Successful MPIN verification: reset attempts if any
        try {
            if (sender.getMpinAttempts() > 0) {
                userDAO.resetMpinAttempts(sender.getUserId());
            }
        } catch (Exception ignored) {}

        // 6. Business logic validations
        if (receiverAccount == null || receiverAccount.trim().isEmpty()) {
            request.setAttribute("error", "Receiver account number is required.");
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        if (sender.getAccountNumber().equalsIgnoreCase(receiverAccount)) {
            request.setAttribute("error", "You cannot transfer money to your own account.");
            request.getRequestDispatcher("/transfer.jsp").forward(request, response);
            return;
        }

        try {
            BigDecimal amount = new BigDecimal(amountStr);
            if (!ValidationUtil.isValidAmount(amount)) {
                request.setAttribute("error", "Transfer amount must be greater than zero.");
                request.getRequestDispatcher("/transfer.jsp").forward(request, response);
                return;
            }

            // Verify receiver exists
            User receiver = userDAO.getUserByAccountNumber(receiverAccount);
            if (receiver == null) {
                request.setAttribute("error", "Receiver account number does not exist.");
                request.getRequestDispatcher("/transfer.jsp").forward(request, response);
                return;
            }

            if (sender.getBalance().compareTo(amount) < 0) {
                request.setAttribute("error", "Insufficient balance to transfer Rs. " + amount);
                request.getRequestDispatcher("/transfer.jsp").forward(request, response);
                return;
            }

            boolean success = transactionDAO.transferMoney(sender.getAccountNumber(), receiverAccount, amount, description);
            if (success) {
                User updatedSender = userDAO.getUserById(sender.getUserId());
                session.setAttribute("loggedUser", updatedSender);

                NotificationDAO.createNotification(sender.getUserId(), "Transfer Sent", "Sent Rs. " + amount + " to account " + receiverAccount);
                NotificationDAO.createNotification(receiver.getUserId(), "Transfer Received", "Received Rs. " + amount + " from account " + sender.getAccountNumber());
                AuditLogDAO.logAction(sender.getUsername(), "USER", "TRANSFER", "Transferred Rs. " + amount + " to " + receiverAccount + " with MPIN verification", request.getRemoteAddr());

                request.setAttribute("success", "Successfully transferred Rs. " + amount + " to " + receiver.getFullName() + " (" + receiverAccount + ").");
            } else {
                request.setAttribute("error", "Transfer failed due to a system error.");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/transfer.jsp").forward(request, response);
    }
}
