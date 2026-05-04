package com.steermate.controller;

import com.steermate.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String role            = req.getParameter("role");
        String name            = req.getParameter("name");
        String email           = req.getParameter("email");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone           = req.getParameter("phone");

        try {
            if ("DRIVER".equalsIgnoreCase(role)) {
                String licenseNumber  = req.getParameter("licenseNumber");
                String licenseExpiry  = req.getParameter("licenseExpiry");
                String experienceYears = req.getParameter("experienceYears");
                String bio            = req.getParameter("bio");
                authService.registerDriver(name, email, password, confirmPassword, phone,
                        licenseNumber, licenseExpiry, experienceYears, bio);
            } else {
                authService.registerOwner(name, email, password, confirmPassword, phone);
            }
            req.setAttribute("success", "Registration successful! Your account is pending admin approval.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.setAttribute("role", role);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }
}
