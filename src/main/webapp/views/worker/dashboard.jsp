<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.intelliwaste.user.model.User" %>
<%@ page import="com.intelliwaste.assignment.model.dao.AssignmentDAO" %>
<%@ page import="com.intelliwaste.assignment.model.dto.AssignmentDTO" %>
<%@ page import="java.util.ArrayList" %>
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
    request.setAttribute("myTasks", myTasks);
%>
<html>
<head>
    <title>Worker Dashboard - IntelliWaste</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
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
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
