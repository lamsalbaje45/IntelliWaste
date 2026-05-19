package com.intelliwaste.wastereport.controller;

import com.intelliwaste.wastereport.model.dao.WasteReportDAO;
import com.intelliwaste.wastereport.model.dto.WasteReportDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/viewReportById")
public class ViewReportByIdServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            WasteReportDAO dao = new WasteReportDAO();
            WasteReportDTO report = dao.viewReportById(reportId);
            request.setAttribute("report", report);
            request.getRequestDispatcher("/views/viewReportById.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/viewReports");
        }
    }
}
