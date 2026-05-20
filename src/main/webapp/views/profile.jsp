<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<html>
<head>
    <title>My Profile - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
    <h1>My Profile</h1>
    <p>Update your personal information and contact details.</p>

    <% if (session.getAttribute("success") != null) { %>
        <div class="alert-success"><%= session.getAttribute("success") %></div>
        <% session.removeAttribute("success"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
        <div class="alert-error"><%= session.getAttribute("error") %></div>
        <% session.removeAttribute("error"); %>
    <% } %>

    <div style="background: white; padding: 24px; border-radius: 6px;">
        <form action="<%= ctx %>/user-auth" method="post">
            <input type="hidden" name="action" value="updateProfile" />
            <div class="form-grid">
                <div>
                    <label>Name *</label>
                    <input type="text" name="name" required value="<%= u.getName() %>"
                           style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box;" />
                </div>
                <div>
                    <label>Email</label>
                    <input type="email" value="<%= u.getEmail() %>" readonly
                           style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box; background: #f6f6f6;" />
                </div>
            </div>
            <div class="form-grid" style="margin-top: 14px;">
                <div>
                    <label>Phone</label>
                    <input type="text" name="phone" value="<%= u.getPhone() == null ? "" : u.getPhone() %>"
                           style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box;" />
                </div>
                <div>
                    <label>Address</label>
                    <input type="text" name="address" value="<%= u.getAddress() == null ? "" : u.getAddress() %>"
                           style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box;" />
                </div>
            </div>
            <button type="submit" style="margin-top: 16px; background: #2d5f3f; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Update Profile</button>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp"/>
</body>
</html>
