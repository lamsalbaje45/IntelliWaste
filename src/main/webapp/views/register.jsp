<%@ page contentType="text/html;charset=UTF-8" %>
<% String ctx = request.getContextPath(); %>
<html>
<head>
    <title>Register - IntelliWaste</title>
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
                radial-gradient(circle at 10% 20%, #c2f0dc 0%, transparent 45%),
                radial-gradient(circle at 90% 15%, #b8d8ff 0%, transparent 40%),
                linear-gradient(140deg, #f6fff9 0%, #ecf7ff 100%);
        }
        .auth-shell {
            width: min(1040px, 100%);
            background: var(--white);
            border-radius: 22px;
            overflow: hidden;
            display: grid;
            grid-template-columns: minmax(260px, 1.1fr) minmax(320px, 1fr);
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
        .hint { font-size: 12px; color: #5a6a62; margin: 6px 0 12px; }
        button {
            width: 100%;
            margin-top: 14px;
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

        @media (max-width: 860px) {
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
        <div class="auth-tag">Community-first platform</div>
        <h1 class="auth-brand">Join IntelliWaste</h1>
        <p>Start reporting issues, follow progress, and keep your neighborhood clean.</p>
        <ul class="auth-list">
            <li>Citizen-first reporting flow</li>
            <li>Clear updates on every report</li>
            <li>Admin-assigned field support</li>
        </ul>
    </aside>
    <section class="auth-card">
        <h2>Create your account</h2>
        <p>It takes a minute. You can start reporting right away.</p>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="<%= ctx %>/user-auth" method="post">
            <input type="hidden" name="action" value="register"/>
            <label for="name">Full Name</label>
            <input id="name" type="text" name="name" placeholder="Full name" required/>
            <label for="email">Email</label>
            <input id="email" type="email" name="email" placeholder="you@example.com" required/>
                 <label for="phone">Phone (optional)</label>
                     <input id="phone" type="text" name="phone" placeholder="Phone number"
                         pattern="[0-9]{7,15}" title="Phone must be 7-15 digits"/>
            <label for="address">Address (optional)</label>
            <input id="address" type="text" name="address" placeholder="Street or neighborhood"/>
            <label for="password">Password</label>
            <input id="password" type="password" name="password" placeholder="At least 8 characters" required/>
            <p class="hint">New accounts are created as citizens. Admins can assign worker roles later.</p>
            <button type="submit">Create account</button>
        </form>

        <div class="links">
            Already have an account? <a href="<%= ctx %>/views/login.jsp">Sign in</a>
        </div>
    </section>
</div>
</body>
</html>
