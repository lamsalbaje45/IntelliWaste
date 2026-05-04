package com.waste.smartwastemanagement.controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.waste.smartwastemanagement.dao.WasteDAO;
import com.waste.smartwastemanagement.model.Waste;
import com.waste.smartwastemanagement.model.User;

@WebServlet("/reportWaste")
public class WasteReportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get user from session
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            out.println("<h2>Please login first</h2>");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get form data
        String location = request.getParameter("location");
        String Type = request.getParameter("Type");
        String description = request.getParameter("description");

        // Create Waste object
        Waste waste = new Waste();
        waste.setUserId(user.getId());
        waste.setLocation(location);
        waste.setType(Type);
        waste.setDescription(description);

        // Call DAO
        WasteDAO dao = new WasteDAO();
        boolean success = dao.addWasteReport(waste);

        // Output result (temporary)
        if (success) {
            out.println("<h2>Waste Report Submitted Successfully</h2>");
        } else {
            out.println("<h2>Failed to Submit Waste Report</h2>");
        }
    }
}