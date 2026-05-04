package com.steermate.filter;

import com.steermate.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow public resources
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Role-based path guard
        if (path.startsWith("/admin") && user.getRole() != User.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        if (path.startsWith("/owner") && user.getRole() != User.Role.OWNER) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        if (path.startsWith("/driver") && user.getRole() != User.Role.DRIVER) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublic(String path) {
        return path.equals("/login")
            || path.equals("/register")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/images/")
            || path.equals("/")
            || path.isEmpty()
            || path.equals("/index.jsp");
    }
}
