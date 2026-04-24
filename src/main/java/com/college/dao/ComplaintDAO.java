package com.college.dao;

import com.college.model.Complaint;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    // Fetch all complaints for a specific user
    public static List<Complaint> getComplaintsByUser(int userId) {
        List<Complaint> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Get complaints, newest first
            String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY date_submitted DESC";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, userId);
            
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setComplaintId(rs.getInt("complaint_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCategory(rs.getString("category"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                c.setAdminRemark(rs.getString("admin_remark"));
                
                // THE MISSING LINK: Tell the DAO to fetch the file path!
                c.setAttachmentPath(rs.getString("attachment_path"));
                
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Fetch ALL complaints for the Admin Dashboard
    public static List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Join with the users table so the admin can see WHO submitted the complaint
            String sql = "SELECT c.*, u.full_name, u.email FROM complaints c " +
                         "JOIN users u ON c.user_id = u.user_id " +
                         "ORDER BY c.date_submitted DESC";
                         
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setComplaintId(rs.getInt("complaint_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCategory(rs.getString("category"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                c.setAdminRemark(rs.getString("admin_remark"));
                
                c.setAdminRemark(rs.getString("full_name") + " (" + rs.getString("email") + ")");
                
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Fetch complaints strictly for ONE department
    public static List<Complaint> getComplaintsByDepartment(String department) {
        List<Complaint> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Added WHERE c.category = ?
            String sql = "SELECT c.*, u.full_name, u.email FROM complaints c " +
                         "JOIN users u ON c.user_id = u.user_id " +
                         "WHERE c.category = ? " +
                         "ORDER BY c.date_submitted DESC";
                         
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, department);
            
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setComplaintId(rs.getInt("complaint_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCategory(rs.getString("category"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                
                // Storing student info in Admin Remark temporarily for the dashboard
                c.setAdminRemark(rs.getString("full_name") + " (" + rs.getString("email") + ")");
                
                // NEW: Grab the file attachment path!
                c.setAttachmentPath(rs.getString("attachment_path"));
                
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}