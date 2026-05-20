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

    String reportSearch = request.getParameter("reportSearch");
    String reportCategory = request.getParameter("reportCategory");
    String reportPriority = request.getParameter("reportPriority");
    String reportStatus = request.getParameter("reportStatus");

    if (reportSearch == null) { reportSearch = ""; }
    if (reportCategory == null) { reportCategory = ""; }
    if (reportPriority == null) { reportPriority = ""; }
    if (reportStatus == null) { reportStatus = ""; }

    String reportSearchLower = reportSearch.trim().toLowerCase();
    ArrayList<WasteReportDTO> filteredReports = new ArrayList<>();
    for (WasteReportDTO r : myReports) {
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
            String categoryName = r.getCategory_name() == null ? "" : r.getCategory_name();
            String priority = r.getPriority() == null ? "" : r.getPriority();
            String status = r.getStatus() == null ? "" : r.getStatus();
            String hay = (r.getReport_id() + " " + location + " " + description + " " + categoryName + " "
                    + priority + " " + status).toLowerCase();
            matches = hay.contains(reportSearchLower);
        }
        if (matches) {
            filteredReports.add(r);
        }
    }

    int pageSize = 10;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException ignored) {
            currentPage = 1;
        }
    }
    if (currentPage < 1) {
        currentPage = 1;
    }
    int total = filteredReports.size();
    int totalPages = (int) Math.ceil(total / (double) pageSize);
    if (totalPages == 0) {
        totalPages = 1;
    }
    if (currentPage > totalPages) {
        currentPage = totalPages;
    }
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, total);
    ArrayList<WasteReportDTO> pageItems = new ArrayList<>();
    if (total > 0) {
        pageItems = new ArrayList<>(filteredReports.subList(startIndex, endIndex));
    }

    request.setAttribute("myReports", pageItems);
    request.setAttribute("page", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("total", total);
    request.setAttribute("reportSearch", reportSearch);
    request.setAttribute("reportCategory", reportCategory);
    request.setAttribute("reportPriority", reportPriority);
    request.setAttribute("reportStatus", reportStatus);
%>
<html>
<head>
    <title>My Dashboard - IntelliWaste</title>
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
    </style>
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
        <form method="get" action="<%= request.getRequestURI() %>" class="filter-bar">
            <input type="text" name="reportSearch" value="${reportSearch}" placeholder="Search reports..." class="filter-input" />
            <select name="reportCategory" class="filter-select">
                <option value="">All Categories</option>
                <% for (Category c : categories) { %>
                    <option value="<%= c.getName() %>" <%= c.getName().equalsIgnoreCase(reportCategory) ? "selected" : "" %>><%= c.getName() %></option>
                <% } %>
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
                <c:url var="prevUrl" value="${pageContext.request.requestURI}">
                    <c:param name="page" value="${page - 1}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                </c:url>
                <c:url var="nextUrl" value="${pageContext.request.requestURI}">
                    <c:param name="page" value="${page + 1}" />
                    <c:param name="reportSearch" value="${reportSearch}" />
                    <c:param name="reportCategory" value="${reportCategory}" />
                    <c:param name="reportPriority" value="${reportPriority}" />
                    <c:param name="reportStatus" value="${reportStatus}" />
                </c:url>
                <div style="margin-top: 12px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                    <span>Page ${page} of ${totalPages}</span>
                    <c:choose>
                        <c:when test="${page > 1}">
                            <a href="${prevUrl}">Prev</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Prev</span>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${page < totalPages}">
                            <a href="${nextUrl}">Next</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Next</span>
                        </c:otherwise>
                    </c:choose>
                    <span style="color: #666;">Showing ${total == 0 ? 0 : (page - 1) * 10 + 1}-${total < page * 10 ? total : page * 10} of ${total}</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
