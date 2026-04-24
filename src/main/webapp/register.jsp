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
    <title>Join Grievance.edu</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'DM Sans', sans-serif; background: #f8fafc; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">

    <div class="max-w-md w-full bg-white rounded-2xl shadow-xl border border-slate-100 p-8">
        
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-12 h-12 rounded-full border-4 border-orange-600 text-orange-600 font-bold text-xl mb-3">
                G
            </div>
            <h2 class="text-2xl font-bold text-slate-900">Create your account</h2>
            <p class="text-slate-500 text-sm mt-2">Join the Grievance.edu portal to raise and track your institutional concerns.</p>
        </div>

        <form action="RegisterServlet" method="POST" class="space-y-5">
            
            <% 
                String error = request.getParameter("error");
                if ("email_exists".equals(error)) {
            %>
                <div class="bg-red-50 text-red-600 text-sm p-3 rounded-lg border border-red-100 text-center">
                    That email is already registered. Try logging in.
                </div>
            <% } else if ("invalid_domain".equals(error)) { %>
                <div class="bg-amber-50 text-amber-700 text-sm p-3 rounded-lg border border-amber-200 text-center">
                    You must use a valid TCET student email (e.g., S1032...@tcetmumbai.in).
                </div>
            <% } else if ("server".equals(error)) { %>
                <div class="bg-red-50 text-red-600 text-sm p-3 rounded-lg border border-red-100 text-center">
                    Server error occurred. Please try again.
                </div>
            <% } %>

            <div>
                <label for="fullName" class="block text-sm font-medium text-slate-700 mb-1">Full Name</label>
                <input type="text" id="fullName" name="fullName" required 
                    class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all text-slate-900"
                    placeholder="John Doe">
            </div>

            <div>
                <label for="email" class="block text-sm font-medium text-slate-700 mb-1">Institutional Email</label>
                <input type="email" id="email" name="email" required 
                    pattern="^S[0-9]+@tcetmumbai\.in$"
                    title="Please use your official college email: S[RollNumber]@tcetmumbai.in"
                    class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all text-slate-900"
                    placeholder="S1032XXXX@tcetmumbai.in">
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-slate-700 mb-1">Password</label>
                <input type="password" id="password" name="password" required minlength="6"
                    class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all text-slate-900"
                    placeholder="••••••••">
            </div>

            <button type="submit" 
                class="w-full py-3 px-4 bg-orange-600 hover:bg-orange-700 text-white font-semibold rounded-lg shadow-lg shadow-orange-600/30 transition-all transform hover:-translate-y-0.5 mt-2">
                Sign Up
            </button>
        </form>

        <p class="text-center text-sm text-slate-500 mt-6">
            Already have an account? 
            <a href="login.jsp" class="font-semibold text-orange-600 hover:text-orange-700">Sign in</a>
        </p>
    </div>

</body>
</html>