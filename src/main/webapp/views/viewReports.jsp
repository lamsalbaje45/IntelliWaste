<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>All Reports - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
    <h1>Waste Reports</h1>

    <% if (session.getAttribute("success") != null) { %>
        <div class="alert-success"><%= session.getAttribute("success") %></div>
        <% session.removeAttribute("success"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
        <div class="alert-error"><%= session.getAttribute("error") %></div>
        <% session.removeAttribute("error"); %>
    <% } %>

    <div style="background: white; padding: 24px; border-radius: 6px;">
        <c:choose>
            <c:when test="${empty reports}">
                <p>No waste reports found.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="responsive-table" border="1" cellpadding="8">
                        <tr style="background: #f0f0f0;">
                        <th>ID</th>
                        <th>Reporter</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Reported</th>
                        <th>Action</th>
                        </tr>
                        <c:forEach var="r" items="${reports}">
                            <tr>
                            <td>${r.report_id}</td>
                            <td>${r.user_name}</td>
                            <td>${r.category_name}</td>
                            <td>${r.location}</td>
                            <td>${r.priority}</td>
                            <td>${r.status}</td>
                            <td>${r.created_at}</td>
                            <td>
                                <span class="action-cell">
                                    <a class="btn-action" href="<%= ctx %>/viewReportById?id=${r.report_id}">View</a>
                                </span>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="footer.jsp"/>
</body>
</html>
