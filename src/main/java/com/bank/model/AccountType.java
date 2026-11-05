package com.bank.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class AccountType implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer typeId;
    private String typeName;
    private BigDecimal minBalance;
    private BigDecimal interestRate;
    private String description;

    public AccountType() {}

    public AccountType(Integer typeId, String typeName, BigDecimal minBalance, BigDecimal interestRate, String description) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.minBalance = minBalance;
        this.interestRate = interestRate;
        this.description = description;
    }

    public Integer getTypeId() { return typeId; }
    public void setTypeId(Integer typeId) { this.typeId = typeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public BigDecimal getMinBalance() { return minBalance; }
    public void setMinBalance(BigDecimal minBalance) { this.minBalance = minBalance; }

    public BigDecimal getInterestRate() { return interestRate; }
    public void setInterestRate(BigDecimal interestRate) { this.interestRate = interestRate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
