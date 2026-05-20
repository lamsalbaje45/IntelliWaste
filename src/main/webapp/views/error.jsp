<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String code = request.getParameter("code");
    if (code == null) code = "500";
    String title, message;
    switch (code) {
        case "403":
            title = "403 — Forbidden";
            message = "You do not have permission to access this page.";
            break;
        case "404":
            title = "404 — Not Found";
            message = "The page you requested could not be found.";
            break;
        default:
            title = "500 — Server Error";
            message = "Something went wrong on our end. Please try again later.";
            break;
    }
    String ctx = request.getContextPath();
%>
<html>
<head>
    <title><%= title %> - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body { font-family: Arial; background: #f5f5f5; margin: 0; padding: 60px 20px; text-align: center; }
        .error-box { background: white; max-width: 520px; width: 100%; margin: 0 auto; padding: 36px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .code { font-size: 72px; color: #c92a2a; margin: 0; font-weight: bold; }
        .msg  { color: #666; font-size: 18px; margin: 20px 0; }
        a { display: inline-block; padding: 10px 24px; background: #2d5f3f; color: white; text-decoration: none; border-radius: 4px; }
        a:hover { background: #1f4530; }
        @media (max-width: 520px) { .error-box { padding: 24px; } .code { font-size: 56px; } }
    </style>
</head>
<body>
<div class="error-box">
    <h1 class="code"><%= code %></h1>
    <p class="msg"><%= message %></p>
    <a href="<%= ctx %>/">Return Home</a>
</div>
</body>
</html>
