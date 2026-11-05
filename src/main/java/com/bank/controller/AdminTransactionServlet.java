package com.bank.controller;

import com.bank.dao.TransactionDAO;
import com.bank.model.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/transactions")
public class AdminTransactionServlet extends HttpServlet {
    private TransactionDAO transactionDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Transaction> transactions = transactionDAO.getAllTransactions();
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/admin-transactions.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching system transactions: " + e.getMessage());
            request.getRequestDispatcher("/admin-transactions.jsp").forward(request, response);
        }
    }
}
