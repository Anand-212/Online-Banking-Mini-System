package com.bank.util;

import at.favre.lib.crypto.bcrypt.BCrypt;
import java.sql.Timestamp;
import java.time.Instant;

public class MpinUtil {
    private static final int BCRYPT_COST = 12;
    public static final int MAX_FAILED_ATTEMPTS = 3;
    public static final int LOCKOUT_MINUTES = 15;

    public static String hashMpin(String plainMpin) {
        if (plainMpin == null || plainMpin.trim().isEmpty()) {
            throw new IllegalArgumentException("MPIN cannot be empty");
        }
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, plainMpin.toCharArray());
    }

    public static boolean verifyMpin(String plainMpin, String storedHash) {
        if (plainMpin == null || storedHash == null || storedHash.trim().isEmpty()) {
            return false;
        }
        BCrypt.Result result = BCrypt.verifyer().verify(plainMpin.toCharArray(), storedHash);
        return result.verified;
    }

    public static boolean isLockedOut(Timestamp lockoutUntil) {
        if (lockoutUntil == null) {
            return false;
        }
        return lockoutUntil.after(Timestamp.from(Instant.now()));
    }

    public static long getRemainingLockoutMinutes(Timestamp lockoutUntil) {
        if (lockoutUntil == null) {
            return 0;
        }
        long diffMillis = lockoutUntil.getTime() - System.currentTimeMillis();
        if (diffMillis <= 0) {
            return 0;
        }
        return (diffMillis / 60000) + 1;
    }
}
