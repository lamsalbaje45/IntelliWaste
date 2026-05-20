<%@ page contentType="text/html;charset=UTF-8" %>
<% String ctx = request.getContextPath(); %>
<html>
<head>
    <title>Login - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        @import url("https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Space+Grotesk:wght@400;500;600;700&display=swap");

        :root {
            --ink: #0b2b22;
            --leaf: #1f7a5c;
            --river: #1e6aa8;
            --sun: #f7c948;
            --mist: #e6f4ef;
            --white: #ffffff;
        }
        * { box-sizing: border-box; }
        body {
            font-family: "Space Grotesk", "Segoe UI", sans-serif;
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 32px 20px;
            background:
                radial-gradient(circle at 15% 20%, #c2f0dc 0%, transparent 45%),
                radial-gradient(circle at 85% 10%, #b8d8ff 0%, transparent 40%),
                linear-gradient(140deg, #f6fff9 0%, #ecf7ff 100%);
        }
        .auth-shell {
            width: min(980px, 100%);
            background: var(--white);
            border-radius: 22px;
            overflow: hidden;
            display: grid;
            grid-template-columns: minmax(240px, 1.1fr) minmax(280px, 1fr);
            box-shadow: 0 22px 48px rgba(9, 32, 24, 0.16);
            border: 1px solid #e4efe9;
        }
        .auth-side {
            padding: 36px 32px;
            color: #f5fffb;
            background:
                linear-gradient(135deg, rgba(10, 30, 24, 0.75) 0%, rgba(12, 48, 74, 0.7) 100%),
                url("<%= ctx %>/assets/LoginPageImage.png") center/cover no-repeat;
            position: relative;
        }
        .auth-side::after {
            content: "";
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 20% 20%, rgba(247, 201, 72, 0.35) 0%, transparent 55%);
            opacity: 0.75;
        }
        .auth-side > * { position: relative; z-index: 1; }
        .auth-brand {
            font-family: "DM Serif Display", "Space Grotesk", serif;
            font-size: 30px;
            margin: 0 0 12px;
        }
        .auth-tag {
            display: inline-flex;
            padding: 6px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.22);
            font-weight: 600;
            font-size: 12px;
        }
        .auth-side p { margin: 16px 0 0; line-height: 1.6; }
        .auth-list { margin: 18px 0 0; padding-left: 18px; line-height: 1.7; }

        .auth-card {
            padding: 34px 32px 36px;
        }
        .auth-card h2 { margin: 0 0 6px; color: var(--ink); font-size: 26px; }
        .auth-card p { margin: 0 0 18px; color: #425f55; }
        .auth-card .error { color: #c92a2a; }
        .auth-card .success { color: #2f9e44; }
        label { display: block; font-weight: 600; margin: 10px 0 6px; }
        input {
            width: 100%;
            padding: 11px 12px;
            border-radius: 10px;
            border: 1px solid #cfe1d8;
            background: #f9fffc;
            transition: border 0.2s ease, box-shadow 0.2s ease;
        }
        input:focus { outline: none; border-color: #1f7a5c; box-shadow: 0 0 0 3px rgba(31, 122, 92, 0.15); }
        button {
            width: 100%;
            margin-top: 16px;
            padding: 12px 16px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #1f7a5c 0%, #1a6e55 100%);
            color: #ffffff;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 12px 24px rgba(31, 122, 92, 0.25);
        }
        button:hover { filter: brightness(1.05); }
        .error { color: #c92a2a; margin: 10px 0; }
        .success { color: #2f9e44; margin: 10px 0; }
        .links { text-align: center; margin-top: 14px; color: #425f55; }
        .links a { color: #1f7a5c; text-decoration: none; font-weight: 600; }

        @media (max-width: 820px) {
            .auth-shell { grid-template-columns: 1fr; }
            .auth-side { padding: 28px 26px; }
            .auth-card { padding: 28px 26px 32px; }
        }
        @media (max-width: 520px) {
            body { padding: 18px; }
            .auth-card h2 { font-size: 22px; }
        }
    </style>
</head>
<body>
<div class="auth-shell">
    <aside class="auth-side">
        <div class="auth-tag">Smart waste operations</div>
        <h1 class="auth-brand">IntelliWaste</h1>
        <p>Welcome back. Manage reports, track assignments, and keep your city cleaner with real-time updates.</p>
        <ul class="auth-list">
            <li>Instant issue reporting</li>
            <li>Live status tracking</li>
            <li>Verified cleanup updates</li>
        </ul>
    </aside>
    <section class="auth-card">
        <h2>Login</h2>
        <p>Access your dashboard and continue making impact.</p>

        <% if (session.getAttribute("success") != null) { %>
            <p class="success"><%= session.getAttribute("success") %></p>
            <% session.removeAttribute("success"); %>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <p class="success"><%= request.getAttribute("success") %></p>
        <% } %>

        <form action="<%= ctx %>/user-auth" method="post">
            <input type="hidden" name="action" value="login"/>
            <label for="email">Email</label>
            <input id="email" type="email" name="email" placeholder="you@example.com" required autofocus/>
            <label for="password">Password</label>
            <input id="password" type="password" name="password" placeholder="Your password" required/>
            <button type="submit">Sign in</button>
        </form>

        <div class="links">
            New user? <a href="<%= ctx %>/views/register.jsp">Create an account</a>
        </div>
    </section>
</div>
</body>
</html>
