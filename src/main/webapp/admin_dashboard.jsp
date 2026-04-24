<%@page import="java.util.List"%>
<%@page import="com.college.model.User"%>
<%@page import="com.college.model.Complaint"%>
<%@page import="com.college.dao.ComplaintDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Defeat the "Back Button" cache exploit
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 

    // 2. Security: Check if logged in AND is an admin
    User currentUser = (User) session.getAttribute("loggedUser");
    if(currentUser == null || !currentUser.getRole().equals("admin")) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
    
    // 3. Fetch complaints ONLY for this admin's department
    List<Complaint> allComplaints = ComplaintDAO.getComplaintsByDepartment(currentUser.getDepartment());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Grievance.edu</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'DM Sans', sans-serif; background: #f8fafc; } </style>
</head>
<body class="antialiased text-slate-800">

    <nav class="bg-white border-b border-slate-200 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center gap-2">
                    <a href="index.jsp" class="w-8 h-8 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center font-bold hover:bg-orange-200 transition-colors">G</a>
                    <span class="text-lg font-bold text-slate-800 ml-2"><%= currentUser.getDepartment() %> Admin Panel</span>
                </div>
                <div class="flex space-x-4 items-center">
                    <span class="text-sm font-medium text-slate-500 hidden sm:block">Logged in as <%= currentUser.getFullName() %></span>
                    <a href="LogoutServlet" class="px-4 py-2 text-sm font-medium text-red-600 bg-red-50 hover:bg-red-100 rounded-lg transition-colors">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Master Grievance List</h1>
            <p class="text-slate-500 mt-2">Manage and resolve active student complaints for the <%= currentUser.getDepartment() %> department.</p>
        </div>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm">
            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left">
                    <thead class="text-xs text-slate-500 uppercase bg-slate-50 border-b border-slate-200 font-semibold">
                        <tr>
                            <th class="px-6 py-4">ID / Date</th>
                            <th class="px-6 py-4">Student Info</th>
                            <th class="px-6 py-4">Category & Details</th>
                            <th class="px-6 py-4">Status</th>
                            <th class="px-6 py-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <% if(allComplaints.isEmpty()) { %>
                            <tr><td colspan="5" class="px-6 py-16 text-center text-slate-500">
                                <div class="flex flex-col items-center justify-center text-slate-500">
                                    <svg class="w-12 h-12 mb-4 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                    <p class="text-base font-semibold text-slate-900">No complaints pending.</p>
                                    <p class="text-sm mt-1">Great job! The queue is completely clear.</p>
                                </div>
                            </td></tr>
                        <% } else {
                            for(Complaint c : allComplaints) { 
                                String statusColor = "bg-amber-100 text-amber-700 border-amber-200"; // Pending
                                if(c.getStatus().equals("Resolved")) statusColor = "bg-emerald-100 text-emerald-700 border-emerald-200";
                                else if(c.getStatus().equals("Rejected")) statusColor = "bg-red-100 text-red-700 border-red-200";
                        %>
                        <tr class="hover:bg-slate-50 transition-colors">
                            <td class="px-6 py-4 align-top">
                                <div class="font-bold text-slate-900">#<%= c.getComplaintId() %></div>
                                <div class="text-xs font-medium text-slate-500 mt-1"><%= c.getDateSubmitted() %></div>
                            </td>
                            <td class="px-6 py-4 align-top">
                                <div class="text-slate-700 font-medium"><%= c.getAdminRemark() %></div>
                            </td>
                            <td class="px-6 py-4 align-top">
                                <span class="px-2 py-1 bg-slate-100 text-slate-600 rounded text-xs font-semibold uppercase tracking-wider mb-2 inline-block"><%= c.getCategory() %></span>
                                <p class="text-slate-600 truncate max-w-xs" title="<%= c.getDescription() %>"><%= c.getDescription() %></p>
                                
                                <% if(c.getAttachmentPath() != null && !c.getAttachmentPath().trim().isEmpty()) { %>
                                    <div class="mt-3">
                                        <a href="uploads/<%= c.getAttachmentPath() %>" target="_blank" 
                                           class="inline-flex items-center gap-1.5 text-xs font-semibold text-blue-600 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded border border-blue-200 transition-colors">
                                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path></svg>
                                            View Evidence
                                        </a>
                                    </div>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 align-top">
                                <span class="px-2.5 py-1 rounded-full text-xs font-bold border <%= statusColor %>"><%= c.getStatus() %></span>
                            </td>
                            
                            <td class="px-6 py-4 text-right align-top">
                                <% if(c.getStatus().equals("Pending")) { %>
                                    <form action="UpdateStatusServlet" method="POST" class="flex flex-col gap-2 min-w-[200px]">
                                        <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                        
                                        <textarea name="adminRemark" rows="2" placeholder="Add a remark for the student..." 
                                            class="w-full text-xs px-2 py-1.5 border border-slate-200 rounded focus:ring-1 focus:ring-orange-500 focus:border-orange-500 outline-none resize-none"></textarea>
                                        
                                        <div class="flex gap-2 justify-end">
                                            <button type="submit" name="newStatus" value="Resolved" class="px-3 py-1.5 text-xs font-semibold text-white bg-emerald-500 hover:bg-emerald-600 rounded shadow-sm transition-colors">Resolve</button>
                                            <button type="submit" name="newStatus" value="Rejected" class="px-3 py-1.5 text-xs font-semibold text-red-600 bg-red-50 hover:bg-red-100 border border-red-200 rounded transition-colors">Reject</button>
                                        </div>
                                    </form>
                                <% } else { %>
                                    <span class="text-xs font-medium text-slate-400 italic">Actioned</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>