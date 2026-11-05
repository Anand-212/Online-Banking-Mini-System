-- ====================================================================
-- ONLINE BANKING MINI SYSTEM - COMPLETE REPRODUCIBLE DATABASE SCRIPT
-- Target DBMS: Oracle Database 11g / 12c / 18c / 19c / 21c XE
-- Description: Creates all sequences, tables, constraints, indexes,
--              MPIN security columns, and seed accounts with demo data.
-- ====================================================================

SET SERVEROUTPUT ON;

PROMPT ================================================================;
PROMPT  Initializing Online Banking Mini System Database Schema...
PROMPT ================================================================;

-- --------------------------------------------------------------------
-- 1. TEARDOWN (CLEANS UP ANY EXISTING OBJECTS BEFORE RE-CREATION)
-- --------------------------------------------------------------------
BEGIN
   FOR t IN (
      SELECT 'NOTIFICATIONS' AS tbl FROM dual UNION ALL
      SELECT 'AUDIT_LOG' FROM dual UNION ALL
      SELECT 'LOGIN_HISTORY' FROM dual UNION ALL
      SELECT 'TRANSACTIONS' FROM dual UNION ALL
      SELECT 'USERS' FROM dual UNION ALL
      SELECT 'ADMINS' FROM dual UNION ALL
      SELECT 'ACCOUNT_TYPES' FROM dual
   ) LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE ' || t.tbl || ' CASCADE CONSTRAINTS PURGE';
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
   END LOOP;

   FOR s IN (
      SELECT 'USER_SEQ' AS seq FROM dual UNION ALL
      SELECT 'ACCOUNT_SEQ' FROM dual UNION ALL
      SELECT 'TX_SEQ' FROM dual UNION ALL
      SELECT 'AUDIT_SEQ' FROM dual UNION ALL
      SELECT 'NOTIF_SEQ' FROM dual UNION ALL
      SELECT 'LOGIN_SEQ' FROM dual
   ) LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.seq;
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
   END LOOP;
END;
/

-- --------------------------------------------------------------------
-- 2. CREATE SEQUENCES
-- --------------------------------------------------------------------
CREATE SEQUENCE USER_SEQ START WITH 103 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE ACCOUNT_SEQ START WITH 100010003 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE TX_SEQ START WITH 50000004 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE AUDIT_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE NOTIF_SEQ START WITH 10 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE LOGIN_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;

-- --------------------------------------------------------------------
-- 3. CREATE TABLES & CONSTRAINTS
-- --------------------------------------------------------------------

-- Table: ACCOUNT_TYPES
CREATE TABLE ACCOUNT_TYPES (
    type_id NUMBER PRIMARY KEY,
    type_name VARCHAR2(50) NOT NULL UNIQUE,
    min_balance NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    interest_rate NUMBER(5,2) DEFAULT 0.00 NOT NULL,
    description VARCHAR2(255)
);

-- Table: USERS (With 4-Digit MPIN Security & Rate-Limiting Lockout)
CREATE TABLE USERS (
    user_id NUMBER PRIMARY KEY,
    account_number VARCHAR2(20) NOT NULL UNIQUE,
    full_name VARCHAR2(100) NOT NULL,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    mpin_hash VARCHAR2(255) NULL,
    mpin_attempts NUMBER DEFAULT 0 NOT NULL,
    mpin_lockout_until TIMESTAMP NULL,
    mobile_number VARCHAR2(15) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    address VARCHAR2(255) NOT NULL,
    account_type_id NUMBER NOT NULL,
    balance NUMBER(15,2) DEFAULT 0.00 NOT NULL,
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'FROZEN', 'DELETED')),
    profile_photo VARCHAR2(255) DEFAULT 'default-avatar.png',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_login TIMESTAMP,
    CONSTRAINT fk_user_acc_type FOREIGN KEY (account_type_id) REFERENCES ACCOUNT_TYPES(type_id)
);

-- Table: ADMINS
CREATE TABLE ADMINS (
    admin_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    full_name VARCHAR2(100) NOT NULL,
    role VARCHAR2(20) DEFAULT 'SUPER_ADMIN' CHECK (role IN ('SUPER_ADMIN', 'AUDITOR', 'SUPPORT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: TRANSACTIONS
CREATE TABLE TRANSACTIONS (
    transaction_id VARCHAR2(30) PRIMARY KEY,
    sender_account VARCHAR2(20),
    receiver_account VARCHAR2(20),
    transaction_type VARCHAR2(20) NOT NULL CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER', 'INTEREST')),
    amount NUMBER(15,2) NOT NULL CHECK (amount > 0),
    sender_closing_balance NUMBER(15,2),
    receiver_closing_balance NUMBER(15,2),
    description VARCHAR2(255),
    status VARCHAR2(20) DEFAULT 'SUCCESS' CHECK (status IN ('SUCCESS', 'FAILED', 'PENDING')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_tx_sender FOREIGN KEY (sender_account) REFERENCES USERS(account_number),
    CONSTRAINT fk_tx_receiver FOREIGN KEY (receiver_account) REFERENCES USERS(account_number)
);

-- Table: LOGIN_HISTORY
CREATE TABLE LOGIN_HISTORY (
    login_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    username VARCHAR2(50) NOT NULL,
    user_type VARCHAR2(10) CHECK (user_type IN ('USER', 'ADMIN')),
    ip_address VARCHAR2(45),
    user_agent VARCHAR2(255),
    status VARCHAR2(20) CHECK (status IN ('SUCCESS', 'FAILED')),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: AUDIT_LOG
CREATE TABLE AUDIT_LOG (
    log_id NUMBER PRIMARY KEY,
    performed_by VARCHAR2(50) NOT NULL,
    role VARCHAR2(20) NOT NULL,
    action VARCHAR2(100) NOT NULL,
    details VARCHAR2(500),
    ip_address VARCHAR2(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: NOTIFICATIONS
CREATE TABLE NOTIFICATIONS (
    notification_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    title VARCHAR2(100) NOT NULL,
    message VARCHAR2(500) NOT NULL,
    is_read NUMBER(1) DEFAULT 0 CHECK (is_read IN (0, 1)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- 4. CREATE INDEXES
-- Note: UNIQUE columns (username, email, account_number) are automatically indexed by Oracle
-- --------------------------------------------------------------------
CREATE INDEX idx_tx_sender ON TRANSACTIONS(sender_account);
CREATE INDEX idx_tx_receiver ON TRANSACTIONS(receiver_account);
CREATE INDEX idx_tx_date ON TRANSACTIONS(transaction_date);
CREATE INDEX idx_notif_user ON NOTIFICATIONS(user_id);

-- --------------------------------------------------------------------
-- 5. INITIAL SEED DATA
-- --------------------------------------------------------------------

-- Account Types
INSERT INTO ACCOUNT_TYPES (type_id, type_name, min_balance, interest_rate, description) 
VALUES (1, 'Savings Account', 500.00, 4.25, 'Standard savings account with competitive quarterly interest rates.');

INSERT INTO ACCOUNT_TYPES (type_id, type_name, min_balance, interest_rate, description) 
VALUES (2, 'Current Account', 1000.00, 0.00, 'Business transaction account with unlimited daily transactions.');

-- Admins
-- Username: admin | Password: Admin@123
INSERT INTO ADMINS (admin_id, username, email, password_hash, full_name, role) 
VALUES (1, 'admin', 'admin@apexbank.com', '$2a$12$FEERI5FlK6Ylbe4wna93K.hZKyE6Twe/KozZQ0Psg4VzPmYlBZZdC', 'System Administrator', 'SUPER_ADMIN');

-- Sample Users with Pre-Configured BCrypt Password and 4-Digit MPIN (1234)
-- Username: anandraj | Password: User@1234 | MPIN: 1234
INSERT INTO USERS (
    user_id, account_number, full_name, username, email, 
    password_hash, mpin_hash, mpin_attempts, mpin_lockout_until, 
    mobile_number, dob, gender, address, account_type_id, balance, status
) VALUES (
    101, '100010001', 'Anand Raj', 'anandraj', 'anand.raj@example.com', 
    '$2a$12$H8mhDmsK3tSgt3KIVaQBteVyMurmmmy.ffnWnIpBThVF4yt.UsYeW', 
    '$2a$12$9sZ9Ia3pl.iN4K9.3VdpF..HdDnYG7XloW6UcJCBfK7PzrcpqX/la', 0, NULL,
    '9876543210', TO_DATE('2002-05-15', 'YYYY-MM-DD'), 'Male', 'Greater Noida, Uttar Pradesh', 
    1, 15000.00, 'ACTIVE'
);

-- Username: binshukumari | Password: User@1234 | MPIN: 1234
INSERT INTO USERS (
    user_id, account_number, full_name, username, email, 
    password_hash, mpin_hash, mpin_attempts, mpin_lockout_until, 
    mobile_number, dob, gender, address, account_type_id, balance, status
) VALUES (
    102, '100010002', 'Binshu Kumari', 'binshukumari', 'binshu.kumari@example.com', 
    '$2a$12$H8mhDmsK3tSgt3KIVaQBteVyMurmmmy.ffnWnIpBThVF4yt.UsYeW', 
    '$2a$12$9sZ9Ia3pl.iN4K9.3VdpF..HdDnYG7XloW6UcJCBfK7PzrcpqX/la', 0, NULL,
    '9876543211', TO_DATE('2003-08-22', 'YYYY-MM-DD'), 'Female', 'Greater Noida, Uttar Pradesh', 
    2, 28500.50, 'ACTIVE'
);

-- Sample Transactions
INSERT INTO TRANSACTIONS (transaction_id, sender_account, receiver_account, transaction_type, amount, sender_closing_balance, receiver_closing_balance, description, status, transaction_date)
VALUES ('TX50000001', NULL, '100010001', 'DEPOSIT', 15000.00, NULL, 15000.00, 'Initial Account Opening Deposit', 'SUCCESS', CURRENT_TIMESTAMP - INTERVAL '5' DAY);

INSERT INTO TRANSACTIONS (transaction_id, sender_account, receiver_account, transaction_type, amount, sender_closing_balance, receiver_closing_balance, description, status, transaction_date)
VALUES ('TX50000002', NULL, '100010002', 'DEPOSIT', 30000.00, NULL, 30000.00, 'Initial Account Opening Deposit', 'SUCCESS', CURRENT_TIMESTAMP - INTERVAL '3' DAY);

INSERT INTO TRANSACTIONS (transaction_id, sender_account, receiver_account, transaction_type, amount, sender_closing_balance, receiver_closing_balance, description, status, transaction_date)
VALUES ('TX50000003', '100010002', '100010001', 'TRANSFER', 1500.00, 28500.50, 16500.00, 'Freelance Project Payment', 'SUCCESS', CURRENT_TIMESTAMP - INTERVAL '1' DAY);

-- Sample Notifications
INSERT INTO NOTIFICATIONS (notification_id, user_id, title, message)
VALUES (NOTIF_SEQ.NEXTVAL, 101, 'Welcome to Online Banking', 'Your savings account 100010001 is active. Your default MPIN is 1234.');

INSERT INTO NOTIFICATIONS (notification_id, user_id, title, message)
VALUES (NOTIF_SEQ.NEXTVAL, 102, 'Transfer Received', 'You received $1,500.00 from account 100010002.');

COMMIT;

PROMPT ================================================================;
PROMPT  Database initialization complete! All tables and seed users ready.
PROMPT ================================================================;
