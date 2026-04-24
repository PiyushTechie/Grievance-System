package com.college.controller;

import com.college.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the data from the register.jsp form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. STRICT BACKEND VALIDATION
        // This ensures the email starts with 'S' (case-sensitive), followed by numbers, and ends with @tcetmumbai.in
        if (email == null || !email.matches("^S[0-9]+@tcetmumbai\\.in$")) {
            response.sendRedirect("register.jsp?error=invalid_domain");
            return; // Stop execution immediately
        }

        try (Connection conn = DBConnection.getConnection()) {
            
            // 3. Prepare the SQL Insert Statement
            String sql = "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            
            pst.setString(1, fullName);
            pst.setString(2, email);
            pst.setString(3, password); 
            
            // 4. Execute the insert
            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                // Success! Redirect to login page with a success flag
                response.sendRedirect("login.jsp?registered=true");
            } else {
                response.sendRedirect("register.jsp?error=server");
            }
            
        } catch (SQLIntegrityConstraintViolationException e) {
            // This specific error catches if the email already exists in the database
            response.sendRedirect("register.jsp?error=email_exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=server");
        }
    }
}