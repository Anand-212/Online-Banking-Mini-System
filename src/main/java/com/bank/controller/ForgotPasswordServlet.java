package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.OTPUtil;
import com.bank.util.PasswordUtil;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(true);

        if ("sendOtp".equals(action)) {
            String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
            try {
                User user = userDAO.getUserByUsername(username);
                if (user == null) {
                    request.setAttribute("error", "Username not found.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                String otp = OTPUtil.generateOTP();
                session.setAttribute("resetOtp", otp);
                session.setAttribute("resetUser", user);

                AuditLogDAO.logAction(username, "USER", "OTP_REQUEST", "Requested password reset OTP: " + otp, request.getRemoteAddr());
                request.setAttribute("simulatedOtp", otp);
                request.setAttribute("step", "verifyOtp");
                request.setAttribute("success", "Simulated OTP sent! Security Code: " + otp);

            } catch (Exception e) {
                request.setAttribute("error", "Error processing request: " + e.getMessage());
            }
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } else if ("resetPassword".equals(action)) {
            String enteredOtp = request.getParameter("otp");
            String newPassword = request.getParameter("newPassword");
            String sessionOtp = (String) session.getAttribute("resetOtp");
            User resetUser = (User) session.getAttribute("resetUser");

            if (sessionOtp == null || !sessionOtp.equals(enteredOtp)) {
                request.setAttribute("error", "Invalid or expired OTP code.");
                request.setAttribute("step", "verifyOtp");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            if (!ValidationUtil.isStrongPassword(newPassword)) {
                request.setAttribute("error", "New password does not meet strength requirements.");
                request.setAttribute("step", "verifyOtp");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            try {
                String newHash = PasswordUtil.hashPassword(newPassword);
                userDAO.updatePassword(resetUser.getUserId(), newHash);
                session.removeAttribute("resetOtp");
                session.removeAttribute("resetUser");

                AuditLogDAO.logAction(resetUser.getUsername(), "USER", "RESET_PASSWORD", "Password reset using OTP", request.getRemoteAddr());
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=Password+reset+successful!+Please+login.");
            } catch (Exception e) {
                request.setAttribute("error", "Error updating password: " + e.getMessage());
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }
        }
    }
}
