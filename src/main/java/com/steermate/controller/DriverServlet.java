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
                case "/profile" -> {
                    req.setAttribute("driverProfile", userService.getDriverProfile(driver.getId()));
                    req.setAttribute("profileUser", driver);
                    forward(req, resp, "driver/profile.jsp");
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
                case "/profile" -> {
                    String name  = req.getParameter("name")  != null ? req.getParameter("name").trim()  : "";
                    String phone = req.getParameter("phone") != null ? req.getParameter("phone").trim() : "";
                    String bio   = req.getParameter("bio")   != null ? req.getParameter("bio").trim()   : "";
                    String expStr = req.getParameter("experienceYears");

                    String error = validateProfile(name, phone, bio, expStr);
                    if (error != null) {
                        req.setAttribute("driverProfile", userService.getDriverProfile(driver.getId()));
                        req.setAttribute("profileUser", driver);
                        req.setAttribute("error", error);
                        forward(req, resp, "driver/profile.jsp");
                        return;
                    }

                    int expYears = Integer.parseInt(expStr);
                    userService.updateUserProfile(driver.getId(), name, phone);
                    userService.updateDriverProfile(driver.getId(), bio, expYears);
                    driver.setName(name);
                    driver.setPhone(phone);
                    req.getSession().setAttribute("loggedUser", driver);
                    resp.sendRedirect(req.getContextPath() + "/driver/profile?msg=updated");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String validateProfile(String name, String phone, String bio, String expStr) {
        if (name.isEmpty()) return "Full name is required.";
        if (name.length() < 2 || name.length() > 120) return "Name must be between 2 and 120 characters.";
        if (!name.matches("[A-Za-z ]+")) return "Name must contain letters and spaces only.";
        if (phone.isEmpty()) return "Phone number is required.";
        if (!phone.matches("\\d{10}")) return "Phone must be exactly 10 digits.";
        if (bio.length() > 500) return "Bio must not exceed 500 characters.";
        if (expStr == null || expStr.isEmpty()) return "Experience years is required.";
        try {
            int exp = Integer.parseInt(expStr);
            if (exp < 0 || exp > 50) return "Experience years must be between 0 and 50.";
        } catch (NumberFormatException e) {
            return "Experience years must be a valid number.";
        }
        return null;
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
