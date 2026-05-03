package com.waste.smartwastemanagement.controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.waste.smartwastemanagement.dao.UserDAO;
import com.waste.smartwastemanagement.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // DAO call
        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user != null) {

            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            out.println("<h2>Login Successful</h2>");
            out.println("<p>Welcome, " + user.getName() + "</p>");

        } else {
            out.println("<h2>Invalid Email or Password</h2>");
        }
    }
}