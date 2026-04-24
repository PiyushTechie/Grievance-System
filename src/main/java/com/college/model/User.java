package com.college.model;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String role;
    private String department;

    // Empty Constructor
    public User() {}

    // Parameterized Constructor
    public User(int userId, String fullName, String email, String role, String department) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.department = department;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}