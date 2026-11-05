package com.bank.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    private String transactionId;
    private String senderAccount;
    private String receiverAccount;
    private String transactionType; // DEPOSIT, WITHDRAWAL, TRANSFER, INTEREST
    private BigDecimal amount;
    private BigDecimal senderClosingBalance;
    private BigDecimal receiverClosingBalance;
    private String description;
    private String status;
    private Timestamp transactionDate;

    // Helper fields for display
    private String senderName;
    private String receiverName;

    public Transaction() {}

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getSenderAccount() { return senderAccount; }
    public void setSenderAccount(String senderAccount) { this.senderAccount = senderAccount; }

    public String getReceiverAccount() { return receiverAccount; }
    public void setReceiverAccount(String receiverAccount) { this.receiverAccount = receiverAccount; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public BigDecimal getSenderClosingBalance() { return senderClosingBalance; }
    public void setSenderClosingBalance(BigDecimal senderClosingBalance) { this.senderClosingBalance = senderClosingBalance; }

    public BigDecimal getReceiverClosingBalance() { return receiverClosingBalance; }
    public void setReceiverClosingBalance(BigDecimal receiverClosingBalance) { this.receiverClosingBalance = receiverClosingBalance; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
}
