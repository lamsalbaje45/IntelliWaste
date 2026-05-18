package com.intelliwaste.assignment.controller;

import com.intelliwaste.assignment.model.Assignment;
import com.intelliwaste.assignment.model.dao.AssignmentDAO;
import com.intelliwaste.user.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/assignReport")
public class AssignReportServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(ctx + "/views/login.jsp");
            return;
        }

        try {
            int reportId = Integer.parseInt(request.getParameter("report_id"));
            int workerId = Integer.parseInt(request.getParameter("worker_id"));

            Assignment a = new Assignment(reportId, workerId, user.getId());
            AssignmentDAO dao = new AssignmentDAO();
            boolean ok = dao.assignReport(a);
            if (ok) {
                session.setAttribute("success", "Report assigned to worker successfully");
            } else {
                session.setAttribute("error", "Failed to assign report");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid worker or report identifier");
        }
        response.sendRedirect(ctx + "/views/admin/dashboard.jsp");
    }
}