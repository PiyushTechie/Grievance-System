<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.college.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.college.model.User"%>
<%
    User currentUser = (User) session.getAttribute("loggedUser");

    // --- NEW: FETCH REAL-TIME STATS FROM DATABASE ---
    int totalComplaints = 0;
    int activeComplaints = 0;
    int resolvedComplaints = 0;

    try (Connection conn = DBConnection.getConnection()) {
        // 1. Get Total Complaints
        ResultSet rsTotal = conn.prepareStatement("SELECT COUNT(*) FROM complaints").executeQuery();
        if (rsTotal.next()) totalComplaints = rsTotal.getInt(1);

        // 2. Get Active (Pending) Complaints
        ResultSet rsActive = conn.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Pending'").executeQuery();
        if (rsActive.next()) activeComplaints = rsActive.getInt(1);

        // 3. Get Resolved Complaints
        ResultSet rsResolved = conn.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Resolved'").executeQuery();
        if (rsResolved.next()) resolvedComplaints = rsResolved.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grievance.edu | Online Portal</title>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap');
      
      * { box-sizing: border-box; margin: 0; padding: 0; }
      html { scroll-behavior: smooth; }
      
      .gp { 
        font-family: 'DM Sans', sans-serif; 
        background: #f8fafc; 
        color: #1e293b;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
      }
      
      .gp a, .gp button, .gp .dept-tab, .gp .dept-card, .gp .faq-item, .gp .social-btn, .gp label { 
          cursor: pointer !important; 
      }
      .gp a { text-decoration: none; }
      
      .gp .announcement-bar { background: #c2410c; color: #fff; font-size: 13px; font-weight: 500; text-align: center; padding: 8px 20px; display: flex; justify-content: center; align-items: center; gap: 8px; }
      .gp .announcement-bar a { color: #fed7aa; text-decoration: underline; font-weight: 700; }

      .gp nav { 
          background: rgba(255, 255, 255, 0.95); 
          backdrop-filter: blur(8px); 
          border-bottom: 1px solid #e2e8f0; 
          position: sticky; top: 0; z-index: 100; 
          display: flex; justify-content: center;
      }
      .gp .nav-inner {
          display: flex; align-items: center; justify-content: space-between; 
          width: 100%; max-width: 1200px; padding: 1rem 2rem;
      }
      
      .gp .logo { display: flex; align-items: center; gap: 8px; transition: transform 0.3s ease; }
      .gp .logo:hover { transform: scale(1.02); }
      .gp .logo-circle { width: 38px; height: 38px; border-radius: 50%; border: 3px solid #ea580c; display: flex; align-items: center; justify-content: center; color: #ea580c; font-weight: 800; font-size: 18px; }
      .gp .logo-text { font-weight: 700; font-size: 18px; color: #1e293b; letter-spacing: -0.5px; }
      .gp .logo-text span { color: #ea580c; }
      
      .gp .nav-links { display: flex; gap: 2.5rem; }
      .gp .nav-links a { 
          font-size: 14px; font-weight: 600; color: #64748b; 
          transition: color 0.3s ease; position: relative; padding-bottom: 4px;
      }
      .gp .nav-links a::after {
          content: ''; position: absolute; width: 0; height: 2px;
          bottom: 0; left: 0; background-color: #ea580c;
          transition: width 0.3s cubic-bezier(0.16, 1, 0.3, 1);
      }
      .gp .nav-links a:hover::after, .gp .nav-links a.active::after { width: 100%; }
      .gp .nav-links a.active { color: #1e293b; }
      .gp .nav-links a:hover { color: #1e293b; }
      
      .gp .nav-btns { display: flex; gap: 12px; align-items: center; }
      
      .gp .btn-dashboard { display: flex; align-items: center; gap: 10px; padding: 6px 16px 6px 6px; background: #fff; border: 1px solid #e2e8f0; border-radius: 30px; font-size: 14px; font-weight: 600; color: #1e293b; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.3s ease; }
      .gp .btn-dashboard:hover { border-color: #cbd5e1; box-shadow: 0 4px 6px rgba(0,0,0,0.04); transform: translateY(-1px); }
      .gp .btn-dashboard .avatar-sm { width: 28px; height: 28px; border-radius: 50%; background: #ea580c; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; }
      .gp .btn-logout { padding: 8px 16px; background: transparent; border: 1px solid transparent; color: #64748b; font-size: 14px; font-weight: 600; border-radius: 8px; transition: all 0.3s ease; }
      .gp .btn-logout:hover { background: #fef2f2; color: #ef4444; border-color: #fecaca; }

      .gp button { font-family: inherit; transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
      .gp .btn-outline { padding: 8px 18px; border: 1px solid #cbd5e1; border-radius: 8px; color: #475569; font-size: 14px; font-weight: 600; background: #fff; transition: all 0.3s ease; }
      .gp .btn-outline:hover { background: #f1f5f9; transform: translateY(-1px); border-color: #94a3b8; color: #1e293b; }
      .gp .btn-primary { padding: 8px 18px; border: none; border-radius: 8px; background: #ea580c; color: #fff; font-size: 14px; font-weight: 600; box-shadow: 0 4px 12px rgba(234, 88, 12, 0.2); transition: all 0.3s ease; }
      .gp .btn-primary:hover { background: #c2410c; transform: translateY(-1px); box-shadow: 0 6px 16px rgba(234, 88, 12, 0.3); }

      .gp .hero { display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: center; padding: 5rem 2rem 4rem; max-width: 1200px; margin: 0 auto; }
      .gp .hero-tag { display: inline-flex; align-items: center; gap: 6px; background: #fff7ed; color: #c2410c; border: 1px solid #fed7aa; border-radius: 20px; padding: 5px 14px; font-size: 13px; font-weight: 600; margin-bottom: 1.25rem; }
      .gp .hero-tag span { width: 7px; height: 7px; border-radius: 50%; background: #ea580c; display: inline-block; box-shadow: 0 0 0 3px rgba(234,88,12,0.2); }
      .gp .hero h1 { font-size: 56px; font-weight: 800; line-height: 1.1; color: #0f172a; margin-bottom: 1.25rem; letter-spacing: -1px; }
      .gp .hero h1 em { color: #ea580c; font-style: normal; }
      .gp .hero p { font-size: 16px; color: #64748b; line-height: 1.75; max-width: 420px; margin-bottom: 2rem; }
      .gp .hero-btns { display: flex; gap: 12px; align-items: center; }
      
      .gp .btn-lg { display: inline-block; text-align: center; padding: 14px 28px; background: #ea580c; color: #fff; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; box-shadow: 0 8px 20px rgba(234, 88, 12, 0.25); transition: all 0.3s ease; }
      .gp .btn-lg:hover { background: #c2410c; transform: translateY(-2px); box-shadow: 0 12px 24px rgba(234, 88, 12, 0.35); }
      .gp .btn-ghost { display: inline-block; text-align: center; padding: 14px 28px; background: #fff; color: #1e293b; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 16px; font-weight: 600; transition: all 0.3s ease; }
      .gp .btn-ghost:hover { background: #f8fafc; transform: translateY(-2px); border-color: #cbd5e1; }
      
      .gp .hero-img { display: flex; justify-content: flex-end; position: relative; }
      .gp .hero-img img { width: 100%; max-width: 440px; animation: float 6s ease-in-out infinite; }
      @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-15px); } 100% { transform: translateY(0px); } }
      
      .gp .float-card { position: absolute; background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 14px 18px; font-size: 13px; font-weight: 600; color: #1e293b; display: flex; align-items: center; gap: 10px; min-width: 160px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
      .gp .float-card:hover { transform: translateY(-5px) scale(1.02); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
      .gp .float-card .icon { width: 36px; height: 36px; border-radius: 9px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
      .gp .fc1 { top: 30px; right: 0; }
      .gp .fc2 { bottom: 80px; right: 20px; }
      .gp .fc3 { bottom: 10px; right: 100px; background: #fff7ed; border-color: #fed7aa; }

      /* REDESIGNED & RE-SCALED LIVE COUNTER STATS SECTION */
      .gp .live-stats { background: #fff; padding: 4rem 2rem; border-top: 1px solid #e2e8f0; border-bottom: 1px solid #e2e8f0; position: relative; }
      .gp .stats-grid { max-width: 900px; margin: 0 auto; display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; text-align: center; }
      .gp .stat-box { padding: 2rem 1.5rem; background: #fff; border: 1px solid #e2e8f0; border-radius: 20px; transition: transform 0.3s ease, box-shadow 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
      .gp .stat-box:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,0,0,0.06); border-color: #cbd5e1; }
      .gp .stat-icon { width: 48px; height: 48px; border-radius: 12px; margin: 0 auto 1.25rem; display: flex; align-items: center; justify-content: center; position: relative; }
      .gp .stat-icon svg { width: 24px; height: 24px; stroke-width: 2.5; position: relative; z-index: 2; }
      
      /* Subtle, Theme-Aligned Icons */
      .gp .theme-slate { background: #f1f5f9; color: #475569; }
      .gp .theme-green { background: #ecfdf5; color: #10b981; }
      
      /* Only the "Active" icon gets the subtle orange pulse to draw attention */
      .gp .theme-orange { background: #fff7ed; color: #ea580c; }
      .gp .theme-orange::before { content: ''; position: absolute; inset: 0; border-radius: 12px; box-shadow: 0 0 0 0 rgba(234,88,12,0.3); animation: pulseOrange 2s infinite; }
      @keyframes pulseOrange { 70% { box-shadow: 0 0 0 10px rgba(234,88,12,0); } 100% { box-shadow: 0 0 0 0 rgba(234,88,12,0); } }

      .gp .stat-num { font-size: 42px; font-weight: 800; color: #0f172a; line-height: 1; letter-spacing: -1px; font-variant-numeric: tabular-nums; }
      .gp .stat-label { font-size: 13px; color: #64748b; margin-top: 8px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }

      .gp .section { max-width: 1200px; margin: 0 auto; padding: 5rem 2rem; }
      .gp .section-label { font-size: 13px; font-weight: 800; color: #ea580c; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 10px; display: inline-block; }
      .gp .section-title { font-size: 38px; font-weight: 800; color: #0f172a; margin-bottom: 12px; letter-spacing: -0.5px; }
      .gp .section-sub { font-size: 16px; color: #64748b; max-width: 540px; line-height: 1.7; font-weight: 500;}

      .gp .steps { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-top: 3.5rem; position: relative; }
      .gp .steps::before { content: ''; position: absolute; top: 44px; left: calc(12.5% + 24px); right: calc(12.5% + 24px); height: 2px; background: repeating-linear-gradient(to right, #e2e8f0 0, #e2e8f0 8px, transparent 8px, transparent 16px); }
      .gp .step-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 2rem 1.5rem; text-align: center; position: relative; transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
      .gp .step-card:hover { border-color: #fed7aa; transform: translateY(-8px); box-shadow: 0 12px 24px rgba(234,88,12,0.06); }
      .gp .step-num { width: 48px; height: 48px; border-radius: 50%; background: #fff7ed; border: 2px solid #fed7aa; color: #ea580c; font-size: 18px; font-weight: 800; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.25rem; z-index: 2; position: relative; box-shadow: 0 0 0 6px #fff; }
      .gp .step-card h3 { font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
      .gp .step-card p { font-size: 14px; color: #64748b; line-height: 1.6; }

      .gp .depts-bg { background: #f1f5f9; padding: 5rem 0; border-top: 1px solid #e2e8f0; border-bottom: 1px solid #e2e8f0; scroll-margin-top: 80px; }
      .gp .dept-tabs { display: flex; gap: 6px; margin-top: 2rem; background: #e2e8f0; padding: 6px; border-radius: 12px; width: fit-content; }
      .gp .dept-tab { padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; color: #64748b; border: none; background: transparent; transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
      .gp .dept-tab.active { background: #ea580c; color: #fff; box-shadow: 0 4px 10px rgba(234, 88, 12, 0.25); }
      .gp .dept-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-top: 2.5rem; }
      
      .gp .dept-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.75rem; transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); position: relative; overflow: hidden; }
      .gp .dept-card:hover { border-color: #ea580c; transform: translateY(-6px); box-shadow: 0 15px 30px rgba(0,0,0,0.06); }
      .gp .dept-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: #ea580c; opacity: 0; transition: opacity 0.3s ease; }
      .gp .dept-card:hover::before { opacity: 1; }
      .gp .dept-icon { width: 48px; height: 48px; border-radius: 12px; background: #fff7ed; display: flex; align-items: center; justify-content: center; margin-bottom: 1.25rem; color: #ea580c; }
      .gp .dept-icon svg { width: 24px; height: 24px; stroke-width: 2; }
      
      .gp .dept-card h3 { font-size: 17px; font-weight: 700; color: #1e293b; margin-bottom: 6px; }
      .gp .dept-card p { font-size: 14px; color: #64748b; margin-bottom: 1.25rem; line-height: 1.6; }
      .gp .dept-meta { display: flex; align-items: center; justify-content: space-between; padding-top: 1rem; border-top: 1px solid #f1f5f9; }
      .gp .badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
      .gp .badge-green { background: #dcfce7; color: #15803d; }
      .gp .badge-amber { background: #fef9c3; color: #854d0e; }
      .gp .badge-blue { background: #dbeafe; color: #1d4ed8; }
      .gp .dept-rate { font-size: 13px; font-weight: 700; color: #ea580c; }

      .gp .testimonials-container { scroll-margin-top: 100px; }
      .gp .testi-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-top: 3rem; }
      .gp .testi-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 2rem; box-shadow: 0 4px 6px rgba(0,0,0,0.02); transition: all 0.3s ease; }
      .gp .testi-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,0,0,0.05); border-color: #cbd5e1; }
      .gp .stars { color: #f59e0b; font-size: 16px; margin-bottom: 16px; letter-spacing: 2px; }
      .gp .testi-card p { font-size: 15px; color: #475569; line-height: 1.7; margin-bottom: 1.5rem; font-style: italic; }
      .gp .testi-user { display: flex; align-items: center; gap: 12px; }
      .gp .avatar { width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; flex-shrink: 0; }
      .gp .av-o { background: #fff7ed; color: #c2410c; }
      .gp .av-s { background: #f0fdf4; color: #15803d; }
      .gp .av-b { background: #eff6ff; color: #1d4ed8; }
      .gp .testi-name { font-size: 15px; font-weight: 700; color: #1e293b; }
      .gp .testi-role { font-size: 13px; color: #94a3b8; margin-top: 2px; }

      .gp .faq-container { scroll-margin-top: 80px; }
      .gp .faq-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; margin-top: 3rem; }
      .gp .faq-item { background: #fff; border: 1px solid #e2e8f0; border-radius: 14px; padding: 1.5rem; transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
      .gp .faq-item:hover { border-color: #fed7aa; box-shadow: 0 4px 12px rgba(234, 88, 12, 0.05); }
      .gp .faq-q { display: flex; justify-content: space-between; align-items: center; gap: 12px; pointer-events: none; }
      .gp .faq-q span { font-size: 16px; font-weight: 700; color: #1e293b; }
      .gp .faq-toggle { width: 28px; height: 28px; border-radius: 50%; background: #fff7ed; border: none; color: #ea580c; font-size: 18px; display: flex; align-items: center; justify-content: center; font-weight: 500; transition: transform 0.3s ease; }
      .gp .faq-ans { font-size: 14px; color: #64748b; margin-top: 12px; line-height: 1.7; display: none; }
      .gp .faq-item.open .faq-ans { display: block; animation: fadeIn 0.3s ease; }
      .gp .faq-item.open .faq-toggle { transform: rotate(45deg); background: #ea580c; color: #fff; }
      @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }

      .gp .cta-section { background: #0f172a; padding: 6rem 2rem; text-align: center; }
      .gp .cta-inner { max-width: 600px; margin: 0 auto; }
      .gp .cta-section h2 { font-size: 42px; font-weight: 800; color: #fff; margin-bottom: 16px; letter-spacing: -1px; }
      .gp .cta-section h2 span { color: #fb923c; }
      .gp .cta-section p { font-size: 16px; color: #94a3b8; margin-bottom: 2.5rem; line-height: 1.7; }
      .gp .cta-btns { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }
      .gp .btn-ghost-dark { display: inline-block; padding: 14px 28px; background: transparent; color: #fff; border: 1px solid #334155; border-radius: 10px; font-size: 16px; font-weight: 600; transition: all 0.3s ease; }
      .gp .btn-ghost-dark:hover { background: #1e293b; border-color: #475569; transform: translateY(-2px); }

      .gp footer { background: #0f172a; padding: 4rem 2rem 2rem; border-top: 1px solid #1e293b; }
      .gp .footer-inner { max-width: 1200px; margin: 0 auto; }
      .gp .footer-top { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 3rem; padding-bottom: 3rem; border-bottom: 1px solid #1e293b; }
      .gp .footer-brand p { font-size: 14px; color: #64748b; margin-top: 16px; line-height: 1.7; max-width: 300px; }
      .gp .footer-col h4 { font-size: 13px; font-weight: 800; color: #e2e8f0; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 16px; }
      .gp .footer-col a { display: block; font-size: 14px; color: #94a3b8; margin-bottom: 12px; transition: color 0.2s; font-weight: 500; }
      .gp .footer-col a:hover { color: #fb923c; }
      .gp .footer-bottom { display: flex; justify-content: space-between; align-items: center; padding-top: 2rem; }
      .gp .footer-bottom p { font-size: 14px; color: #64748b; font-weight: 500; }
      .gp .footer-bottom span { color: #ea580c; }
      .gp .social-links { display: flex; gap: 12px; }
      .gp .social-btn { width: 36px; height: 36px; border-radius: 8px; background: #1e293b; border: 1px solid #334155; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease; }
      .gp .social-btn:hover { background: #ea580c; border-color: #ea580c; transform: translateY(-2px); }
      .gp .social-btn svg { width: 16px; height: 16px; fill: #94a3b8; transition: fill 0.3s ease; }
      .gp .social-btn:hover svg { fill: #fff; }
    </style>
</head>
<body>

<div class="gp">

  <div class="announcement-bar">
    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"></path></svg>
    Maintenance Scheduled for IT Portal on Sunday. <a href="#">Read Details</a>
  </div>

  <nav>
    <div class="nav-inner">
        <a href="index.jsp" class="logo">
          <div class="logo-circle">G</div>
          <span class="logo-text">Grievance<span>.edu</span></span>
        </a>
        <div class="nav-links">
          <a href="index.jsp" class="active">Home</a>
          <a href="#departments">Departments</a>
          <a href="#testimonials">Complaints</a>
          <a href="#faqs">FAQ's</a>
        </div>
        <div class="nav-btns">
          <% if (currentUser == null) { %>
              <a href="login.jsp" class="btn-outline">Sign in</a>
              <a href="register.jsp" class="btn-primary">Join now</a>
          <% } else { 
              String dashLink = "admin".equals(currentUser.getRole()) ? "admin_dashboard.jsp" : "user_dashboard.jsp";
          %>
              <a href="<%= dashLink %>" class="btn-dashboard">
                  <div class="avatar-sm">
                      <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                  </div>
                  Dashboard
              </a>
              <a href="LogoutServlet" class="btn-logout">
                  Logout
              </a>
          <% } %>
        </div>
    </div>
  </nav>

  <div>
    <div class="hero">
      <div>
        <div class="hero-tag"><span></span> New — Track complaints in real-time</div>
        <h1>Online<br><em>Complaint Portal</em></h1>
        <p>The only place where your complaints are precious to us! If you have a grievance regarding academics, hostel, or IT — you are at the right place.</p>
        <div class="hero-btns">
          <a href="submit_complaint.jsp" class="btn-lg">Register Complaint</a>
          <a href="user_dashboard.jsp" class="btn-ghost">Track Status</a>
        </div>
      </div>
      <div class="hero-img">
        <img src="https://illustrations.popsy.co/amber/freelancer.svg" alt="Student working"/>
        
        <div class="float-card fc1">
          <div class="icon" style="background:#fff7ed; color:#ea580c">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
          </div>
          Submit complaint
        </div>
        
        <div class="float-card fc2">
          <div class="icon" style="background:#f0fdf4; color:#16a34a">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
          </div>
          Admin responds
        </div>
        
        <div class="float-card fc3">
          <div class="icon" style="background:#fff; color:#ea580c">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          </div>
          Complaint resolved!
        </div>
      </div>
    </div>
  </div>

  <div class="live-stats" id="stats-section">
    <div class="stats-grid">
      <div class="stat-box">
        <div class="stat-icon theme-slate">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
        </div>
        <div class="stat-num counter" data-target="<%= totalComplaints %>">0</div>
        <div class="stat-label">Total Registered</div>
      </div>
      <div class="stat-box" style="border-color: #fed7aa; box-shadow: 0 4px 12px rgba(234, 88, 12, 0.05);">
        <div class="stat-icon theme-orange">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        </div>
        <div class="stat-num counter" data-target="<%= activeComplaints %>">0</div>
        <div class="stat-label" style="color: #ea580c;">Active & Pending</div>
      </div>
      <div class="stat-box">
        <div class="stat-icon theme-green">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        </div>
        <div class="stat-num counter" data-target="<%= resolvedComplaints %>">0</div>
        <div class="stat-label">Successfully Closed</div>
      </div>
    </div>
  </div>

  <div class="section">
    <div class="section-label">How it works</div>
    <div style="display:flex;justify-content:space-between;align-items:flex-end;flex-wrap:wrap;gap:1rem">
      <div>
        <div class="section-title">Simple 4-step process</div>
        <div class="section-sub">From registering your complaint to getting it resolved — here's how the system works for you.</div>
      </div>
    </div>
    
    <div class="steps">
      <div class="step-card">
        <div class="step-num">01</div>
        <h3>Create Account</h3>
        <p>Register with your institutional email to get access to the portal.</p>
      </div>
      <div class="step-card">
        <div class="step-num">02</div>
        <h3>Submit Complaint</h3>
        <p>Choose your department, describe your issue, and attach documents.</p>
      </div>
      <div class="step-card">
        <div class="step-num">03</div>
        <h3>Track Progress</h3>
        <p>Get real-time updates and notifications as your issue moves forward.</p>
      </div>
      <div class="step-card">
        <div class="step-num">04</div>
        <h3>Get Resolved</h3>
        <p>Receive the admin's response and close the complaint securely.</p>
      </div>
    </div>
  </div>

  <div class="depts-bg" id="departments">
    <div class="section" style="padding-top:0;padding-bottom:0">
      <div class="section-label">Departments</div>
      <div style="display:flex;justify-content:space-between;align-items:flex-end;flex-wrap:wrap;gap:1rem">
        <div>
          <div class="section-title">Top Departments</div>
          <div class="section-sub">Departments with the highest resolution rates and student satisfaction.</div>
        </div>
        <div class="dept-tabs">
          <button class="dept-tab active" onclick="setTab(this,'responsive')">Most Responsive</button>
          <button class="dept-tab" onclick="setTab(this,'satisfaction')">By Satisfaction</button>
          <button class="dept-tab" onclick="setTab(this,'resolved')">Most Resolved</button>
        </div>
      </div>
      <div class="dept-grid" id="dept-grid">
        </div>
    </div>
  </div>

  <div class="section testimonials-container" id="testimonials">
    <div class="section-label">Student voices</div>
    <div class="section-title">What students say</div>
    <div class="section-sub">Real feedback from students who used the portal to get their issues resolved.</div>
    <div class="testi-grid">
      <div class="testi-card">
        <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
        <p>"My hostel maintenance issue was resolved within 24 hours. The portal made it so easy to communicate with the warden's office directly."</p>
        <div class="testi-user">
          <div class="avatar av-o">AR</div>
          <div><div class="testi-name">Aryan Rao</div><div class="testi-role">3rd Year — Computer Science</div></div>
        </div>
      </div>
      <div class="testi-card">
        <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
        <p>"I had a problem with my examination schedule. The academics department responded in under a day and sorted it before the exam."</p>
        <div class="testi-user">
          <div class="avatar av-s">PS</div>
          <div><div class="testi-name">Priya Singh</div><div class="testi-role">2nd Year — Mechanical Engg.</div></div>
        </div>
      </div>
      <div class="testi-card">
        <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9734;</div>
        <p>"The IT department fixed my library portal login issue quickly. Real-time tracking meant I wasn't left wondering about the status."</p>
        <div class="testi-user">
          <div class="avatar av-b">KM</div>
          <div><div class="testi-name">Karan Mehta</div><div class="testi-role">4th Year — Civil Engg.</div></div>
        </div>
      </div>
    </div>
  </div>

  <div style="background:#f1f5f9;padding:5rem 0" class="faq-container" id="faqs">
    <div class="section" style="padding-top:0;padding-bottom:0">
      <div class="section-label">Support</div>
      <div class="section-title">Frequently asked questions</div>
      <div class="section-sub">Got questions? We've got answers. If you don't find what you need, reach out to admin.</div>
      <div class="faq-grid" id="faq-grid"></div>
    </div>
  </div>

  <div class="cta-section">
    <div class="cta-inner">
      <h2>Ready to raise your <span>concern?</span></h2>
      <p>Join thousands of students who've already used the portal to get their issues heard and resolved by the right people.</p>
      <div class="cta-btns">
        <a href="submit_complaint.jsp" class="btn-lg">Register a Complaint</a>
        <a href="#departments" class="btn-ghost-dark">Browse Departments</a>
      </div>
    </div>
  </div>

  <footer>
    <div class="footer-inner">
      <div class="footer-top">
        <div class="footer-brand">
          <a href="index.jsp" class="logo">
            <div class="logo-circle" style="color:#fb923c; border-color:#fb923c">G</div>
            <span class="logo-text" style="color:#fff">Grievance<span style="color:#fb923c">.edu</span></span>
          </a>
          <p>A student-first complaint management system built to make institutional issues resolve faster and more transparently.</p>
        </div>
        <div class="footer-col">
          <h4>Portal</h4>
          <a href="#">Home</a>
          <a href="#departments">Departments</a>
          <a href="submit_complaint.jsp">Submit Complaint</a>
          <a href="user_dashboard.jsp">Track Status</a>
        </div>
        <div class="footer-col">
          <h4>Support</h4>
          <a href="#faqs">FAQ's</a>
          <a href="#">Contact Admin</a>
          <a href="#">Help Center</a>
          <a href="#">Report a Bug</a>
        </div>
        <div class="footer-col">
          <h4>Legal</h4>
          <a href="#">Privacy Policy</a>
          <a href="#">Terms of Use</a>
          <a href="#">Accessibility</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 Grievance.edu &mdash; Made with <span>&hearts;</span> for students</p>
        <div class="social-links">
          <div class="social-btn">
            <svg viewBox="0 0 24 24"><path d="M24 4.56v14.91A4.56 4.56 0 0119.44 24H4.56A4.56 4.56 0 010 19.47V4.56A4.56 4.56 0 014.56 0h14.88A4.56 4.56 0 0124 4.56zM8 19V9H5v10h3zm-1.5-11.4a1.6 1.6 0 100-3.2 1.6 1.6 0 000 3.2zM19 19v-5.5c0-2.5-1.4-3.7-3.3-3.7a3 3 0 00-2.7 1.5V9h-3v10h3v-5.4c0-1.2.9-2.1 2-2.1s2 .9 2 2.1V19h2z"/></svg>
          </div>
          <div class="social-btn">
            <svg viewBox="0 0 24 24"><path d="M23.95 4.57a10 10 0 01-2.82.77 4.96 4.96 0 002.16-2.72c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg>
          </div>
          <div class="social-btn">
            <svg viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/></svg>
          </div>
        </div>
      </div>
    </div>
  </footer>

</div>

<script>
// Live Database Counters Animation
const statCounters = document.querySelectorAll('.counter');
const statsSection = document.getElementById('stats-section');
let animated = false;

const observer = new IntersectionObserver((entries) => {
    if(entries[0].isIntersecting && !animated) {
        animated = true;
        statCounters.forEach(counter => {
            const target = parseInt(counter.getAttribute('data-target')) || 0;
            // Catch for empty database so it doesn't loop infinitely
            if (target === 0) {
                counter.innerText = "0";
                return;
            }
            const duration = 2000; 
            const increment = target / (duration / 16); 
            let current = 0;
            
            const updateCounter = () => {
                current += increment;
                if(current < target) {
                    counter.innerText = Math.ceil(current);
                    requestAnimationFrame(updateCounter);
                } else {
                    counter.innerText = target;
                }
            };
            updateCounter();
        });
    }
}, { threshold: 0.5 }); 

if(statsSection) observer.observe(statsSection);

// Department Tabs Logic
const icons = {
  academics: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 14l9-5-9-5-9 5 9 5z"></path><path stroke-linecap="round" stroke-linejoin="round" d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z"></path></svg>',
  hostel: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>',
  it: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>',
  library: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477-4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>',
  canteen: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 15.546c-.523 0-1.046.151-1.5.454a2.704 2.704 0 01-3 0 2.704 2.704 0 00-3 0 2.704 2.704 0 01-3 0 2.704 2.704 0 00-3 0 2.704 2.704 0 01-3 0 2.701 2.701 0 00-1.5-.454M9 6v2m3-2v2m3-2v2M9 3h.01M12 3h.01M15 3h.01M21 21v-7a2 2 0 00-2-2H5a2 2 0 00-2 2v7h18zm-3-9v-2a2 2 0 00-2-2H8a2 2 0 00-2 2v2h12z"></path></svg>',
  health: '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>'
};

const depts = {
  responsive: [
    { icon: icons.academics, name: 'Academics', desc: 'Grade disputes, syllabus issues, and timetable conflicts.', badge: 'badge-green', badgeText: 'Fast Response', rate: '97% resolved' },
    { icon: icons.hostel, name: 'Hostel & Housing', desc: 'Room allocations, maintenance, and amenity complaints.', badge: 'badge-amber', badgeText: 'Active', rate: '91% resolved' },
    { icon: icons.it, name: 'IT & Systems', desc: 'Network issues, portal access, and device support.', badge: 'badge-blue', badgeText: '24/7 Support', rate: '95% resolved' },
    { icon: icons.library, name: 'Library', desc: 'Book availability, fines, and digital access issues.', badge: 'badge-green', badgeText: 'Fast Response', rate: '98% resolved' },
    { icon: icons.canteen, name: 'Canteen & Food', desc: 'Food quality, hygiene, and pricing concerns.', badge: 'badge-amber', badgeText: 'Active', rate: '88% resolved' },
    { icon: icons.health, name: 'Health Center', desc: 'Medical aid, counselling, and health facility issues.', badge: 'badge-green', badgeText: 'Priority', rate: '96% resolved' },
  ],
  satisfaction: [
    { icon: icons.library, name: 'Library', desc: 'Book availability, fines, and digital access issues.', badge: 'badge-green', badgeText: 'Top Rated', rate: '4.9 / 5.0' },
    { icon: icons.health, name: 'Health Center', desc: 'Medical aid, counselling, and health facility issues.', badge: 'badge-green', badgeText: 'Top Rated', rate: '4.8 / 5.0' },
    { icon: icons.it, name: 'IT & Systems', desc: 'Network issues, portal access, and device support.', badge: 'badge-blue', badgeText: 'Rated 4.7', rate: '4.7 / 5.0' },
    { icon: icons.academics, name: 'Academics', desc: 'Grade disputes, syllabus issues, and timetable conflicts.', badge: 'badge-amber', badgeText: 'Rated 4.5', rate: '4.5 / 5.0' },
    { icon: icons.hostel, name: 'Hostel & Housing', desc: 'Room allocations, maintenance, and amenity complaints.', badge: 'badge-amber', badgeText: 'Rated 4.2', rate: '4.2 / 5.0' },
    { icon: icons.canteen, name: 'Canteen & Food', desc: 'Food quality, hygiene, and pricing concerns.', badge: 'badge-amber', badgeText: 'Rated 4.0', rate: '4.0 / 5.0' },
  ],
  resolved: [
    { icon: icons.hostel, name: 'Hostel & Housing', desc: 'Room allocations, maintenance, and amenity complaints.', badge: 'badge-blue', badgeText: '2,410 cases', rate: 'Most complaints' },
    { icon: icons.academics, name: 'Academics', desc: 'Grade disputes, syllabus issues, and timetable conflicts.', badge: 'badge-blue', badgeText: '1,980 cases', rate: '2nd most' },
    { icon: icons.it, name: 'IT & Systems', desc: 'Network issues, portal access, and device support.', badge: 'badge-green', badgeText: '1,605 cases', rate: '3rd most' },
    { icon: icons.library, name: 'Library', desc: 'Book availability, fines, and digital access issues.', badge: 'badge-amber', badgeText: '870 cases', rate: '4th most' },
    { icon: icons.canteen, name: 'Canteen & Food', desc: 'Food quality, hygiene, and pricing concerns.', badge: 'badge-amber', badgeText: '640 cases', rate: '5th most' },
    { icon: icons.health, name: 'Health Center', desc: 'Medical aid, counselling, and health facility issues.', badge: 'badge-green', badgeText: '510 cases', rate: '6th most' },
  ]
};

function renderDepts(key){
  const g = document.getElementById('dept-grid');
  g.innerHTML = depts[key].map(function(d, index) {
    return '<div class="dept-card" style="animation: fadeIn 0.4s ease forwards; animation-delay: ' + (index * 0.05) + 's; opacity: 0;">' +
      '<div class="dept-icon">' + d.icon + '</div>' +
      '<h3>' + d.name + '</h3>' +
      '<p>' + d.desc + '</p>' +
      '<div class="dept-meta">' +
        '<span class="badge ' + d.badge + '">' + d.badgeText + '</span>' +
        '<span class="dept-rate">' + d.rate + '</span>' +
      '</div>' +
    '</div>';
  }).join('');
}
renderDepts('responsive');

function setTab(el, key){
  document.querySelectorAll('.dept-tab').forEach(function(t) { t.classList.remove('active'); });
  el.classList.add('active');
  renderDepts(key);
}

// FAQ Logic
const faqs = [
  { q: 'Who can submit a complaint?', a: 'Any currently enrolled student with a valid institutional email address can register an account and submit complaints.' },
  { q: 'How long does it take to get a response?', a: 'Most departments respond within 48 hours. Priority complaints (health, safety) are addressed within 24 hours.' },
  { q: 'Can I submit anonymous complaints?', a: 'Yes, the portal supports anonymous submissions for sensitive issues. You will still receive a case ID for tracking.' },
  { q: 'What happens after my complaint is submitted?', a: 'It is assigned to the relevant department head, who reviews and responds. You are notified at every stage via email.' },
  { q: 'Can I reopen a closed complaint?', a: 'Yes. If you are unsatisfied with the resolution, you can reopen the complaint within 7 days of closure.' },
  { q: 'Is my data kept private?', a: 'All complaint data is encrypted and only visible to the relevant department admins and institutional authorities.' },
];

const fg = document.getElementById('faq-grid');
fg.innerHTML = faqs.map(function(f, i) {
  return '<div class="faq-item" id="faq' + i + '" onclick="toggleFaq(' + i + ')">' +
    '<div class="faq-q">' +
      '<span>' + f.q + '</span>' +
      '<button class="faq-toggle" id="ftog' + i + '">' +
        '<svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path></svg>' +
      '</button>' +
    '</div>' +
    '<div class="faq-ans">' + f.a + '</div>' +
  '</div>';
}).join('');

function toggleFaq(i){
  const el = document.getElementById('faq'+i);
  const open = el.classList.contains('open');
  
  document.querySelectorAll('.faq-item').forEach(function(item) {
    item.classList.remove('open');
    item.querySelector('.faq-toggle').style.transform = 'rotate(0deg)';
  });

  if (!open) {
    el.classList.add('open');
  }
}
</script>
</body>
</html>