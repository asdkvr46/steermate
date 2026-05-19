package com.steermate.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet({"/about", "/contact"})
public class PublicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/about".equals(path)) {
            forward(req, resp, "public/about.jsp");
        } else {
            forward(req, resp, "public/contact.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name    = req.getParameter("name")    != null ? req.getParameter("name").trim()    : "";
        String email   = req.getParameter("email")   != null ? req.getParameter("email").trim()   : "";
        String subject = req.getParameter("subject") != null ? req.getParameter("subject").trim() : "";
        String message = req.getParameter("message") != null ? req.getParameter("message").trim() : "";

        String error = null;
        if (name.length() < 2)         error = "Please enter your full name (at least 2 characters).";
        else if (!email.contains("@")) error = "Please enter a valid email address.";
        else if (subject.isEmpty())    error = "Subject is required.";
        else if (message.length() < 10) error = "Message must be at least 10 characters.";

        if (error != null) {
            req.setAttribute("error",   error);
            req.setAttribute("name",    name);
            req.setAttribute("email",   email);
            req.setAttribute("subject", subject);
            req.setAttribute("message", message);
            forward(req, resp, "public/contact.jsp");
        } else {
            req.setAttribute("success", "Thank you, " + name + "! We have received your message and will get back to you shortly.");
            forward(req, resp, "public/contact.jsp");
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/" + view).forward(req, resp);
    }
}
