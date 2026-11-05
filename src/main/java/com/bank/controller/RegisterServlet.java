package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.NotificationDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.MpinUtil;
import com.bank.util.PasswordUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = ValidationUtil.sanitizeInput(request.getParameter("fullName"));
        String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String mpin = request.getParameter("mpin");
        String confirmMpin = request.getParameter("confirmMpin");
        String email = ValidationUtil.sanitizeInput(request.getParameter("email"));
        String mobileNumber = ValidationUtil.sanitizeInput(request.getParameter("mobileNumber"));
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String address = ValidationUtil.sanitizeInput(request.getParameter("address"));
        String accountTypeIdStr = request.getParameter("accountTypeId");
        String initialDepositStr = request.getParameter("initialDeposit");

        // Validations
        if (!ValidationUtil.isValidUsername(username)) {
            request.setAttribute("error", "Username must be 4-30 alphanumeric characters.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please provide a valid email address.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidMobile(mobileNumber)) {
            request.setAttribute("error", "Mobile number must be between 10 and 15 digits.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isStrongPassword(password)) {
            request.setAttribute("error", "Password must be 8+ chars, with uppercase, lowercase, digit, and special char.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidMpin(mpin)) {
            request.setAttribute("error", "MPIN must be exactly 4 numeric digits.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (mpin == null || !mpin.equals(confirmMpin)) {
            request.setAttribute("error", "4-digit MPIN and Confirm MPIN do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("error", "Username is already taken.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email is already registered.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            BigDecimal initialDeposit = new BigDecimal(initialDepositStr);
            int accountTypeId = Integer.parseInt(accountTypeIdStr);

            // Min balance validation
            BigDecimal minBalance = (accountTypeId == 1) ? new BigDecimal("500.00") : new BigDecimal("1000.00");
            if (initialDeposit.compareTo(minBalance) < 0) {
                request.setAttribute("error", "Initial deposit must be at least Rs. " + minBalance + " for this account type.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            String accountNumber = userDAO.generateAccountNumber();
            String passwordHash = PasswordUtil.hashPassword(password);
            String mpinHash = MpinUtil.hashMpin(mpin);

            User user = new User();
            user.setAccountNumber(accountNumber);
            user.setFullName(fullName);
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(passwordHash);
            user.setMpinHash(mpinHash);
            user.setMpinAttempts(0);
            user.setMobileNumber(mobileNumber);
            user.setDob(Date.valueOf(dobStr));
            user.setGender(gender);
            user.setAddress(address);
            user.setAccountTypeId(accountTypeId);
            user.setBalance(initialDeposit);

            boolean success = userDAO.registerUser(user);

            if (success) {
                User registeredUser = userDAO.getUserByUsername(username);
                if (registeredUser != null) {
                    NotificationDAO.createNotification(registeredUser.getUserId(), "Welcome to Online Banking", "Account Created Successfully! Account Number: " + accountNumber + ". Your 4-digit security MPIN is active.");
                }
                AuditLogDAO.logAction(username, "USER", "REGISTER", "Created new account: " + accountNumber + " with MPIN security", request.getRemoteAddr());
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=Account+Created+Successfully!+Your+Account+Number+is:+" + accountNumber);
            } else {
                request.setAttribute("error", "Failed to create account. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during registration", e);
            request.setAttribute("error", "An internal error occurred: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
