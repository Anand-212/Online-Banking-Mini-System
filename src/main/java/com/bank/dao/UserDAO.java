package com.bank.dao;

import com.bank.model.User;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USERS WHERE LOWER(username) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USERS WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public String generateAccountNumber() throws SQLException {
        String sql = "SELECT ACCOUNT_SEQ.NEXTVAL FROM DUAL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return String.valueOf(rs.getLong(1));
            }
        }
        return String.valueOf(System.currentTimeMillis());
    }

    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO USERS (user_id, account_number, full_name, username, email, password_hash, mpin_hash, mpin_attempts, mobile_number, dob, gender, address, account_type_id, balance, status) " +
                     "VALUES (USER_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getAccountNumber());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getUsername());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPasswordHash());
            ps.setString(6, user.getMpinHash());
            ps.setString(7, user.getMobileNumber());
            ps.setDate(8, user.getDob());
            ps.setString(9, user.getGender());
            ps.setString(10, user.getAddress());
            ps.setInt(11, user.getAccountTypeId());
            ps.setBigDecimal(12, user.getBalance() != null ? user.getBalance() : BigDecimal.ZERO);

            return ps.executeUpdate() > 0;
        }
    }

    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT u.*, a.type_name FROM USERS u JOIN ACCOUNT_TYPES a ON u.account_type_id = a.type_id WHERE LOWER(u.username) = LOWER(?) AND u.status != 'DELETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public User getUserByAccountNumber(String accountNumber) throws SQLException {
        String sql = "SELECT u.*, a.type_name FROM USERS u JOIN ACCOUNT_TYPES a ON u.account_type_id = a.type_id WHERE u.account_number = ? AND u.status != 'DELETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public User getUserById(Long userId) throws SQLException {
        String sql = "SELECT u.*, a.type_name FROM USERS u JOIN ACCOUNT_TYPES a ON u.account_type_id = a.type_id WHERE u.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public boolean updateLastLogin(Long userId) {
        String sql = "UPDATE USERS SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to update last login", e);
            return false;
        }
    }

    public boolean updateProfile(Long userId, String email, String mobileNumber, String address) throws SQLException {
        String sql = "UPDATE USERS SET email = ?, mobile_number = ?, address = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, mobileNumber);
            ps.setString(3, address);
            ps.setLong(4, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(Long userId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE USERS SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateMpin(Long userId, String mpinHash) throws SQLException {
        String sql = "UPDATE USERS SET mpin_hash = ?, mpin_attempts = 0, mpin_lockout_until = NULL WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, mpinHash);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public int recordFailedMpinAttempt(Long userId) throws SQLException {
        String incSql = "UPDATE USERS SET mpin_attempts = mpin_attempts + 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(incSql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }

        int attempts = 0;
        String querySql = "SELECT mpin_attempts FROM USERS WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(querySql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    attempts = rs.getInt(1);
                }
            }
        }

        if (attempts >= 3) {
            String lockSql = "UPDATE USERS SET mpin_lockout_until = CURRENT_TIMESTAMP + INTERVAL '15' MINUTE WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setLong(1, userId);
                ps.executeUpdate();
            }
        }
        return attempts;
    }

    public boolean resetMpinAttempts(Long userId) throws SQLException {
        String sql = "UPDATE USERS SET mpin_attempts = 0, mpin_lockout_until = NULL WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateUserStatus(Long userId, String status) throws SQLException {
        String sql = "UPDATE USERS SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsers(String searchQuery, String statusFilter) throws SQLException {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT u.*, a.type_name FROM USERS u JOIN ACCOUNT_TYPES a ON u.account_type_id = a.type_id WHERE u.status != 'DELETED' ");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (LOWER(u.full_name) LIKE ? OR LOWER(u.username) LIKE ? OR u.account_number LIKE ? OR LOWER(u.email) LIKE ?) ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND u.status = ? ");
        }
        sql.append("ORDER BY u.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String term = "%" + searchQuery.trim().toLowerCase() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.toUpperCase());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        }
        return list;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getLong("user_id"));
        u.setAccountNumber(rs.getString("account_number"));
        u.setFullName(rs.getString("full_name"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setMpinHash(rs.getString("mpin_hash"));
        u.setMpinAttempts(rs.getInt("mpin_attempts"));
        u.setMpinLockoutUntil(rs.getTimestamp("mpin_lockout_until"));
        u.setMobileNumber(rs.getString("mobile_number"));
        u.setDob(rs.getDate("dob"));
        u.setGender(rs.getString("gender"));
        u.setAddress(rs.getString("address"));
        u.setAccountTypeId(rs.getInt("account_type_id"));
        u.setAccountTypeName(rs.getString("type_name"));
        u.setBalance(rs.getBigDecimal("balance"));
        u.setStatus(rs.getString("status"));
        u.setProfilePhoto(rs.getString("profile_photo"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setLastLogin(rs.getTimestamp("last_login"));
        return u;
    }
}
