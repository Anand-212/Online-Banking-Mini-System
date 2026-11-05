package com.bank.controller;

import com.bank.dao.TransactionDAO;
import com.bank.model.Transaction;
import com.bank.model.User;
import com.bank.util.PdfExportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/export-pdf")
public class ExportPdfServlet extends HttpServlet {
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

        try {
            List<Transaction> transactions = transactionDAO.getFilteredTransactions(user.getAccountNumber(), txType, startDate, endDate, null);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Account_Statement_" + user.getAccountNumber() + ".pdf\"");

            PdfExportService.generateTransactionHistoryPdf(user, transactions, response.getOutputStream());
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/transactions?error=Failed+to+generate+PDF+statement.");
        }
    }
}
