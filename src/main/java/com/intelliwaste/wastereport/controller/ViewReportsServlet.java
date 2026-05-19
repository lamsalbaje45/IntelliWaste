package com.intelliwaste.wastereport.controller;

import com.intelliwaste.user.model.User;
import com.intelliwaste.wastereport.model.dao.WasteReportDAO;
import com.intelliwaste.wastereport.model.dto.WasteReportDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/viewReports")
public class ViewReportsServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(ctx + "/views/login.jsp");
            return;
        }

        WasteReportDAO dao = new WasteReportDAO();
        ArrayList<WasteReportDTO> reports;

        // ADMIN sees everything; USER sees own reports; WORKER also sees all (filtered
        // by their assignments elsewhere)
        if ("USER".equals(user.getRole())) {
            reports = dao.viewReportsByUser(user.getId());
        } else {
            reports = dao.viewAllReports();
        }

        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/views/viewReports.jsp").forward(request, response);
    }
}
