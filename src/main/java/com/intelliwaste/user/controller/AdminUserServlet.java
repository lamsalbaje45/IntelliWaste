package com.intelliwaste.user.controller;

import com.intelliwaste.user.model.User;
import com.intelliwaste.user.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/error.jsp?code=403");
            return;
        }

        String action = request.getParameter("action");
        String userIdRaw = request.getParameter("user_id");
        if (userIdRaw == null || userIdRaw.trim().isEmpty()) {
            session.setAttribute("error", "Invalid user identifier");
            response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
            return;
        }

        int userId = Integer.parseInt(userIdRaw);
        UserDAO userDAO = new UserDAO();

        if ("updateRole".equals(action)) {
            String role = request.getParameter("role");
            if (!"USER".equals(role) && !"WORKER".equals(role)) {
                session.setAttribute("error", "Invalid role selection");
                response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
                return;
            }

            boolean updated = userDAO.updateUserRole(userId, role);
            if (updated) {
                session.setAttribute("success", "User role updated successfully");
            } else {
                session.setAttribute("error", "Failed to update user role");
            }
        } else if ("deleteUser".equals(action)) {
            boolean deleted = userDAO.deleteUser(userId);
            if (deleted) {
                session.setAttribute("success", "User deleted successfully");
            } else {
                session.setAttribute("error", "Failed to delete user");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
    }
}
