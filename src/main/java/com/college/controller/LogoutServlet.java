package com.college.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Fetch the current session (The 'false' means: don't create a new one if it doesn't exist)
        HttpSession session = request.getSession(false);
        
        // 2. If a session exists, completely destroy it
        if (session != null) {
            session.invalidate();
        }
        
        // 3. Redirect them back to the login page with a parameter so we can show a nice message
        response.sendRedirect("login.jsp?logout=success");
    }
}