package com.bank.dao;

import com.bank.model.AuditLog;
import com.bank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public static void logAction(String performedBy, String role, String action, String details, String ipAddress) {
        String sql = "INSERT INTO AUDIT_LOG (log_id, performed_by, role, action, details, ip_address) " +
                     "VALUES (AUDIT_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, performedBy);
            ps.setString(2, role);
            ps.setString(3, action);
            ps.setString(4, details);
            ps.setString(5, ipAddress);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<AuditLog> getRecentLogs(int limit) throws SQLException {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT * FROM AUDIT_LOG ORDER BY created_at DESC) WHERE ROWNUM <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = new AuditLog();
                    log.setLogId(rs.getLong("log_id"));
                    log.setPerformedBy(rs.getString("performed_by"));
                    log.setRole(rs.getString("role"));
                    log.setAction(rs.getString("action"));
                    log.setDetails(rs.getString("details"));
                    log.setIpAddress(rs.getString("ip_address"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(log);
                }
            }
        }
        return list;
    }
}
