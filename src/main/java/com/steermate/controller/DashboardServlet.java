package com.steermate.controller;

import com.steermate.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        switch (user.getRole()) {
            case ADMIN  -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            case OWNER  -> resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
            case DRIVER -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
        }
    }
}
