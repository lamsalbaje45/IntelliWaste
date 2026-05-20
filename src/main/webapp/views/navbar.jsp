<%@ page import="com.intelliwaste.user.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String navCtx = request.getContextPath();
%>
<style>
    @import url("https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap");

    :root {
        --nav-ink: #0b2b22;
        --nav-leaf: #1f7a5c;
        --nav-river: #1e6aa8;
        --nav-mist: #e7f5ef;
        --nav-white: #ffffff;
    }

    body:not(.home-page) {
        font-family: "Space Grotesk", "Segoe UI", sans-serif;
        margin: 0;
        background: #f5f7f6;
    }
    .container { padding: 24px; max-width: 1200px; margin: 0 auto; }
    .alert-success { background: #d3f9d8; color: #1f6b4f; padding: 12px; border-radius: 8px; margin-bottom: 16px; }
    .alert-error   { background: #ffe0e0; color: #c92a2a; padding: 12px; border-radius: 8px; margin-bottom: 16px; }
    .stats-row { display: flex; gap: 16px; margin: 24px 0; flex-wrap: wrap; }
    .stat-card { flex: 1 1 200px; background: white; padding: 20px; border-radius: 6px; min-width: 180px; }
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .table-wrap { width: 100%; overflow-x: auto; }
    .responsive-table { width: 100%; border-collapse: collapse; min-width: 720px; }
    .detail-table { width: 100%; border-collapse: collapse; }
    .detail-table td { vertical-align: top; padding: 8px; }
    .action-stack { display: inline-flex; gap: 6px; flex-wrap: wrap; }

    .navbar {
        background: linear-gradient(90deg, #0f3d2e 0%, #0b2b22 100%);
        color: var(--nav-white);
        padding: 14px 28px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        position: relative;
        z-index: 2;
    }
    .nav-left, .nav-right {
        display: flex;
        align-items: center;
        gap: 14px;
        flex-wrap: wrap;
    }
    .navbar a {
        color: var(--nav-white);
        text-decoration: none;
        font-weight: 500;
    }
    .navbar a:hover { color: #e2f7ef; }
    .navbar .brand {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        font-weight: 700;
        letter-spacing: 0.3px;
    }
    .brand-logo {
        height: 32px;
        width: 32px;
        object-fit: contain;
        display: block;
    }
    .nav-pill {
        padding: 6px 12px;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.12);
    }
    .navbar form { display: inline; margin: 0; }
    .nav-button, .nav-ghost {
        border-radius: 999px;
        padding: 8px 16px;
        font-weight: 600;
        border: 1px solid transparent;
        cursor: pointer;
        transition: transform 0.15s ease, background 0.15s ease;
    }
    .nav-ghost {
        background: transparent;
        color: var(--nav-white);
        border-color: rgba(255, 255, 255, 0.4);
    }
    .nav-ghost:hover { background: rgba(255, 255, 255, 0.15); transform: translateY(-1px); }
    .nav-button {
        background: #f7c948;
        color: #1f2d24;
        border-color: #f7c948;
        box-shadow: 0 6px 16px rgba(247, 201, 72, 0.35);
    }
    .nav-button:hover { background: #ffdd6e; transform: translateY(-1px); }
    .nav-user {
        font-size: 14px;
        opacity: 0.85;
    }
    .nav-menu {
        display: none;
        position: relative;
    }
    .nav-menu summary {
        list-style: none;
        cursor: pointer;
        padding: 8px 14px;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.4);
        color: var(--nav-white);
        font-weight: 600;
        background: rgba(255, 255, 255, 0.08);
    }
    .nav-menu summary::-webkit-details-marker {
        display: none;
    }
    .menu-panel {
        position: absolute;
        right: 0;
        top: calc(100% + 10px);
        background: #0f3d2e;
        border: 1px solid rgba(255, 255, 255, 0.15);
        border-radius: 12px;
        padding: 10px;
        min-width: 220px;
        box-shadow: 0 16px 32px rgba(8, 25, 20, 0.35);
        display: grid;
        gap: 6px;
        z-index: 10;
    }
    .menu-panel a,
    .menu-panel button {
        display: block;
        width: 100%;
        text-align: left;
        padding: 10px 12px;
        border-radius: 10px;
        background: rgba(255, 255, 255, 0.08);
        color: var(--nav-white);
        border: 1px solid transparent;
        text-decoration: none;
        font-weight: 600;
    }
    .menu-panel a:hover,
    .menu-panel button:hover {
        background: rgba(255, 255, 255, 0.18);
    }
    .menu-panel form { margin: 0; }
    .menu-panel .menu-user {
        font-size: 12px;
        opacity: 0.8;
        padding: 6px 8px 2px;
    }

    @media (max-width: 900px) {
        .stat-card { flex: 1 1 220px; }
    }
    @media (max-width: 720px) {
        .container { padding: 18px; }
        .stat-card { flex: 1 1 100%; }
        .form-grid { grid-template-columns: 1fr; }
        .responsive-table { min-width: 640px; }
        .nav-left .nav-pill,
        .nav-right { display: none; }
        .nav-menu { display: block; }
    }
    @media (max-width: 640px) {
        .responsive-table { min-width: 560px; }
        .detail-table tr { display: block; margin-bottom: 12px; }
        .detail-table td { display: block; width: 100%; padding: 6px 0; }
        .detail-table td:first-child { font-weight: 600; color: #2d5f3f; }
    }
</style>

<div class="navbar">
    <div class="nav-left">
        <a class="brand" href="<%= navCtx %>/index.jsp">
            <img class="brand-logo" src="<%= navCtx %>/assets/Logo.png" alt="IntelliWaste logo" />
            <span>IntelliWaste</span>
        </a>
        <a class="nav-pill" href="<%= navCtx %>/views/about.jsp">About</a>
        <a class="nav-pill" href="<%= navCtx %>/views/contact.jsp">Contact</a>
        <% if (navUser != null) {
            String role = navUser.getRole();
            String dash = "ADMIN".equals(role)  ? "/views/admin/dashboard.jsp"
                       : "WORKER".equals(role) ? "/views/worker/dashboard.jsp"
                       :                          "/views/user/dashboard.jsp";
        %>
            <a class="nav-pill" href="<%= navCtx + dash %>">Home</a>
            <a class="nav-pill" href="<%= navCtx %>/viewReports">All Reports</a>
        <% } %>
    </div>
    <div class="nav-right">
        <% if (navUser != null) { %>
            <span class="nav-user">Welcome, <%= navUser.getName() %> (<%= navUser.getRole() %>)</span>
            <form action="<%= navCtx %>/user-auth" method="post">
                <input type="hidden" name="action" value="logout"/>
                <button class="nav-ghost" type="submit">Logout</button>
            </form>
        <% } else { %>
            <a class="nav-ghost" href="<%= navCtx %>/views/login.jsp">Login</a>
            <a class="nav-button" href="<%= navCtx %>/views/register.jsp">Register</a>
        <% } %>
    </div>
    <details class="nav-menu">
        <summary aria-label="Open navigation menu">&#9776;</summary>
        <div class="menu-panel">
            <% if (navUser != null) { %>
                <div class="menu-user">Signed in as <%= navUser.getName() %> (<%= navUser.getRole() %>)</div>
            <% } %>
            <a href="<%= navCtx %>/views/about.jsp">About</a>
            <a href="<%= navCtx %>/views/contact.jsp">Contact</a>
            <% if (navUser != null) {
                String role = navUser.getRole();
                String dash = "ADMIN".equals(role)  ? "/views/admin/dashboard.jsp"
                           : "WORKER".equals(role) ? "/views/worker/dashboard.jsp"
                           :                          "/views/user/dashboard.jsp";
            %>
                <a href="<%= navCtx + dash %>">Home</a>
                <a href="<%= navCtx %>/viewReports">All Reports</a>
                <form action="<%= navCtx %>/user-auth" method="post">
                    <input type="hidden" name="action" value="logout"/>
                    <button type="submit">Logout</button>
                </form>
            <% } else { %>
                <a href="<%= navCtx %>/views/login.jsp">Login</a>
                <a href="<%= navCtx %>/views/register.jsp">Register</a>
            <% } %>
        </div>
    </details>
</div>
