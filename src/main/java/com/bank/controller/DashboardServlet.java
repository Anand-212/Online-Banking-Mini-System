package com.bank.controller;

import com.bank.dao.NotificationDAO;
import com.bank.dao.TransactionDAO;
import com.bank.dao.UserDAO;
import com.bank.model.Notification;
import com.bank.model.Transaction;
import com.bank.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private UserDAO userDAO;
    private TransactionDAO transactionDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        transactionDAO = new TransactionDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        try {
            // Refresh user details from DB
            User currentUser = userDAO.getUserById(loggedUser.getUserId());
            session.setAttribute("loggedUser", currentUser);

            List<Transaction> recentTransactions = transactionDAO.getUserRecentTransactions(currentUser.getAccountNumber(), 5);
            int totalTransactions = transactionDAO.getUserTransactionCount(currentUser.getAccountNumber());
            List<Notification> notifications = notificationDAO.getUserNotifications(currentUser.getUserId());

            request.setAttribute("recentTransactions", recentTransactions);
            request.setAttribute("totalTransactions", totalTransactions);
            request.setAttribute("notifications", notifications);

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
}
