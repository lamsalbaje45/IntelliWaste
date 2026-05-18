package com.intelliwaste.filter;

import com.intelliwaste.user.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse res = (HttpServletResponse) servletResponse;

        // Disable browser caching of authenticated pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String path = req.getRequestURI();
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLogin = path.endsWith("login.jsp");
        boolean isRegister = path.endsWith("register.jsp");
        boolean isIndex = path.endsWith("index.jsp") || path.endsWith("/IntelliWaste/")
                || path.endsWith("/IntelliWaste");
        boolean isAbout = path.endsWith("about.jsp");
        boolean isContact = path.endsWith("contact.jsp");
        boolean isAuth = path.contains("user-auth");
        boolean isPublic = isLogin || isRegister || isIndex || isAbout || isContact || isAuth;

        boolean isStatic = path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".jpg") || path.endsWith(".jpeg") ||
                path.endsWith(".png") || path.endsWith(".gif");

        // Already-logged-in users should not see login/register
        if (isLoggedIn && (isLogin || isRegister)) {
            User user = (User) session.getAttribute("user");
            res.sendRedirect(req.getContextPath() + dashboardFor(user.getRole()));
            return;
        }

        // Block protected pages for unauthenticated requests
        if (!isLoggedIn && !isPublic && !isStatic) {
            res.sendRedirect(req.getContextPath() + "/views/login.jsp");
            return;
        }

        // Role-based access on protected pages
        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            if ((path.contains("/views/admin") || path.contains("/admin/"))
                    && !"ADMIN".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/views/error.jsp?code=403");
                return;
            }
            if (path.contains("/views/worker") && !"WORKER".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/views/error.jsp?code=403");
                return;
            }
        }

        filterChain.doFilter(req, res);
    }

    private String dashboardFor(String role) {
        switch (role) {
            case "ADMIN":
                return "/views/admin/dashboard.jsp";
            case "WORKER":
                return "/views/worker/dashboard.jsp";
            default:
                return "/views/user/dashboard.jsp";
        }
    }
}
