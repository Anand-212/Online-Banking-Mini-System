package com.bank.controller;

import com.bank.dao.AuditLogDAO;
import com.bank.dao.UserDAO;
import com.bank.model.User;
import com.bank.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        String email = ValidationUtil.sanitizeInput(request.getParameter("email"));
        String mobileNumber = ValidationUtil.sanitizeInput(request.getParameter("mobileNumber"));
        String address = ValidationUtil.sanitizeInput(request.getParameter("address"));

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidMobile(mobileNumber)) {
            request.setAttribute("error", "Invalid mobile number.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        try {
            boolean success = userDAO.updateProfile(user.getUserId(), email, mobileNumber, address);
            if (success) {
                User updatedUser = userDAO.getUserById(user.getUserId());
                session.setAttribute("loggedUser", updatedUser);
                AuditLogDAO.logAction(user.getUsername(), "USER", "UPDATE_PROFILE", "Updated profile details", request.getRemoteAddr());
                request.setAttribute("success", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
        }
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
