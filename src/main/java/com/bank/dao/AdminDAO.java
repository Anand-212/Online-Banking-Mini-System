package com.bank.dao;

import com.bank.model.Admin;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class AdminDAO {

    public Admin getAdminByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM ADMINS WHERE LOWER(username) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getLong("admin_id"));
                    a.setUsername(rs.getString("username"));
                    a.setEmail(rs.getString("email"));
                    a.setPasswordHash(rs.getString("password_hash"));
                    a.setFullName(rs.getString("full_name"));
                    a.setRole(rs.getString("role"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    return a;
                }
            }
        }
        return null;
    }

    public Map<String, Object> getDashboardStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            
            // Total Active Users
            String sqlUserCount = "SELECT COUNT(*) FROM USERS WHERE status = 'ACTIVE'";
            try (PreparedStatement ps = conn.prepareStatement(sqlUserCount);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalActiveUsers", rs.getInt(1));
            }

            // Total Deposits
            String sqlDeposits = "SELECT NVL(SUM(amount), 0) FROM TRANSACTIONS WHERE transaction_type = 'DEPOSIT' AND status = 'SUCCESS'";
            try (PreparedStatement ps = conn.prepareStatement(sqlDeposits);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalDeposits", rs.getBigDecimal(1));
            }

            // Total Withdrawals
            String sqlWithdrawals = "SELECT NVL(SUM(amount), 0) FROM TRANSACTIONS WHERE transaction_type = 'WITHDRAWAL' AND status = 'SUCCESS'";
            try (PreparedStatement ps = conn.prepareStatement(sqlWithdrawals);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalWithdrawals", rs.getBigDecimal(1));
            }

            // Total Transfers
            String sqlTransfers = "SELECT NVL(SUM(amount), 0) FROM TRANSACTIONS WHERE transaction_type = 'TRANSFER' AND status = 'SUCCESS'";
            try (PreparedStatement ps = conn.prepareStatement(sqlTransfers);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalTransfers", rs.getBigDecimal(1));
            }

            // Today's Transactions Count
            String sqlTodayCount = "SELECT COUNT(*) FROM TRANSACTIONS WHERE TRUNC(transaction_date) = TRUNC(SYSDATE)";
            try (PreparedStatement ps = conn.prepareStatement(sqlTodayCount);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("todayTxCount", rs.getInt(1));
            }

            // Total Bank Holdings Balance
            String sqlTotalHoldings = "SELECT NVL(SUM(balance), 0) FROM USERS WHERE status != 'DELETED'";
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalHoldings);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) stats.put("totalHoldings", rs.getBigDecimal(1));
            }
        }
        return stats;
    }
}
