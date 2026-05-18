package com.intelliwaste.assignment.controller;

import com.intelliwaste.assignment.model.dao.AssignmentDAO;
import com.intelliwaste.user.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/workerAction")
public class WorkerActionServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"WORKER".equals(user.getRole())) {
            response.sendRedirect(ctx + "/views/login.jsp");
            return;
        }

        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
            String action = request.getParameter("action");
            String notes = request.getParameter("notes");
            if (notes == null)
                notes = "";

            String status;
            switch (action) {
                case "accept":
                    status = "ACCEPTED";
                    break;
                case "complete":
                    status = "COMPLETED";
                    break;
                case "reject":
                    status = "REJECTED";
                    break;
                default:
                    session.setAttribute("error", "Unknown action");
                    response.sendRedirect(ctx + "/views/worker/dashboard.jsp");
                    return;
            }

            AssignmentDAO dao = new AssignmentDAO();
            boolean ok = dao.updateAssignmentStatus(assignmentId, status, notes);
            if (ok) {
                session.setAttribute("success", "Assignment marked as " + status);
            } else {
                session.setAttribute("error", "Failed to update assignment");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid assignment identifier");
        }
        response.sendRedirect(ctx + "/views/worker/dashboard.jsp");
    }
}