package com.bank.controller;

import com.bank.dao.AdminDAO;
import com.bank.dao.AuditLogDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Map<String, Object> stats = adminDAO.getDashboardStatistics();
            request.setAttribute("stats", stats);
            request.setAttribute("recentLogs", auditLogDAO.getRecentLogs(10));

            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading admin statistics: " + e.getMessage());
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        }
    }
}
