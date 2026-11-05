package com.bank.controller;

import com.bank.dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Map<String, Object> stats = adminDAO.getDashboardStatistics();
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/admin-reports.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error generating monthly report: " + e.getMessage());
            request.getRequestDispatcher("/admin-reports.jsp").forward(request, response);
        }
    }
}
