package com.college.model;

import java.sql.Timestamp;

public class Complaint {
    private int complaintId;
    private int userId;
    private String category;
    private String description;
    private String status;
    private Timestamp dateSubmitted;
    private String adminRemark;
    private String attachmentPath;
    
    // Empty Constructor
    public Complaint() {}

    // Getters and Setters
    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getDateSubmitted() { return dateSubmitted; }
    public void setDateSubmitted(Timestamp dateSubmitted) { this.dateSubmitted = dateSubmitted; }

    public String getAdminRemark() { return adminRemark; }
    public void setAdminRemark(String adminRemark) { this.adminRemark = adminRemark; }
    
    public String getAttachmentPath() { return attachmentPath; }
    public void setAttachmentPath(String attachmentPath) { this.attachmentPath = attachmentPath; }
}