package com.steermate.controller;

import com.steermate.service.TripService;
import com.steermate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final TripService tripService = new TripService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = getSubPath(req);

        try {
            switch (path) {
                case "/dashboard" -> {
                    req.setAttribute("stats",        tripService.getAdminStats());
                    req.setAttribute("activeTrips",  tripService.getActiveTrips());
                    forward(req, resp, "admin/dashboard.jsp");
                }
                case "/users" -> {
                    req.setAttribute("users", userService.getAllUsers());
                    forward(req, resp, "admin/users.jsp");
                }
                case "/drivers" -> {
                    req.setAttribute("pendingDrivers", userService.getPendingDrivers());
                    req.setAttribute("allDrivers",     userService.getAllDrivers());
                    forward(req, resp, "admin/drivers.jsp");
                }
                case "/trips" -> {
                    req.setAttribute("trips", tripService.getAllTrips());
                    forward(req, resp, "admin/trips.jsp");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path   = getSubPath(req);
        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            switch (path) {
                case "/users" -> {
                    switch (action) {
                        case "approve" -> userService.approveUser(id);
                        case "suspend" -> userService.suspendUser(id);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/users?msg=" + action + "d");
                }
                case "/drivers" -> {
                    switch (action) {
                        case "approve" -> userService.approveDriver(id);
                        case "suspend" -> userService.suspendDriver(id);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/drivers?msg=" + action + "d");
                }
                case "/trips" -> {
                    String status = req.getParameter("status");
                    if (status != null) tripService.updateStatus(id, status);
                    resp.sendRedirect(req.getContextPath() + "/admin/trips?msg=updated");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String getSubPath(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return (pathInfo == null || pathInfo.isEmpty()) ? "/dashboard" : pathInfo;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/" + view).forward(req, resp);
    }
}
