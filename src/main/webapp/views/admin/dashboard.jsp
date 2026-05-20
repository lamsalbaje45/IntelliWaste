<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.user.model.dao.UserDAO" %>
<%@ page import="com.intelliwaste.wastereport.model.dao.WasteReportDAO" %>
<%@ page import="com.intelliwaste.wastereport.model.dto.WasteReportDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    WasteReportDAO reportDao = new WasteReportDAO();
    ArrayList<WasteReportDTO> allReports = reportDao.viewAllReports();
    Map<String, Integer> stats = reportDao.countByStatus();

    UserDAO userDao = new UserDAO();
    ArrayList<User> workers = userDao.getUsersByRole("WORKER");
    ArrayList<User> allUsers = userDao.getAllUsers();

    int total = allReports.size();
    String ctx = request.getContextPath();
    request.setAttribute("allReports", allReports);
    request.setAttribute("workers", workers);
    request.setAttribute("allUsers", allUsers);
%>
<html>
<head>
    <title>Admin Dashboard - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="container">
    <h1>Administrator Dashboard</h1>
    <p>System overview and waste report management.</p>

    <% if (session.getAttribute("success") != null) { %>
        <div class="alert-success"><%= session.getAttribute("success") %></div>
        <% session.removeAttribute("success"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
        <div class="alert-error"><%= session.getAttribute("error") %></div>
        <% session.removeAttribute("error"); %>
    <% } %>

    <!-- System-wide stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Total Reports</div>
            <div style="font-size: 32px; font-weight: bold;"><%= total %></div>
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
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Workers</div>
            <div style="font-size: 32px; font-weight: bold;"><%= workers.size() %></div>
        </div>
    </div>

    <!-- All reports table -->
    <div style="background: white; padding: 24px; border-radius: 6px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">All Waste Reports</h2>
        <c:choose>
            <c:when test="${empty allReports}">
                <p>No waste reports filed yet.</p>
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
                        <c:forEach var="r" items="${allReports}">
                            <tr>
                            <td>${r.report_id}</td>
                            <td>${r.user_name}</td>
                            <td>${r.category_name}</td>
                            <td>${r.location}</td>
                            <td>${r.priority}</td>
                            <td>${r.status}</td>
                            <td>${r.created_at}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 'PENDING'}">
                                        <form action="<%= ctx %>/assignReport" method="post" style="display:inline;">
                                            <input type="hidden" name="report_id" value="${r.report_id}"/>
                                            <select name="worker_id" required>
                                                <option value="">Worker</option>
                                                <c:forEach var="w" items="${workers}">
                                                    <option value="${w.id}">${w.name}</option>
                                                </c:forEach>
                                            </select>
                                            <button>Assign</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<%= ctx %>/viewReportById?id=${r.report_id}">View</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- User management -->
    <div style="background: white; padding: 24px; border-radius: 6px; margin-top: 24px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">User Management</h2>
        <c:choose>
            <c:when test="${empty allUsers}">
                <p>No users found.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="responsive-table" border="1" cellpadding="8">
                        <tr style="background: #f0f0f0;">
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Phone</th>
                        <th>Action</th>
                        </tr>
                        <c:forEach var="usr" items="${allUsers}">
                            <tr>
                            <td>${usr.id}</td>
                            <td>${usr.name}</td>
                            <td>${usr.email}</td>
                            <td>${usr.role}</td>
                            <td>${usr.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${usr.role == 'ADMIN'}">
                                        <span style="color: #666;">Admin</span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="<%= ctx %>/admin/users" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="updateRole" />
                                            <input type="hidden" name="user_id" value="${usr.id}" />
                                            <select name="role" required>
                                                <option value="USER" ${usr.role == 'USER' ? 'selected' : ''}>Citizen</option>
                                                <option value="WORKER" ${usr.role == 'WORKER' ? 'selected' : ''}>Worker</option>
                                            </select>
                                            <button type="submit">Update</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
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
