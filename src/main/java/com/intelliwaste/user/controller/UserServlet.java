package com.intelliwaste.user.controller;

import com.intelliwaste.user.model.User;
import com.intelliwaste.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/user-auth")
public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        String ctx = request.getContextPath();
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = "USER";
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Server-side validation
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Name is required");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }
            if (password == null || password.length() < 8) {
                request.setAttribute("error", "Password must be at least 8 characters");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "An account with that email already exists");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            User user = new User(name, email, hashedPassword, role, phone, address);

            boolean success = userDAO.registerUser(user);
            if (success) {
                request.setAttribute("success", "Account created. Please log in.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            }

        } else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userDAO.login(email, password);
            if (user != null) {
                // Session fixation protection — invalidate any existing session
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null)
                    oldSession.invalidate();

                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                Cookie emailCookie = new Cookie("userEmail", user.getEmail());
                emailCookie.setMaxAge(60 * 60 * 24);
                emailCookie.setHttpOnly(true);
                response.addCookie(emailCookie);

                String role = user.getRole();
                if ("ADMIN".equals(role)) {
                    response.sendRedirect(ctx + "/views/admin/dashboard.jsp");
                } else if ("WORKER".equals(role)) {
                    response.sendRedirect(ctx + "/views/worker/dashboard.jsp");
                } else {
                    response.sendRedirect(ctx + "/views/user/dashboard.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null)
                session.invalidate();

            Cookie emailCookie = new Cookie("userEmail", "");
            emailCookie.setMaxAge(0);
            response.addCookie(emailCookie);

            response.sendRedirect(ctx + "/views/login.jsp");
        } else if ("updateProfile".equals(action)) {
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            if (currentUser == null) {
                response.sendRedirect(ctx + "/views/login.jsp");
                return;
            }

            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "Name is required");
                response.sendRedirect(ctx + "/views/" + currentUser.getRole().toLowerCase() + "/dashboard.jsp");
                return;
            }

            boolean updated = userDAO.updateUserProfile(
                    currentUser.getId(),
                    name.trim(),
                    phone == null ? "" : phone.trim(),
                    address == null ? "" : address.trim());

            if (updated) {
                currentUser.setName(name.trim());
                currentUser.setPhone(phone == null ? "" : phone.trim());
                currentUser.setAddress(address == null ? "" : address.trim());
                session.setAttribute("user", currentUser);
                session.setAttribute("success", "Profile updated successfully");
            } else {
                session.setAttribute("error", "Failed to update profile");
            }

            response.sendRedirect(ctx + "/views/" + currentUser.getRole().toLowerCase() + "/dashboard.jsp");
        }
    }
}
