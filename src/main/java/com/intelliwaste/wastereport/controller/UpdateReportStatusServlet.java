package com.intelliwaste.wastereport.controller;

import com.intelliwaste.user.model.User;
import com.intelliwaste.wastereport.model.dao.WasteReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/updateReportStatus")
public class UpdateReportStatusServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(ctx + "/views/login.jsp");
            return;
        }

        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            WasteReportDAO dao = new WasteReportDAO();
            boolean ok = dao.updateStatus(reportId, status);
            if (ok) {
                session.setAttribute("success", "Status updated to " + status);
            } else {
                session.setAttribute("error", "Failed to update status");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid report identifier");
        }
        response.sendRedirect(ctx + "/viewReports");
    }
}
