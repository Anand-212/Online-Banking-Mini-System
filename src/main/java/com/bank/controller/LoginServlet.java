package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.getUserByUsername(username);

            if (user == null || !PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                AuditLogDAO.logAction(username, "USER", "LOGIN_FAILED", "Invalid credentials", request.getRemoteAddr());
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            if ("FROZEN".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("error", "Your account has been frozen. Please contact customer support.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setMaxInactiveInterval(1800); // 30 mins
            CSRFUtil.generateToken(session);

            userDAO.updateLastLogin(user.getUserId());
            AuditLogDAO.logAction(username, "USER", "LOGIN_SUCCESS", "User logged in successfully", request.getRemoteAddr());

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during login", e);
            request.setAttribute("error", "Database connection error. Ensure Oracle XE is running.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
