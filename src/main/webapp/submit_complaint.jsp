<%@page import="com.college.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Defeat the "Back Button" cache exploit
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 

    // 2. Strict Security Check: Only logged-in students can submit complaints
    User currentUser = (User) session.getAttribute("loggedUser");
    if(currentUser == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
    if("admin".equals(currentUser.getRole())) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint | Grievance.edu</title>
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
                <div class="flex items-center space-x-4">
                    <a href="user_dashboard.jsp" class="flex items-center gap-2 text-slate-500 hover:text-orange-600 transition-colors font-medium text-sm">
                        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                        Back to Dashboard
                    </a>
                    <span class="text-lg font-bold text-slate-900 tracking-tight border-l border-slate-200 pl-4 ml-2">Submit Grievance</span>
                </div>
                
                <div class="flex items-center gap-3">
                    <div class="text-right hidden sm:block">
                        <p class="text-sm font-bold text-slate-900 leading-none"><%= currentUser.getFullName() %></p>
                        <p class="text-xs text-slate-500 mt-1"><%= currentUser.getEmail() %></p>
                    </div>
                    <div class="w-10 h-10 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center font-bold text-lg border border-orange-200">
                        <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-slate-900 tracking-tight">How can we help?</h1>
            <p class="text-slate-500 mt-2">Provide the details of your issue below so the right department can resolve it.</p>
        </div>

        <div class="bg-white rounded-2xl shadow-xl border border-slate-100 p-8 transition-all duration-300 hover:shadow-2xl">
            
            <form action="SubmitComplaintServlet" method="POST" enctype="multipart/form-data" class="space-y-6">    
                <div>
                    <label for="category" class="block text-sm font-semibold text-slate-700 mb-2">Issue Category</label>
                    <div class="relative">
                        <select id="category" name="category" required 
                            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all duration-200 text-slate-900 cursor-pointer appearance-none font-medium">
                            <option value="" disabled selected>Select the relevant department...</option>
                            <option value="Academic">Academic & Classes</option>
                            <option value="Hostel">Hostel & Accommodation</option>
                            <option value="Finance">Finance & Fees</option>
                            <option value="IT">IT & Network Portal</option>
                            <option value="Other">Other / General</option>
                        </select>
                        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-slate-500">
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"></path></svg>
                        </div>
                    </div>
                </div>

                <div>
                    <label for="description" class="block text-sm font-semibold text-slate-700 mb-2">Detailed Description</label>
                    <textarea id="description" name="description" rows="6" required
                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 outline-none transition-all duration-200 text-slate-900 placeholder-slate-400 resize-none"
                        placeholder="Please explain your issue clearly. Include any relevant details like location, subject codes, or dates..."></textarea>
                </div> <div>
                    <label for="evidence" class="block text-sm font-semibold text-slate-700 mb-2">Attach Evidence (Optional)</label>
                    <div id="drop-zone" class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-slate-300 border-dashed rounded-lg hover:border-orange-500 transition-colors bg-slate-50 relative">
                        <div class="space-y-1 text-center">
                            <svg class="mx-auto h-12 w-12 text-slate-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                            <div class="flex text-sm text-slate-600 justify-center">
                                <label for="evidence" class="relative cursor-pointer bg-white rounded-md font-medium text-orange-600 hover:text-orange-500 focus-within:outline-none px-2 py-1">
                                    <span id="file-name-display">Upload a file</span>
                                    <input id="evidence" name="evidence" type="file" class="sr-only" accept="image/*,.pdf" onchange="updateFileName(this)">
                                </label>
                            </div>
                            <p id="file-size-display" class="text-xs text-slate-500">PNG, JPG, or PDF up to 5MB</p>
                        </div>
                    </div>
                </div>

                <div class="pt-4">
                    <button type="submit" 
                        class="w-full py-3.5 px-4 bg-orange-600 hover:bg-orange-700 text-white font-bold rounded-lg shadow-lg shadow-orange-600/20 transition-all transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2">
                        Submit Grievance
                    </button>
                </div>
            </form>
            
        </div>
    </main>

    <script>
        function updateFileName(input) {
            const fileNameDisplay = document.getElementById('file-name-display');
            const fileSizeDisplay = document.getElementById('file-size-display');
            const dropZone = document.getElementById('drop-zone');
            
            if (input.files && input.files.length > 0) {
                const file = input.files[0];
                
                // Show file name and turn text green
                fileNameDisplay.textContent = "Selected: " + file.name;
                fileNameDisplay.classList.add("text-emerald-600");
                fileNameDisplay.classList.remove("text-orange-600");
                dropZone.classList.add("border-emerald-400", "bg-emerald-50");
                
                const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
                fileSizeDisplay.textContent = "File size: " + fileSizeMB + " MB";
            }
        }
    </script>
</body>
</html>