package com.bank.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.Instant;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long userId;
    private String accountNumber;
    private String fullName;
    private String username;
    private String email;
    private String passwordHash;
    private String mpinHash;
    private Integer mpinAttempts;
    private Timestamp mpinLockoutUntil;
    private String mobileNumber;
    private Date dob;
    private String gender;
    private String address;
    private Integer accountTypeId;
    private String accountTypeName;
    private BigDecimal balance;
    private String status;
    private String profilePhoto;
    private Timestamp createdAt;
    private Timestamp lastLogin;

    public User() {
        this.mpinAttempts = 0;
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getMpinHash() { return mpinHash; }
    public void setMpinHash(String mpinHash) { this.mpinHash = mpinHash; }

    public Integer getMpinAttempts() { return mpinAttempts != null ? mpinAttempts : 0; }
    public void setMpinAttempts(Integer mpinAttempts) { this.mpinAttempts = mpinAttempts; }

    public Timestamp getMpinLockoutUntil() { return mpinLockoutUntil; }
    public void setMpinLockoutUntil(Timestamp mpinLockoutUntil) { this.mpinLockoutUntil = mpinLockoutUntil; }

    public boolean hasMpin() {
        return mpinHash != null && !mpinHash.trim().isEmpty();
    }

    public boolean isMpinLocked() {
        return mpinLockoutUntil != null && mpinLockoutUntil.after(Timestamp.from(Instant.now()));
    }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Integer getAccountTypeId() { return accountTypeId; }
    public void setAccountTypeId(Integer accountTypeId) { this.accountTypeId = accountTypeId; }

    public String getAccountTypeName() { return accountTypeName; }
    public void setAccountTypeName(String accountTypeName) { this.accountTypeName = accountTypeName; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
}
