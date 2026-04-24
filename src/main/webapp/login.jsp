<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.college.model.User"%>
<%
    // 1. Defeat the "Back Button" cache exploit
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    // 2. Prevent logged-in users from seeing the login/register pages
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser != null) {
        if ("admin".equals(loggedUser.getRole())) {
            response.sendRedirect("admin_dashboard.jsp");
        } else {
            response.sendRedirect("user_dashboard.jsp");
        }
        return; // Stop rendering the page
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in | Grievance.edu</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'DM Sans', sans-serif; 
            background-color: #f8fafc; 
            -webkit-font-smoothing: antialiased;
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">

    <div class="max-w-md w-full bg-white rounded-2xl shadow-xl border border-slate-100 p-8 transition-all duration-300 hover:shadow-2xl">
        
        <div class="text-center mb-8">
            <a href="index.jsp" class="inline-flex items-center justify-center w-12 h-12 rounded-full border-4 border-orange-600 text-orange-600 font-bold text-xl mb-4 hover:bg-orange-50 transition-colors">
                G
            </a>
            <h2 class="text-2xl font-bold text-slate-900 tracking-tight">Welcome back</h2>
            <p class="text-sm text-slate-500 mt-2">Sign in to track your institutional concerns</p>
        </div>

        <form action="LoginServlet" method="POST" class="space-y-5">
            
            <% 
                String error = request.getParameter("error");
                String registered = request.getParameter("registered");
                String logout = request.getParameter("logout");
            %>
            
            <% if ("invalid".equals(error)) { %>
                <div class="bg-red-50 text-red-600 text-sm font-medium p-3 rounded-lg border border-red-100 text-center animate-pulse">
                    Invalid email or password. Please try again.
                </div>
            <% } else if ("unauthorized".equals(error)) { %>
                <div class="bg-amber-50 text-amber-700 text-sm font-medium p-3 rounded-lg border border-amber-200 text-center">
                    Please sign in to access that page.
                </div>
            <% } else if ("true".equals(registered)) { %>
                <div class="bg-green-50 text-green-700 text-sm font-medium p-3 rounded-lg border border-green-200 text-center">
                    Account created successfully! You can now log in.
                </div>
            <% } else if ("success".equals(logout)) { %>
                <div class="bg-blue-50 text-blue-700 text-sm font-medium p-3 rounded-lg border border-blue-200 text-center">
                    You have been securely logged out. Have a great day!
                </div>
            <% } %>

            <div>
                <label for="email" class="block text-sm font-medium text-slate-700 mb-1">Email address</label>
                <input id="email" name="email" type="email" required 
                    class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all duration-200 text-slate-900 placeholder-slate-400" 
                    placeholder="S103XXXXXXX@tcetmumbai.in">
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-slate-700 mb-1">Password</label>
                <input id="password" name="password" type="password" required 
                    class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all duration-200 text-slate-900 placeholder-slate-400" 
                    placeholder="••••••••">
            </div>

            <button type="submit" 
                class="w-full py-3 px-4 bg-orange-600 hover:bg-orange-700 text-white font-semibold rounded-lg shadow-lg shadow-orange-600/20 transition-all transform hover:-translate-y-0.5 mt-4 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2">
                Sign In
            </button>
        </form>

        <p class="text-center text-sm text-slate-500 mt-8">
            Don't have an account? 
            <a href="register.jsp" class="font-semibold text-orange-600 hover:text-orange-700 transition-colors">Register here</a>
        </p>
    </div>

</body>
</html>