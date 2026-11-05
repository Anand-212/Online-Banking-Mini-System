package com.bank.dao;

import com.bank.model.Transaction;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public String generateTxId() throws SQLException {
        String sql = "SELECT TX_SEQ.NEXTVAL FROM DUAL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return "TX" + rs.getLong(1);
            }
        }
        return "TX" + System.currentTimeMillis();
    }

    public boolean deposit(String accountNumber, BigDecimal amount, String description) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Fetch current balance
            BigDecimal currentBalance = BigDecimal.ZERO;
            String lockSql = "SELECT balance FROM USERS WHERE account_number = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setString(1, accountNumber);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentBalance = rs.getBigDecimal("balance");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            BigDecimal newBalance = currentBalance.add(amount);

            // Update user balance
            String updateSql = "UPDATE USERS SET balance = ? WHERE account_number = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, newBalance);
                ps.setString(2, accountNumber);
                ps.executeUpdate();
            }

            // Insert transaction record
            String txId = generateTxId();
            String txSql = "INSERT INTO TRANSACTIONS (transaction_id, receiver_account, transaction_type, amount, receiver_closing_balance, description, status) " +
                           "VALUES (?, ?, 'DEPOSIT', ?, ?, ?, 'SUCCESS')";
            try (PreparedStatement ps = conn.prepareStatement(txSql)) {
                ps.setString(1, txId);
                ps.setString(2, accountNumber);
                ps.setBigDecimal(3, amount);
                ps.setBigDecimal(4, newBalance);
                ps.setString(5, description != null ? description : "Account Deposit");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                DBConnection.close(conn);
            }
        }
    }

    public boolean withdraw(String accountNumber, BigDecimal amount, String description) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            BigDecimal currentBalance = BigDecimal.ZERO;
            String lockSql = "SELECT balance FROM USERS WHERE account_number = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setString(1, accountNumber);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentBalance = rs.getBigDecimal("balance");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            if (currentBalance.compareTo(amount) < 0) {
                conn.rollback();
                throw new SQLException("Insufficient balance for withdrawal.");
            }

            BigDecimal newBalance = currentBalance.subtract(amount);

            String updateSql = "UPDATE USERS SET balance = ? WHERE account_number = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, newBalance);
                ps.setString(2, accountNumber);
                ps.executeUpdate();
            }

            String txId = generateTxId();
            String txSql = "INSERT INTO TRANSACTIONS (transaction_id, sender_account, transaction_type, amount, sender_closing_balance, description, status) " +
                           "VALUES (?, ?, 'WITHDRAWAL', ?, ?, ?, 'SUCCESS')";
            try (PreparedStatement ps = conn.prepareStatement(txSql)) {
                ps.setString(1, txId);
                ps.setString(2, accountNumber);
                ps.setBigDecimal(3, amount);
                ps.setBigDecimal(4, newBalance);
                ps.setString(5, description != null ? description : "Account Withdrawal");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                DBConnection.close(conn);
            }
        }
    }

    public boolean transferMoney(String senderAccount, String receiverAccount, BigDecimal amount, String description) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Lock sender account
            BigDecimal senderBalance = BigDecimal.ZERO;
            String senderLockSql = "SELECT balance, status FROM USERS WHERE account_number = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(senderLockSql)) {
                ps.setString(1, senderAccount);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if ("FROZEN".equalsIgnoreCase(rs.getString("status"))) {
                            conn.rollback();
                            throw new SQLException("Sender account is frozen.");
                        }
                        senderBalance = rs.getBigDecimal("balance");
                    } else {
                        conn.rollback();
                        throw new SQLException("Sender account not found.");
                    }
                }
            }

            if (senderBalance.compareTo(amount) < 0) {
                conn.rollback();
                throw new SQLException("Insufficient balance.");
            }

            // Lock receiver account
            BigDecimal receiverBalance = BigDecimal.ZERO;
            String receiverLockSql = "SELECT balance, status FROM USERS WHERE account_number = ? FOR UPDATE";
            try (PreparedStatement ps = conn.prepareStatement(receiverLockSql)) {
                ps.setString(1, receiverAccount);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if ("FROZEN".equalsIgnoreCase(rs.getString("status"))) {
                            conn.rollback();
                            throw new SQLException("Receiver account is frozen.");
                        }
                        receiverBalance = rs.getBigDecimal("balance");
                    } else {
                        conn.rollback();
                        throw new SQLException("Receiver account not found.");
                    }
                }
            }

            BigDecimal newSenderBalance = senderBalance.subtract(amount);
            BigDecimal newReceiverBalance = receiverBalance.add(amount);

            // Debit sender
            String debitSql = "UPDATE USERS SET balance = ? WHERE account_number = ?";
            try (PreparedStatement ps = conn.prepareStatement(debitSql)) {
                ps.setBigDecimal(1, newSenderBalance);
                ps.setString(2, senderAccount);
                ps.executeUpdate();
            }

            // Credit receiver
            String creditSql = "UPDATE USERS SET balance = ? WHERE account_number = ?";
            try (PreparedStatement ps = conn.prepareStatement(creditSql)) {
                ps.setBigDecimal(1, newReceiverBalance);
                ps.setString(2, receiverAccount);
                ps.executeUpdate();
            }

            // Record Transfer Transaction
            String txId = generateTxId();
            String txSql = "INSERT INTO TRANSACTIONS (transaction_id, sender_account, receiver_account, transaction_type, amount, sender_closing_balance, receiver_closing_balance, description, status) " +
                           "VALUES (?, ?, ?, 'TRANSFER', ?, ?, ?, ?, 'SUCCESS')";
            try (PreparedStatement ps = conn.prepareStatement(txSql)) {
                ps.setString(1, txId);
                ps.setString(2, senderAccount);
                ps.setString(3, receiverAccount);
                ps.setBigDecimal(4, amount);
                ps.setBigDecimal(5, newSenderBalance);
                ps.setBigDecimal(6, newReceiverBalance);
                ps.setString(7, description != null ? description : "Fund Transfer");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                DBConnection.close(conn);
            }
        }
    }

    public List<Transaction> getUserRecentTransactions(String accountNumber, int limit) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT t.*, u1.full_name as sender_name, u2.full_name as receiver_name " +
                     "FROM TRANSACTIONS t " +
                     "LEFT JOIN USERS u1 ON t.sender_account = u1.account_number " +
                     "LEFT JOIN USERS u2 ON t.receiver_account = u2.account_number " +
                     "WHERE t.sender_account = ? OR t.receiver_account = ? " +
                     "ORDER BY t.transaction_date DESC) WHERE ROWNUM <= ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            ps.setString(2, accountNumber);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransaction(rs));
                }
            }
        }
        return list;
    }

    public List<Transaction> getFilteredTransactions(String accountNumber, String txType, String startDate, String endDate, String search) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, u1.full_name as sender_name, u2.full_name as receiver_name " +
                "FROM TRANSACTIONS t " +
                "LEFT JOIN USERS u1 ON t.sender_account = u1.account_number " +
                "LEFT JOIN USERS u2 ON t.receiver_account = u2.account_number " +
                "WHERE (t.sender_account = ? OR t.receiver_account = ?) ");

        if (txType != null && !txType.trim().isEmpty() && !"ALL".equalsIgnoreCase(txType)) {
            sql.append("AND t.transaction_type = ? ");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND t.transaction_date >= TO_TIMESTAMP(?, 'YYYY-MM-DD') ");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND t.transaction_date <= TO_TIMESTAMP(? || ' 23:59:59', 'YYYY-MM-DD HH24:MI:SS') ");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(t.transaction_id) LIKE ? OR LOWER(t.description) LIKE ?) ");
        }
        sql.append("ORDER BY t.transaction_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, accountNumber);
            ps.setString(idx++, accountNumber);

            if (txType != null && !txType.trim().isEmpty() && !"ALL".equalsIgnoreCase(txType)) {
                ps.setString(idx++, txType.toUpperCase());
            }
            if (startDate != null && !startDate.trim().isEmpty()) {
                ps.setString(idx++, startDate.trim());
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                ps.setString(idx++, endDate.trim());
            }
            if (search != null && !search.trim().isEmpty()) {
                String term = "%" + search.trim().toLowerCase() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransaction(rs));
                }
            }
        }
        return list;
    }

    public List<Transaction> getAllTransactions() throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, u1.full_name as sender_name, u2.full_name as receiver_name " +
                     "FROM TRANSACTIONS t " +
                     "LEFT JOIN USERS u1 ON t.sender_account = u1.account_number " +
                     "LEFT JOIN USERS u2 ON t.receiver_account = u2.account_number " +
                     "ORDER BY t.transaction_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    public int getUserTransactionCount(String accountNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM TRANSACTIONS WHERE sender_account = ? OR receiver_account = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            ps.setString(2, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction tx = new Transaction();
        tx.setTransactionId(rs.getString("transaction_id"));
        tx.setSenderAccount(rs.getString("sender_account"));
        tx.setReceiverAccount(rs.getString("receiver_account"));
        tx.setTransactionType(rs.getString("transaction_type"));
        tx.setAmount(rs.getBigDecimal("amount"));
        tx.setSenderClosingBalance(rs.getBigDecimal("sender_closing_balance"));
        tx.setReceiverClosingBalance(rs.getBigDecimal("receiver_closing_balance"));
        tx.setDescription(rs.getString("description"));
        tx.setStatus(rs.getString("status"));
        tx.setTransactionDate(rs.getTimestamp("transaction_date"));
        try {
            tx.setSenderName(rs.getString("sender_name"));
            tx.setReceiverName(rs.getString("receiver_name"));
        } catch (SQLException ignored) {}
        return tx;
    }
}
