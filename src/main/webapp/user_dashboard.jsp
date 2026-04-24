<%@page import="java.util.List"%>
<%@page import="com.college.model.User"%>
<%@page import="com.college.model.Complaint"%>
<%@page import="com.college.dao.ComplaintDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 

    User currentUser = (User) session.getAttribute("loggedUser");
    if(currentUser == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return; 
    }
    
    if(currentUser.getRole().equals("admin")) {
        response.sendRedirect("admin_dashboard.jsp");
        return; 
    }
    
    List<Complaint> myComplaints = ComplaintDAO.getComplaintsByUser(currentUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Grievance.edu</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'DM Sans', sans-serif; 
            background-color: #f8fafc; /* slate-50 */
            -webkit-font-smoothing: antialiased;
        }
    </style>
</head>
<body class="min-h-screen text-slate-800">

    <nav class="bg-white border-b border-slate-200 sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center gap-2">
                    <a href="index.jsp" class="w-8 h-8 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center font-bold border border-orange-200 hover:bg-orange-200 transition-colors" title="Home">G</a>
                    <span class="text-lg font-bold text-slate-900 tracking-tight ml-2">Student Dashboard</span>
                </div>
                
                <div class="flex items-center gap-4">
                    <div class="flex items-center gap-3 border-r border-slate-200 pr-4">
                        <div class="text-right hidden sm:block">
                            <p class="text-sm font-bold text-slate-900 leading-none"><%= currentUser.getFullName() %></p>
                            <p class="text-xs text-slate-500 mt-1"><%= currentUser.getEmail() %></p>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center font-bold text-lg border border-orange-200">
                            <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                        </div>
                    </div>
                    <a href="LogoutServlet" class="text-sm font-medium text-red-600 hover:text-red-700 transition-colors">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
            <div>
                <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Your Complaints</h1>
                <p class="text-slate-500 mt-1">Track the status of your submitted grievances in real-time.</p>
            </div>
            <a href="submit_complaint.jsp" class="px-5 py-2.5 text-sm font-semibold text-white bg-orange-600 rounded-lg hover:bg-orange-700 transition-all duration-200 shadow-lg shadow-orange-600/20 flex items-center gap-2 transform hover:-translate-y-0.5">
                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path></svg>
                New Complaint
            </a>
        </div>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm">
            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left">
                    <thead class="text-xs text-slate-500 uppercase bg-slate-50 border-b border-slate-200 font-semibold">
                        <tr>
                            <th scope="col" class="px-6 py-4">ID</th>
                            <th scope="col" class="px-6 py-4">Category</th>
                            <th scope="col" class="px-6 py-4">Description</th>
                            <th scope="col" class="px-6 py-4">Date Submitted</th>
                            <th scope="col" class="px-6 py-4">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
    <% 
        if(myComplaints.isEmpty()) { 
    %>
        <tr>
            <td colspan="5" class="px-6 py-16 text-center">
                <div class="flex flex-col items-center justify-center text-slate-500">
                    <svg class="w-12 h-12 mb-4 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                    <p class="text-base font-semibold text-slate-900">No complaints found</p>
                    <p class="text-sm mt-1">You haven't submitted any grievances yet.</p>
                </div>
            </td>
        </tr>
    <% 
        } else {
            for(Complaint c : myComplaints) { 
                String statusColor = "bg-amber-100 text-amber-700 border-amber-200"; // Pending
                if(c.getStatus().equals("Resolved")) statusColor = "bg-emerald-100 text-emerald-700 border-emerald-200";
                else if(c.getStatus().equals("Rejected")) statusColor = "bg-red-100 text-red-700 border-red-200";
    %>
        <tr class="hover:bg-slate-50 transition-colors">
            <td class="px-6 py-4">
                <span class="font-medium text-slate-900">#<%= c.getComplaintId() %></span>
            </td>
            <td class="px-6 py-4">
                <span class="px-2.5 py-1 bg-slate-100 text-slate-600 rounded text-xs font-semibold uppercase tracking-wider inline-block">
                    <%= c.getCategory() %>
                </span>
            </td>
            <td class="px-6 py-4">
                <div class="text-slate-600 truncate max-w-xs" title="<%= c.getDescription() %>">
                    <%= c.getDescription() %>
                </div>
                
                <% if(c.getAttachmentPath() != null && !c.getAttachmentPath().trim().isEmpty()) { %>
                    <div class="mt-3">
                        <a href="uploads/<%= c.getAttachmentPath() %>" target="_blank" 
                           class="inline-flex items-center gap-1.5 text-xs font-semibold text-blue-600 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded border border-blue-200 transition-colors">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path></svg>
                            View Evidence
                        </a>
                    </div>
                <% } %>
                
                <% if(c.getAdminRemark() != null && !c.getAdminRemark().trim().isEmpty() && !c.getStatus().equals("Pending")) { %>
                    <div class="mt-3 p-2.5 bg-orange-50 border-l-2 border-orange-500 rounded-r-md text-xs text-slate-700">
                        <span class="font-bold text-orange-700">Admin Reply:</span> <%= c.getAdminRemark() %>
                    </div>
                <% } %>
            </td>
            <td class="px-6 py-4 text-slate-500 text-xs font-medium">
                <%= c.getDateSubmitted() %>
            </td>
            <td class="px-6 py-4">
                <span class="px-2.5 py-1 rounded-full text-xs font-bold border <%= statusColor %>">
                    <%= c.getStatus() %>
                </span>
            </td>
        </tr>
    <% 
            } 
        } 
    %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

</body>
</html>