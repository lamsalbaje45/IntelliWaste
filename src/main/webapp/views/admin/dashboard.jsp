<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.user.model.dao.UserDAO" %>
<%@ page import="com.intelliwaste.wastereport.model.dao.WasteReportDAO" %>
<%@ page import="com.intelliwaste.wastereport.model.dto.WasteReportDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.Set" %>
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

    String reportSearch = request.getParameter("reportSearch");
    String reportCategory = request.getParameter("reportCategory");
    String reportPriority = request.getParameter("reportPriority");
    String reportStatus = request.getParameter("reportStatus");
    String userSearch = request.getParameter("userSearch");
    String userRole = request.getParameter("userRole");

    if (reportSearch == null) { reportSearch = ""; }
    if (reportCategory == null) { reportCategory = ""; }
    if (reportPriority == null) { reportPriority = ""; }
    if (reportStatus == null) { reportStatus = ""; }
    if (userSearch == null) { userSearch = ""; }
    if (userRole == null) { userRole = ""; }

    String reportSearchLower = reportSearch.trim().toLowerCase();
    ArrayList<WasteReportDTO> filteredReports = new ArrayList<>();
    Set<String> reportCategoryOptions = new LinkedHashSet<>();
    for (WasteReportDTO r : allReports) {
        if (r.getCategory_name() != null && !r.getCategory_name().isEmpty()) {
            reportCategoryOptions.add(r.getCategory_name());
        }
        boolean matches = true;
        if (!reportCategory.isEmpty() && !"ALL".equalsIgnoreCase(reportCategory)) {
            matches = reportCategory.equalsIgnoreCase(r.getCategory_name());
        }
        if (matches && !reportPriority.isEmpty() && !"ALL".equalsIgnoreCase(reportPriority)) {
            matches = reportPriority.equalsIgnoreCase(r.getPriority());
        }
        if (matches && !reportStatus.isEmpty() && !"ALL".equalsIgnoreCase(reportStatus)) {
            matches = reportStatus.equalsIgnoreCase(r.getStatus());
        }
        if (matches && !reportSearchLower.isEmpty()) {
            String location = r.getLocation() == null ? "" : r.getLocation();
            String description = r.getDescription() == null ? "" : r.getDescription();
            String userName = r.getUser_name() == null ? "" : r.getUser_name();
            String categoryName = r.getCategory_name() == null ? "" : r.getCategory_name();
            String priority = r.getPriority() == null ? "" : r.getPriority();
            String status = r.getStatus() == null ? "" : r.getStatus();
            String hay = (r.getReport_id() + " " + location + " " + description + " " + userName + " "
                    + categoryName + " " + priority + " " + status).toLowerCase();
            matches = hay.contains(reportSearchLower);
        }
        if (matches) {
            filteredReports.add(r);
        }
    }

    String userSearchLower = userSearch.trim().toLowerCase();
    ArrayList<User> filteredUsers = new ArrayList<>();
    for (User usr : allUsers) {
        boolean matches = true;
        if (!userRole.isEmpty() && !"ALL".equalsIgnoreCase(userRole)) {
            matches = userRole.equalsIgnoreCase(usr.getRole());
        }
        if (matches && !userSearchLower.isEmpty()) {
            String name = usr.getName() == null ? "" : usr.getName();
            String email = usr.getEmail() == null ? "" : usr.getEmail();
            String phone = usr.getPhone() == null ? "" : usr.getPhone();
            String role = usr.getRole() == null ? "" : usr.getRole();
            String hay = (usr.getId() + " " + name + " " + email + " " + phone + " " + role).toLowerCase();
            matches = hay.contains(userSearchLower);
        }
        if (matches) {
            filteredUsers.add(usr);
        }
    }

    int reportsPageSize = 10;
    int reportsPage = 1;
    String reportsPageParam = request.getParameter("reportsPage");
    if (reportsPageParam != null) {
        try {
            reportsPage = Integer.parseInt(reportsPageParam);
        } catch (NumberFormatException ignored) {
            reportsPage = 1;
        }
    }
    if (reportsPage < 1) {
        reportsPage = 1;
    }
    int reportsTotal = filteredReports.size();
    int reportsTotalPages = (int) Math.ceil(reportsTotal / (double) reportsPageSize);
    if (reportsTotalPages == 0) {
        reportsTotalPages = 1;
    }
    if (reportsPage > reportsTotalPages) {
        reportsPage = reportsTotalPages;
    }
    int reportsStartIndex = (reportsPage - 1) * reportsPageSize;
    int reportsEndIndex = Math.min(reportsStartIndex + reportsPageSize, reportsTotal);
    ArrayList<WasteReportDTO> reportsPageItems = new ArrayList<>();
    if (reportsTotal > 0) {
        reportsPageItems = new ArrayList<>(filteredReports.subList(reportsStartIndex, reportsEndIndex));
    }

    int usersPageSize = 10;
    int usersPage = 1;
    String usersPageParam = request.getParameter("usersPage");
    if (usersPageParam != null) {
        try {
            usersPage = Integer.parseInt(usersPageParam);
        } catch (NumberFormatException ignored) {
            usersPage = 1;
        }
    }
    if (usersPage < 1) {
        usersPage = 1;
    }
    int usersTotal = filteredUsers.size();
    int usersTotalPages = (int) Math.ceil(usersTotal / (double) usersPageSize);
    if (usersTotalPages == 0) {
        usersTotalPages = 1;
    }
    if (usersPage > usersTotalPages) {
        usersPage = usersTotalPages;
    }
    int usersStartIndex = (usersPage - 1) * usersPageSize;
    int usersEndIndex = Math.min(usersStartIndex + usersPageSize, usersTotal);
    ArrayList<User> usersPageItems = new ArrayList<>();
    if (usersTotal > 0) {
        usersPageItems = new ArrayList<>(filteredUsers.subList(usersStartIndex, usersEndIndex));
    }

    request.setAttribute("allReports", reportsPageItems);
    request.setAttribute("workers", workers);
    request.setAttribute("allUsers", usersPageItems);
    request.setAttribute("reportsPage", reportsPage);
    request.setAttribute("reportsTotalPages", reportsTotalPages);
    request.setAttribute("usersPage", usersPage);
    request.setAttribute("usersTotalPages", usersTotalPages);
    request.setAttribute("reportsTotal", reportsTotal);
    request.setAttribute("usersTotal", usersTotal);
    request.setAttribute("reportSearch", reportSearch);
    request.setAttribute("reportCategory", reportCategory);
    request.setAttribute("reportPriority", reportPriority);
    request.setAttribute("reportStatus", reportStatus);
    request.setAttribute("userSearch", userSearch);
    request.setAttribute("userRole", userRole);
    request.setAttribute("reportCategoryOptions", reportCategoryOptions);
%>
<html>
<head>
    <title>Admin Dashboard - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        .filter-bar {
            margin-bottom: 12px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
            padding: 10px;
            background: #f8f9fa;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
        }
        .filter-input,
        .filter-select {
            padding: 8px 10px;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            background: #fff;
            min-height: 36px;
        }
        .filter-input {
            min-width: 220px;
        }
        .btn-filter {
            background: #2d5f3f;
            color: #fff;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-clear {
            color: #2d5f3f;
            background: #eef6f0;
            border: 1px solid #cfe3d6;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
        }
        .btn-clear:hover {
            background: #e4f0e8;
        }
        .action-cell {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 8px;
        }
        .action-col {
            width: 210px;
            min-width: 210px;
            white-space: nowrap;
        }
        .assign-form {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .action-buttons {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex-wrap: nowrap;
        }
        .user-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn-action {
            background: #2d5f3f;
            color: #fff;
            border: none;
            padding: 0 14px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 36px;
            line-height: 36px;
            min-width: 90px;
        }
        .action-select {
            padding: 8px 10px;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            background: #fff;
            min-height: 36px;
            min-width: 120px;
            appearance: none;
            background-image:
                linear-gradient(45deg, transparent 50%, #2d5f3f 50%),
                linear-gradient(135deg, #2d5f3f 50%, transparent 50%),
                linear-gradient(to right, #fff, #fff);
            background-position:
                calc(100% - 16px) 14px,
                calc(100% - 10px) 14px,
                calc(100% - 32px) 0.5em;
            background-size: 6px 6px, 6px 6px, 1px 1.6em;
            background-repeat: no-repeat;
            padding-right: 34px;
        }
    </style>
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
        <form method="get" action="<%= request.getRequestURI() %>" class="filter-bar">
            <input type="hidden" name="usersPage" value="${usersPage}" />
            <input type="text" name="reportSearch" value="${reportSearch}" placeholder="Search reports..." class="filter-input" />
            <select name="reportCategory" class="filter-select">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${reportCategoryOptions}">
                    <option value="${cat}" ${cat == reportCategory ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>
            <select name="reportPriority" class="filter-select">
                <option value="">All Priorities</option>
                <option value="LOW" ${reportPriority == 'LOW' ? 'selected' : ''}>Low</option>
                <option value="MEDIUM" ${reportPriority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                <option value="HIGH" ${reportPriority == 'HIGH' ? 'selected' : ''}>High</option>
            </select>
            <select name="reportStatus" class="filter-select">
                <option value="">All Statuses</option>
                <option value="PENDING" ${reportStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="ASSIGNED" ${reportStatus == 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                <option value="IN_PROGRESS" ${reportStatus == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                <option value="COMPLETED" ${reportStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
            </select>
            <button type="submit" class="btn-filter">Filter</button>
            <a href="<%= request.getRequestURI() %>" class="btn-clear">Clear</a>
        </form>
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
                        <th class="action-col">Action</th>
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
                            <td class="action-col">
                                <div class="action-cell">
                                    <c:if test="${r.status == 'PENDING'}">
                                        <form action="<%= ctx %>/assignReport" method="post" class="assign-form">
                                            <input type="hidden" name="report_id" value="${r.report_id}"/>
                                            <select name="worker_id" required class="action-select">
                                                <option value="">Worker</option>
                                                <c:forEach var="w" items="${workers}">
                                                    <option value="${w.id}">${w.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="action-buttons">
                                                <button class="btn-action" type="submit">Assign</button>
                                                <a class="btn-action" href="<%= ctx %>/viewReportById?id=${r.report_id}">View</a>
                                            </div>
                                        </form>
                                    </c:if>
                                    <c:if test="${r.status != 'PENDING'}">
                                        <div class="action-buttons">
                                            <a class="btn-action" href="<%= ctx %>/viewReportById?id=${r.report_id}">View</a>
                                        </div>
                                    </c:if>
                                </div>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <c:url var="reportsPrevUrl" value="${pageContext.request.requestURI}">
                    <c:param name="reportsPage" value="${reportsPage - 1}" />
                    <c:param name="usersPage" value="${usersPage}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                    <c:param name="userSearch" value="${userSearch}" />
                    <c:param name="userRole" value="${userRole}" />
                </c:url>
                <c:url var="reportsNextUrl" value="${pageContext.request.requestURI}">
                    <c:param name="reportsPage" value="${reportsPage + 1}" />
                    <c:param name="usersPage" value="${usersPage}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                    <c:param name="userSearch" value="${userSearch}" />
                    <c:param name="userRole" value="${userRole}" />
                </c:url>
                <div style="margin-top: 12px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                    <span>Page ${reportsPage} of ${reportsTotalPages}</span>
                    <c:choose>
                        <c:when test="${reportsPage > 1}">
                            <a href="${reportsPrevUrl}">Prev</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Prev</span>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${reportsPage < reportsTotalPages}">
                            <a href="${reportsNextUrl}">Next</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Next</span>
                        </c:otherwise>
                    </c:choose>
                    <span style="color: #666;">Showing ${reportsTotal == 0 ? 0 : (reportsPage - 1) * 10 + 1}-${reportsTotal < reportsPage * 10 ? reportsTotal : reportsPage * 10} of ${reportsTotal}</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- User management -->
    <div style="background: white; padding: 24px; border-radius: 6px; margin-top: 24px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">User Management</h2>
        <form method="get" action="<%= request.getRequestURI() %>" class="filter-bar">
            <input type="hidden" name="reportsPage" value="${reportsPage}" />
            <input type="text" name="userSearch" value="${userSearch}" placeholder="Search users..." class="filter-input" />
            <select name="userRole" class="filter-select">
                <option value="">All Roles</option>
                <option value="ADMIN" ${userRole == 'ADMIN' ? 'selected' : ''}>Admin</option>
                <option value="WORKER" ${userRole == 'WORKER' ? 'selected' : ''}>Worker</option>
                <option value="USER" ${userRole == 'USER' ? 'selected' : ''}>Citizen</option>
            </select>
            <button type="submit" class="btn-filter">Filter</button>
            <a href="<%= request.getRequestURI() %>" class="btn-clear">Clear</a>
        </form>
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
                                            <select name="role" required class="action-select">
                                                <option value="USER" ${usr.role == 'USER' ? 'selected' : ''}>Citizen</option>
                                                <option value="WORKER" ${usr.role == 'WORKER' ? 'selected' : ''}>Worker</option>
                                            </select>
                                            <button type="submit" class="btn-action">Update</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <c:url var="usersPrevUrl" value="${pageContext.request.requestURI}">
                    <c:param name="reportsPage" value="${reportsPage}" />
                    <c:param name="usersPage" value="${usersPage - 1}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                    <c:param name="userSearch" value="${userSearch}" />
                    <c:param name="userRole" value="${userRole}" />
                </c:url>
                <c:url var="usersNextUrl" value="${pageContext.request.requestURI}">
                    <c:param name="reportsPage" value="${reportsPage}" />
                    <c:param name="usersPage" value="${usersPage + 1}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                    <c:param name="userSearch" value="${userSearch}" />
                    <c:param name="userRole" value="${userRole}" />
                </c:url>
                <div style="margin-top: 12px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                    <span>Page ${usersPage} of ${usersTotalPages}</span>
                    <c:choose>
                        <c:when test="${usersPage > 1}">
                            <a href="${usersPrevUrl}">Prev</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Prev</span>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${usersPage < usersTotalPages}">
                            <a href="${usersNextUrl}">Next</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Next</span>
                        </c:otherwise>
                    </c:choose>
                    <span style="color: #666;">Showing ${usersTotal == 0 ? 0 : (usersPage - 1) * 10 + 1}-${usersTotal < usersPage * 10 ? usersTotal : usersPage * 10} of ${usersTotal}</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
