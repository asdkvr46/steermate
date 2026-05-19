package com.steermate.controller;

import com.steermate.dao.SearchDAO;
import com.steermate.dao.VehicleDAO;
import com.steermate.model.DriverProfile;
import com.steermate.model.Trip;
import com.steermate.model.User;
import com.steermate.service.TripService;
import com.steermate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

@WebServlet("/owner/*")
public class OwnerServlet extends HttpServlet {

    private final TripService tripService = new TripService();
    private final VehicleDAO  vehicleDAO  = new VehicleDAO();
    private final UserService userService = new UserService();
    private final SearchDAO   searchDAO   = new SearchDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User owner  = (User) req.getSession().getAttribute("loggedUser");
        String path = getSubPath(req);

        try {
            switch (path) {
                case "/dashboard" -> {
                    req.setAttribute("activeTrip",  tripService.getActiveTripForOwner(owner.getId()));
                    req.setAttribute("recentTrips", tripService.getOwnerTrips(owner.getId()));
                    forward(req, resp, "owner/dashboard.jsp");
                }
                case "/book" -> {
                    req.setAttribute("vehicles", vehicleDAO.findByOwnerId(owner.getId()));
                    forward(req, resp, "owner/book.jsp");
                }
                case "/trips" -> {
                    req.setAttribute("trips", tripService.getOwnerTrips(owner.getId()));
                    forward(req, resp, "owner/my-trips.jsp");
                }
                case "/search" -> {
                    String q = req.getParameter("q");
                    if (q != null && q.trim().length() >= 2) {
                        req.setAttribute("results", searchDAO.searchDrivers(q.trim()));
                        req.setAttribute("query", q.trim());
                    } else if (q != null) {
                        req.setAttribute("searchError", "Please enter at least 2 characters to search.");
                        req.setAttribute("query", q);
                    }
                    loadWishlistIds(req);
                    forward(req, resp, "owner/search.jsp");
                }
                case "/wishlist" -> {
                    List<DriverProfile> wishlisted = new ArrayList<>();
                    @SuppressWarnings("unchecked")
                    LinkedHashSet<Integer> ids = (LinkedHashSet<Integer>) req.getSession().getAttribute("driverWishlist");
                    if (ids != null) {
                        for (int driverId : ids) {
                            DriverProfile dp = userService.getDriverProfile(driverId);
                            if (dp != null) wishlisted.add(dp);
                        }
                    }
                    req.setAttribute("wishlistedDrivers", wishlisted);
                    forward(req, resp, "owner/wishlist.jsp");
                }
                case "/profile" -> {
                    req.setAttribute("profileUser", owner);
                    forward(req, resp, "owner/profile.jsp");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User owner  = (User) req.getSession().getAttribute("loggedUser");
        String path   = getSubPath(req);
        String action = req.getParameter("action");

        try {
            if ("/book".equals(path)) {
                int vehicleId    = Integer.parseInt(req.getParameter("vehicleId"));
                String pickup    = req.getParameter("pickup");
                String dropoff   = req.getParameter("dropoff");
                String distStr   = req.getParameter("distanceKm");
                String payMethod = req.getParameter("paymentMethod");

                double distKm = 0;
                try { distKm = Double.parseDouble(distStr); } catch (NumberFormatException ignored) {}

                Trip t = new Trip();
                t.setOwnerId(owner.getId());
                t.setVehicleId(vehicleId);
                t.setPickupLocation(pickup);
                t.setDropoffLocation(dropoff);
                t.setDistanceKm(distKm);
                t.setPaymentMethod(Trip.PaymentMethod.valueOf(payMethod));

                int tripId = tripService.requestTrip(t);
                resp.sendRedirect(req.getContextPath() + "/owner/dashboard?booked=" + tripId);

            } else if ("/dashboard".equals(path) && "cancel".equals(action)) {
                int tripId = Integer.parseInt(req.getParameter("tripId"));
                tripService.updateStatus(tripId, "CANCELLED");
                resp.sendRedirect(req.getContextPath() + "/owner/dashboard?msg=cancelled");

            } else if ("/wishlist".equals(path)) {
                String driverIdStr = req.getParameter("driverId");
                if (driverIdStr != null) {
                    int driverId = Integer.parseInt(driverIdStr);
                    @SuppressWarnings("unchecked")
                    LinkedHashSet<Integer> wishlist = (LinkedHashSet<Integer>) req.getSession().getAttribute("driverWishlist");
                    if (wishlist == null) {
                        wishlist = new LinkedHashSet<>();
                        req.getSession().setAttribute("driverWishlist", wishlist);
                    }
                    if ("add".equals(action)) wishlist.add(driverId);
                    else if ("remove".equals(action)) wishlist.remove(driverId);
                }
                String from = req.getParameter("from");
                if ("search".equals(from)) {
                    String q = req.getParameter("q");
                    resp.sendRedirect(req.getContextPath() + "/owner/search" + (q != null ? "?q=" + q : ""));
                } else {
                    resp.sendRedirect(req.getContextPath() + "/owner/wishlist");
                }

            } else if ("/profile".equals(path)) {
                String name  = req.getParameter("name")  != null ? req.getParameter("name").trim()  : "";
                String phone = req.getParameter("phone") != null ? req.getParameter("phone").trim() : "";

                String error = validateProfile(name, phone);
                if (error != null) {
                    req.setAttribute("profileUser", owner);
                    req.setAttribute("error", error);
                    forward(req, resp, "owner/profile.jsp");
                    return;
                }

                userService.updateUserProfile(owner.getId(), name, phone);
                owner.setName(name);
                owner.setPhone(phone);
                req.getSession().setAttribute("loggedUser", owner);
                resp.sendRedirect(req.getContextPath() + "/owner/profile?msg=updated");

            } else {
                resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String validateProfile(String name, String phone) {
        if (name.isEmpty()) return "Full name is required.";
        if (name.length() < 2 || name.length() > 120) return "Name must be between 2 and 120 characters.";
        if (!name.matches("[A-Za-z ]+")) return "Name must contain letters and spaces only.";
        if (phone.isEmpty()) return "Phone number is required.";
        if (!phone.matches("\\d{10}")) return "Phone must be exactly 10 digits.";
        return null;
    }

    private void loadWishlistIds(HttpServletRequest req) {
        @SuppressWarnings("unchecked")
        LinkedHashSet<Integer> ids = (LinkedHashSet<Integer>) req.getSession().getAttribute("driverWishlist");
        req.setAttribute("wishlistIds", ids != null ? ids : new LinkedHashSet<Integer>());
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
