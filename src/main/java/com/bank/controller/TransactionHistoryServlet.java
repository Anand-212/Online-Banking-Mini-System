package com.bank.controller;

import com.bank.dao.TransactionDAO;
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

@WebServlet("/transactions")
public class TransactionHistoryServlet extends HttpServlet {
    private TransactionDAO transactionDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        String txType = request.getParameter("type");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String search = request.getParameter("search");

        try {
            List<Transaction> transactions = transactionDAO.getFilteredTransactions(user.getAccountNumber(), txType, startDate, endDate, search);
            request.setAttribute("transactions", transactions);
            request.setAttribute("txType", txType);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("search", search);

            request.getRequestDispatcher("/transactions.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving transaction history: " + e.getMessage());
            request.getRequestDispatcher("/transactions.jsp").forward(request, response);
        }
    }
}
