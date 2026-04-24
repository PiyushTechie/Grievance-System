package com.college.controller;

import com.college.dao.DBConnection;
import com.college.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the data typed into the login.jsp form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // 2. Query the database to see if the user exists
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, email);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // 3. Match found! Create a User object with all 5 fields
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("role"),
                    rs.getString("department") // Now fetching department from DB
                );

                // 4. Create an HTTP Session to keep the user logged in
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);

                // 5. Redirect based on their role
                if (user.getRole().equals("admin")) {
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    response.sendRedirect("user_dashboard.jsp");
                }
            } else {
                // Login failed: Redirect back to login page with an error parameter
                response.sendRedirect("login.jsp?error=invalid");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}