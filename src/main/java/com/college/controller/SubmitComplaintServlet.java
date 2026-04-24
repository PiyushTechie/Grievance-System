package com.college.controller;

import com.college.dao.DBConnection;
import com.college.model.User;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/SubmitComplaintServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold before writing to disk
    maxFileSize = 1024 * 1024 * 5,        // 5MB max file size
    maxRequestSize = 1024 * 1024 * 10     // 10MB max request size
)
public class SubmitComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        
        // 2. Handle the File Upload
        String fileName = null;
        Part filePart = request.getPart("evidence");
        
        if (filePart != null && filePart.getSize() > 0) {
            // Get original filename and clean it
            String originalName = filePart.getSubmittedFileName();
            // Create a unique filename so students don't overwrite each other's files
            fileName = System.currentTimeMillis() + "_" + originalName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            
            // Define where to save the file (inside the 'uploads' folder of your app)
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            // Save the file to the server
            filePart.write(uploadPath + File.separator + fileName);
        }

        // 3. Save to Database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO complaints (user_id, category, description, attachment_path) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            
            pst.setInt(1, user.getUserId());
            pst.setString(2, category);
            pst.setString(3, description);
            pst.setString(4, fileName); // This can be null if they didn't upload anything
            
            int rows = pst.executeUpdate();
            
            if (rows > 0) {
                response.sendRedirect("user_dashboard.jsp?success=submitted");
            } else {
                response.sendRedirect("submit_complaint.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("submit_complaint.jsp?error=server");
        }
    }
}
