package com.bank.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CSRFUtil {
    private static final String CSRF_SESSION_ATTR = "CSRF_TOKEN";
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String generateToken(HttpSession session) {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        session.setAttribute(CSRF_SESSION_ATTR, token);
        return token;
    }

    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        String requestToken = request.getParameter("csrf_token");
        if (requestToken == null) {
            requestToken = request.getHeader("X-CSRF-TOKEN");
        }
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
