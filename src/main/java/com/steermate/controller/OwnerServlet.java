package com.steermate.controller;

import com.steermate.dao.VehicleDAO;
import com.steermate.model.Trip;
import com.steermate.model.User;
import com.steermate.service.TripService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/owner/*")
public class OwnerServlet extends HttpServlet {

    private final TripService tripService = new TripService();
    private final VehicleDAO  vehicleDAO  = new VehicleDAO();

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

            } else {
                resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
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
