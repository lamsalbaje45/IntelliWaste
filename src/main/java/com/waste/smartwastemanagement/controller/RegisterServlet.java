package com.waste.smartwastemanagement.controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.waste.smartwastemanagement.dao.UserDAO;
import com.waste.smartwastemanagement.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null) {
            name = "User";
            email = "user@example.com";
            password = "123";
        }

        String role = "user";

        User user = new User(name, email, password, role);

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(user);

        if (success) {
            out.println("<h2>User Registered Successfully</h2>");
        } else {
            out.println("<h2>Registration Failed</h2>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}