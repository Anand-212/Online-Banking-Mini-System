-- ====================================================================
-- ONLINE BANKING MINI SYSTEM - DATABASE CLEANUP SCRIPT
-- Target DBMS: Oracle Database (11g / 12c / 18c / 19c / 21c XE)
-- 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- WARNING: DESTRUCTIVE ACTION - DATA LOSS IMMINENT
-- RUNNING THIS SCRIPT PERMANENTLY REMOVES ALL APPLICATION DATA,
-- TABLES, SEQUENCES, AND CONSTRAINTS FOR THE ONLINE BANKING SYSTEM.
-- USE THIS SCRIPT BEFORE RUNNING database.sql FOR A FRESH INITIALIZATION.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- ====================================================================

SET SERVEROUTPUT ON;

PROMPT ================================================================;
PROMPT  Online Banking Mini System - Dropping all existing objects...
PROMPT ================================================================;

-- 1. DROP ALL TABLES IN REVERSE DEPENDENCY ORDER (CHILD FIRST, THEN PARENT)
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
         DBMS_OUTPUT.PUT_LINE('Dropped table: ' || t.tbl);
      EXCEPTION
         WHEN OTHERS THEN
            -- Silently ignore if table does not exist (ORA-00942)
            NULL;
      END;
   END LOOP;
END;
/

-- 2. DROP ALL PROJECT SEQUENCES
BEGIN
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
         DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || s.seq);
      EXCEPTION
         WHEN OTHERS THEN
            -- Silently ignore if sequence does not exist (ORA-02289)
            NULL;
      END;
   END LOOP;
END;
/

-- 3. PURGE ORACLE RECYCLEBIN
BEGIN
   EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
   DBMS_OUTPUT.PUT_LINE('Oracle recycle bin purged successfully.');
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END;
/

COMMIT;

PROMPT ================================================================;
PROMPT  Cleanup completed successfully. Database is ready for database.sql
PROMPT ================================================================;
