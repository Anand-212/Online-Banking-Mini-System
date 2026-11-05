package com.bank.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static String dbUrl;
    private static String dbUsername;
    private static String dbPassword;
    private static String dbDriver;

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("application.properties")) {
            Properties prop = new Properties();
            if (input != null) {
                prop.load(input);
                dbUrl = prop.getProperty("db.url", "jdbc:oracle:thin:@localhost:1521:xe");
                dbUsername = prop.getProperty("db.username", "system");
                dbPassword = prop.getProperty("db.password", "oracle");
                dbDriver = prop.getProperty("db.driver", "oracle.jdbc.driver.OracleDriver");
            } else {
                dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
                dbUsername = "system";
                dbPassword = "oracle";
                dbDriver = "oracle.jdbc.driver.OracleDriver";
            }
            Class.forName(dbDriver);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load Database Configuration or Oracle Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error establishing connection to Oracle XE Database at: " + dbUrl, e);
            throw e;
        }
    }

    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to close Connection", e);
            }
        }
    }
}
