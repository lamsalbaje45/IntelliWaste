<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.assignment.model.dao.AssignmentDAO" %>
<%@ page import="com.intelliwaste.assignment.model.dto.AssignmentDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null || !"WORKER".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    AssignmentDAO dao = new AssignmentDAO();
    ArrayList<AssignmentDTO> myTasks = dao.viewAssignmentsByWorker(u.getId());

    int pending = 0, accepted = 0, completed = 0, rejected = 0;
    for (AssignmentDTO a : myTasks) {
        switch (a.getStatus()) {
            case "PENDING":   pending++;   break;
            case "ACCEPTED":  accepted++;  break;
            case "COMPLETED": completed++; break;
            case "REJECTED":  rejected++;  break;
        }
    }

    String ctx = request.getContextPath();

    String taskSearch = request.getParameter("taskSearch");
    String taskCategory = request.getParameter("taskCategory");
    String taskPriority = request.getParameter("taskPriority");
    String taskStatus = request.getParameter("taskStatus");

    if (taskSearch == null) { taskSearch = ""; }
    if (taskCategory == null) { taskCategory = ""; }
    if (taskPriority == null) { taskPriority = ""; }
    if (taskStatus == null) { taskStatus = ""; }

    String taskSearchLower = taskSearch.trim().toLowerCase();
    ArrayList<AssignmentDTO> filteredTasks = new ArrayList<>();
    Set<String> taskCategoryOptions = new LinkedHashSet<>();
    for (AssignmentDTO a : myTasks) {
        if (a.getReport_category() != null && !a.getReport_category().isEmpty()) {
            taskCategoryOptions.add(a.getReport_category());
        }
        boolean matches = true;
        if (!taskCategory.isEmpty() && !"ALL".equalsIgnoreCase(taskCategory)) {
            matches = taskCategory.equalsIgnoreCase(a.getReport_category());
        }
        if (matches && !taskPriority.isEmpty() && !"ALL".equalsIgnoreCase(taskPriority)) {
            matches = taskPriority.equalsIgnoreCase(a.getReport_priority());
        }
        if (matches && !taskStatus.isEmpty() && !"ALL".equalsIgnoreCase(taskStatus)) {
            matches = taskStatus.equalsIgnoreCase(a.getStatus());
        }
        if (matches && !taskSearchLower.isEmpty()) {
            String location = a.getReport_location() == null ? "" : a.getReport_location();
            String description = a.getReport_description() == null ? "" : a.getReport_description();
            String category = a.getReport_category() == null ? "" : a.getReport_category();
            String priority = a.getReport_priority() == null ? "" : a.getReport_priority();
            String status = a.getStatus() == null ? "" : a.getStatus();
            String hay = (a.getReport_id() + " " + location + " " + description + " " + category + " "
                    + priority + " " + status).toLowerCase();
            matches = hay.contains(taskSearchLower);
        }
        if (matches) {
            filteredTasks.add(a);
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
    int total = filteredTasks.size();
    int totalPages = (int) Math.ceil(total / (double) pageSize);
    if (totalPages == 0) {
        totalPages = 1;
    }
    if (currentPage > totalPages) {
        currentPage = totalPages;
    }
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, total);
    ArrayList<AssignmentDTO> pageItems = new ArrayList<>();
    if (total > 0) {
        pageItems = new ArrayList<>(filteredTasks.subList(startIndex, endIndex));
    }

    request.setAttribute("myTasks", pageItems);
    request.setAttribute("page", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("total", total);
    request.setAttribute("taskSearch", taskSearch);
    request.setAttribute("taskCategory", taskCategory);
    request.setAttribute("taskPriority", taskPriority);
    request.setAttribute("taskStatus", taskStatus);
    request.setAttribute("taskCategoryOptions", taskCategoryOptions);
%>
<html>
<head>
    <title>Worker Dashboard - IntelliWaste</title>
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
    <h1>Worker Dashboard</h1>
    <p>Welcome <%= u.getName() %>. Here are the waste collection tasks assigned to you.</p>

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
            <div style="color: #666; font-size: 13px;">New Assignments</div>
            <div style="font-size: 32px; font-weight: bold; color: #e67700;"><%= pending %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">In Progress</div>
            <div style="font-size: 32px; font-weight: bold; color: #1864ab;"><%= accepted %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Completed</div>
            <div style="font-size: 32px; font-weight: bold; color: #2d5f3f;"><%= completed %></div>
        </div>
        <div class="stat-card">
            <div style="color: #666; font-size: 13px;">Rejected</div>
            <div style="font-size: 32px; font-weight: bold; color: #999;"><%= rejected %></div>
        </div>
    </div>

    <!-- Assignments table -->
    <div style="background: white; padding: 24px; border-radius: 6px;">
        <h2 style="margin-top: 0; color: #2d5f3f;">My Assignments</h2>
        <form method="get" action="<%= request.getRequestURI() %>" class="filter-bar">
            <input type="text" name="taskSearch" value="${taskSearch}" placeholder="Search assignments..." class="filter-input" />
            <select name="taskCategory" class="filter-select">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${taskCategoryOptions}">
                    <option value="${cat}" ${cat == taskCategory ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>
            <select name="taskPriority" class="filter-select">
                <option value="">All Priorities</option>
                <option value="LOW" ${taskPriority == 'LOW' ? 'selected' : ''}>Low</option>
                <option value="MEDIUM" ${taskPriority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                <option value="HIGH" ${taskPriority == 'HIGH' ? 'selected' : ''}>High</option>
            </select>
            <select name="taskStatus" class="filter-select">
                <option value="">All Statuses</option>
                <option value="PENDING" ${taskStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                <option value="ACCEPTED" ${taskStatus == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                <option value="COMPLETED" ${taskStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                <option value="REJECTED" ${taskStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
            </select>
            <button type="submit" class="btn-filter">Filter</button>
            <a href="<%= request.getRequestURI() %>" class="btn-clear">Clear</a>
        </form>
        <c:choose>
            <c:when test="${empty myTasks}">
                <p>You have no assignments yet. The administrator will assign tasks to you when waste reports are filed.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="responsive-table" border="1" cellpadding="8">
                        <tr style="background: #f0f0f0;">
                        <th>ID</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Description</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Assigned</th>
                        <th>Action</th>
                        </tr>
                        <c:forEach var="a" items="${myTasks}">
                            <tr>
                            <td>#${a.report_id}</td>
                            <td>${a.report_category}</td>
                            <td>${a.report_location}</td>
                            <td>${a.report_description}</td>
                            <td>${a.report_priority}</td>
                            <td>${a.status}</td>
                            <td>${a.assigned_at}</td>
                            <td>
                                <c:if test="${a.status == 'PENDING'}">
                                    <span class="action-stack">
                                    <form action="<%= ctx %>/workerAction" method="post" style="display:inline;">
                                        <input type="hidden" name="assignment_id" value="${a.assignment_id}"/>
                                        <input type="hidden" name="action" value="accept"/>
                                        <button style="background:#2d5f3f;color:white;border:none;padding:6px 12px;border-radius:3px;cursor:pointer;">Accept</button>
                                    </form>
                                    <form action="<%= ctx %>/workerAction" method="post" style="display:inline;">
                                        <input type="hidden" name="assignment_id" value="${a.assignment_id}"/>
                                        <input type="hidden" name="action" value="reject"/>
                                        <input type="hidden" name="notes" value="Rejected by worker"/>
                                        <button style="background:#c92a2a;color:white;border:none;padding:6px 12px;border-radius:3px;cursor:pointer;">Reject</button>
                                    </form>
                                    </span>
                                </c:if>
                                <c:if test="${a.status == 'ACCEPTED'}">
                                    <form action="<%= ctx %>/workerAction" method="post" style="display:inline;"
                                          onsubmit="this.querySelector('[name=notes]').value = prompt('Completion notes:') || ''; return this.querySelector('[name=notes]').value.length > 0;">
                                        <input type="hidden" name="assignment_id" value="${a.assignment_id}"/>
                                        <input type="hidden" name="action" value="complete"/>
                                        <input type="hidden" name="notes" value=""/>
                                        <button style="background:#1864ab;color:white;border:none;padding:6px 12px;border-radius:3px;cursor:pointer;">Mark Completed</button>
                                    </form>
                                </c:if>
                                <c:if test="${a.status == 'COMPLETED' || a.status == 'REJECTED'}">
                                    <span style="color:#999;">No actions</span>
                                </c:if>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <c:url var="prevUrl" value="${pageContext.request.requestURI}">
                    <c:param name="page" value="${page - 1}" />
                    <c:param name="taskSearch" value="${taskSearch}" />
                    <c:param name="taskCategory" value="${taskCategory}" />
                    <c:param name="taskPriority" value="${taskPriority}" />
                    <c:param name="taskStatus" value="${taskStatus}" />
                </c:url>
                <c:url var="nextUrl" value="${pageContext.request.requestURI}">
                    <c:param name="page" value="${page + 1}" />
                    <c:param name="taskSearch" value="${taskSearch}" />
                    <c:param name="taskCategory" value="${taskCategory}" />
                    <c:param name="taskPriority" value="${taskPriority}" />
                    <c:param name="taskStatus" value="${taskStatus}" />
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
