<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.category.model.dao.CategoryDAO" %>
<%@ page import="com.intelliwaste.category.model.Category" %>
<%@ page import="com.intelliwaste.wastereport.model.dao.WasteReportDAO" %>
<%@ page import="com.intelliwaste.wastereport.model.dto.WasteReportDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    if (!"USER".equals(u.getRole())) {
        response.sendRedirect("../error.jsp?code=403");
        return;
    }

    ArrayList<Category> categories = new CategoryDAO().viewAllCategories();
    WasteReportDAO reportDao = new WasteReportDAO();
    ArrayList<WasteReportDTO> myReports = reportDao.viewReportsByUser(u.getId());
    Map<String, Integer> stats = reportDao.countByStatusForUser(u.getId());

    String ctx = request.getContextPath();
    request.setAttribute("myReports", myReports);
%>
<html>
<head>
    <title>My Dashboard - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="container">
    <h1>Welcome, <%= u.getName() %></h1>
    <p>Manage your reported waste issues below.</p>

    <% if (session.getAttribute("success") != null) { %>
        <div class="alert-success"><%= session.getAttribute("success") %></div>
        <% session.removeAttribute("success"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
        <div class="alert-error"><%= session.getAttribute("error") %></div>
        <% session.removeAttribute("error"); %>
    <% } %>

    <!-- Statistics cards -->
    <div class="stats-row">
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">My Reports</div>
            <div style="font-size: 32px; font-weight: bold;"><%= myReports.size() %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Pending</div>
            <div style="font-size: 32px; font-weight: bold; color: #e67700;"><%= stats.get("PENDING") %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">In Progress</div>
            <div style="font-size: 32px; font-weight: bold; color: #1864ab;"><%= stats.get("ASSIGNED") + stats.get("IN_PROGRESS") %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Completed</div>
            <div style="font-size: 32px; font-weight: bold; color: #2d5f3f;"><%= stats.get("COMPLETED") %></div>
        </div>
    </div>

    <!-- Submit new report -->
    <div style="background: white; padding: 24px; border-radius: 6px; margin-bottom: 24px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">Report a Waste Issue</h2>
        <form action="<%= ctx %>/add-report" method="post" enctype="multipart/form-data">
            <div class="form-grid">
                <div>
                    <label>Category *</label>
                    <select name="category_id" required style="width: 100%; padding: 10px; margin-top: 4px;">
                        <option value="">Select Category</option>
                        <% for (Category c : categories) { %>
                            <option value="<%= c.getId() %>"><%= c.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label>Priority *</label>
                    <select name="priority" required style="width: 100%; padding: 10px; margin-top: 4px;">
                        <option value="LOW">Low</option>
                        <option value="MEDIUM" selected>Medium</option>
                        <option value="HIGH">High</option>
                    </select>
                </div>
            </div>
            <div style="margin-top: 14px;">
                <label>Location *</label>
                <input type="text" name="location" required placeholder="e.g. Near Itahari Chowk, opposite the bus stop"
                       style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box;"/>
            </div>
            <div style="margin-top: 14px;">
                <label>Description *</label>
                <textarea name="description" required rows="3" placeholder="Describe the waste issue"
                          style="width: 100%; padding: 10px; margin-top: 4px; box-sizing: border-box;"></textarea>
            </div>
            <div style="margin-top: 14px;">
                <label>Photo (optional, max 3MB)</label>
                <input type="file" name="report_image" accept="image/*" style="margin-top: 4px;"/>
            </div>
            <button type="submit" style="margin-top: 16px; background: #2d5f3f; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Submit Report</button>
        </form>
    </div>

    <!-- My reports table -->
    <div style="background: white; padding: 24px; border-radius: 6px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">My Reports</h2>
        <c:choose>
            <c:when test="${empty myReports}">
                <p>You have not filed any waste reports yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="responsive-table" border="1" cellpadding="8">
                        <tr style="background: #f0f0f0;">
                        <th>ID</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Reported</th>
                        <th>Action</th>
                        </tr>
                        <c:forEach var="r" items="${myReports}">
                            <tr>
                            <td>${r.report_id}</td>
                            <td>${r.category_name}</td>
                            <td>${r.location}</td>
                            <td>${r.priority}</td>
                            <td>${r.status}</td>
                            <td>${r.created_at}</td>
                            <td>
                                <a href="<%= ctx %>/viewReportById?id=${r.report_id}">View</a>
                                <c:if test="${r.status == 'PENDING'}">
                                    | <a href="<%= ctx %>/deleteReport?id=${r.report_id}"
                                         onclick="return confirm('Delete this report?')">Delete</a>
                                </c:if>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
