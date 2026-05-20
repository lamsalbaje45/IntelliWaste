package com.intelliwaste.wastereport.controller;

import com.intelliwaste.user.model.User;
import com.intelliwaste.wastereport.model.WasteReport;
import com.intelliwaste.wastereport.model.dao.WasteReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/add-report")
@MultipartConfig
public class AddReportServlet extends HttpServlet {

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(ctx + "/views/login.jsp");
            return;
        }

        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");
        int categoryId;
        try {
            categoryId = Integer.parseInt(request.getParameter("category_id"));
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Please select a valid category");
            response.sendRedirect(ctx + "/views/user/dashboard.jsp");
            return;
        }

        // Optional image upload
        String fileName = null;
        try {
            Part filePart = request.getPart("report_image");
            if (filePart != null && filePart.getSize() > 0) {
                if (filePart.getSize() > 3 * 1024 * 1024) {
                    session.setAttribute("error", "Cannot add image greater than 3 MB");
                    response.sendRedirect(ctx + "/views/user/dashboard.jsp");
                    return;
                }
                fileName = new File(filePart.getSubmittedFileName()).getName();
                String uploadPath = System.getProperty("user.dir")
                        + File.separator + "src"
                        + File.separator + "main"
                        + File.separator + "webapp"
                        + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists())
                    uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
            }
        } catch (Exception e) {
            // No image attached — that's fine, image is optional
        }

        WasteReport report = new WasteReport(user.getId(), categoryId, location, description,
                fileName, priority);

        WasteReportDAO dao = new WasteReportDAO();
        boolean ok = dao.insertReport(report);

        if (ok) {
            session.setAttribute("success", "Waste report submitted successfully");
        } else {
            session.setAttribute("error", "Failed to submit report. Please check your inputs.");
        }
        response.sendRedirect(ctx + "/views/user/dashboard.jsp");
    }
}
