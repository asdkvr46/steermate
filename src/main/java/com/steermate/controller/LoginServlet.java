package com.steermate.controller;

import com.steermate.model.User;
import com.steermate.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            redirectByRole((User) session.getAttribute("loggedUser"), req, resp);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = authService.login(email, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setMaxInactiveInterval(30 * 60);
            redirectByRole(user, req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }

    private void redirectByRole(User user, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String base = req.getContextPath();
        switch (user.getRole()) {
            case ADMIN  -> resp.sendRedirect(base + "/admin/dashboard");
            case OWNER  -> resp.sendRedirect(base + "/owner/dashboard");
            case DRIVER -> resp.sendRedirect(base + "/driver/dashboard");
        }
    }
}
