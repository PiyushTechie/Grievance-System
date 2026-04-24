package com.college.controller;

import com.college.dao.DBConnection;
import com.college.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("user_dashboard.jsp"); 
            return;
        }

        // Get the data from the Admin Dashboard
        String complaintId = request.getParameter("complaintId");
        String newStatus = request.getParameter("newStatus");
        String adminRemark = request.getParameter("adminRemark"); // Catch the new remark!

        // If the admin didn't type anything, set it to a default message
        if (adminRemark == null || adminRemark.trim().isEmpty()) {
            adminRemark = "Processed by " + user.getDepartment() + " Department.";
        }

        if (complaintId != null && newStatus != null) {
            try (Connection conn = DBConnection.getConnection()) {
                
                // Update BOTH the status and the admin_remark
                String sql = "UPDATE complaints SET status = ?, admin_remark = ? WHERE complaint_id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                
                pst.setString(1, newStatus);
                pst.setString(2, adminRemark);
                pst.setInt(3, Integer.parseInt(complaintId));
                
                int rowsUpdated = pst.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("admin_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?error=notfound");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?error=server");
            }
        }
    }
}