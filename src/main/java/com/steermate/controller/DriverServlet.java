package com.steermate.controller;

import com.steermate.model.User;
import com.steermate.service.TripService;
import com.steermate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/driver/*")
public class DriverServlet extends HttpServlet {

    private final TripService tripService = new TripService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User driver = (User) req.getSession().getAttribute("loggedUser");
        String path = getSubPath(req);

        try {
            switch (path) {
                case "/dashboard" -> {
                    req.setAttribute("profile",        userService.getDriverProfile(driver.getId()));
                    req.setAttribute("searchingTrips", tripService.getSearchingTrips());
                    req.setAttribute("earningsToday",  tripService.getDriverEarningsToday(driver.getId()));
                    req.setAttribute("recentTrips",    tripService.getDriverTrips(driver.getId()));
                    forward(req, resp, "driver/dashboard.jsp");
                }
                case "/earnings" -> {
                    req.setAttribute("profile",       userService.getDriverProfile(driver.getId()));
                    req.setAttribute("trips",         tripService.getDriverTrips(driver.getId()));
                    req.setAttribute("earningsToday", tripService.getDriverEarningsToday(driver.getId()));
                    forward(req, resp, "driver/earnings.jsp");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User driver = (User) req.getSession().getAttribute("loggedUser");
        String path  = getSubPath(req);
        String action = req.getParameter("action");

        try {
            switch (path) {
                case "/dashboard" -> {
                    int tripId = Integer.parseInt(req.getParameter("tripId"));
                    switch (action) {
                        case "accept" -> {
                            tripService.assignDriver(tripId, driver.getId());
                            resp.sendRedirect(req.getContextPath() + "/driver/dashboard?msg=accepted");
                        }
                        case "decline" -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard?msg=declined");
                        case "arrive" -> {
                            tripService.updateStatus(tripId, "DRIVER_ARRIVING");
                            resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
                        }
                        case "start" -> {
                            tripService.updateStatus(tripId, "IN_PROGRESS");
                            resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
                        }
                        case "complete" -> {
                            tripService.updateStatus(tripId, "COMPLETED");
                            resp.sendRedirect(req.getContextPath() + "/driver/dashboard?msg=completed");
                        }
                        default -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
                    }
                }
                default -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
            }

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
