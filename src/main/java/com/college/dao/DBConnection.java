package com.college.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Make sure your database in MySQL is named "grievance_db"
    private static final String URL = "jdbc:mysql://localhost:3306/grievance_db";
    private static final String USER = "root";
    private static final String PASSWORD = "xxx"; // CHANGE THIS

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("Database connection failed!");
        }
        return conn;
    }
}