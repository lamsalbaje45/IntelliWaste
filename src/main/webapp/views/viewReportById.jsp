<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.wastereport.model.dto.WasteReportDTO" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    WasteReportDTO report = (WasteReportDTO) request.getAttribute("report");
    String ctx = request.getContextPath();
%>
<html>
<head>
    <title>Report Detail - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
    <h1>Waste Report Detail</h1>

    <% if (report == null) { %>
        <div class="alert-error">Report not found.</div>
        <a href="<%= ctx %>/viewReports">&larr; Back to all reports</a>
    <% } else { %>
        <div style="background: white; padding: 24px; border-radius: 6px;">
            <h2 style="color: #2d5f3f; margin-top: 0;">Report #<%= report.getReport_id() %></h2>

            <table class="detail-table" cellpadding="8">
                <tr><td style="font-weight:bold; width: 200px;">Reporter</td><td><%= report.getUser_name() %> (<%= report.getUser_email() %>)</td></tr>
                <tr><td style="font-weight:bold;">Category</td><td><%= report.getCategory_name() %></td></tr>
                <tr><td style="font-weight:bold;">Location</td><td><%= report.getLocation() %></td></tr>
                <tr><td style="font-weight:bold;">Description</td><td><%= report.getDescription() %></td></tr>
                <tr><td style="font-weight:bold;">Priority</td><td><%= report.getPriority() %></td></tr>
                <tr><td style="font-weight:bold;">Status</td><td><%= report.getStatus() %></td></tr>
                <tr><td style="font-weight:bold;">Reported At</td><td><%= report.getCreated_at() %></td></tr>
                <% if (report.getReport_image() != null && !report.getReport_image().isEmpty()) { %>
                    <tr>
                        <td style="font-weight:bold;">Photo</td>
                        <td><img src="<%= ctx %>/uploads/<%= report.getReport_image() %>" alt="Waste photo" style="max-width: 100%; height: auto; border: 1px solid #ddd;"/></td>
                    </tr>
                <% } %>
            </table>

            <% if ("ADMIN".equals(u.getRole())) { %>
                <hr style="margin: 24px 0;"/>
                <h3>Admin Actions</h3>
                <form action="<%= ctx %>/updateReportStatus" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= report.getReport_id() %>"/>
                    <select name="status">
                        <option value="PENDING">Pending</option>
                        <option value="ASSIGNED">Assigned</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="REJECTED">Rejected</option>
                    </select>
                    <button style="background:#2d5f3f;color:white;border:none;padding:8px 16px;border-radius:3px;cursor:pointer;">Update Status</button>
                </form>
            <% } %>

            <p style="margin-top: 24px;">
                <a href="<%= ctx %>/viewReports">&larr; Back to all reports</a>
            </p>
        </div>
    <% } %>
</div>

<jsp:include page="footer.jsp"/>
</body>
</html>
