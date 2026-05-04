package com.steermate.service;

import com.steermate.dao.DriverDAO;
import com.steermate.dao.TripDAO;
import com.steermate.dao.UserDAO;
import com.steermate.model.Trip;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TripService {

    private final TripDAO tripDAO = new TripDAO();
    private final UserDAO userDAO = new UserDAO();
    private final DriverDAO driverDAO = new DriverDAO();

    public int requestTrip(Trip t) throws SQLException {
        t.setTripStatus(Trip.TripStatus.SEARCHING);

        // Calculate fees: base Rs.150, distance Rs.40/km, time Rs.5/min (estimated)
        double distanceFee = Math.round(t.getDistanceKm() * 40.0 * 100.0) / 100.0;
        double timeFee = Math.round((t.getDistanceKm() / 30.0 * 60.0) * 5.0 * 100.0) / 100.0;
        double subtotal = 150.0 + distanceFee + timeFee;
        double platformFee = Math.round(subtotal * 0.15 * 100.0) / 100.0;
        double totalFare = Math.round((subtotal + platformFee) * 100.0) / 100.0;

        t.setBaseFee(150.0);
        t.setDistanceFee(distanceFee);
        t.setTimeFee(timeFee);
        t.setPlatformFee(platformFee);
        t.setTotalFare(totalFare);

        return tripDAO.create(t);
    }

    public void assignDriver(int tripId, int driverId) throws SQLException {
        tripDAO.assignDriver(tripId, driverId);
    }

    public void updateStatus(int tripId, String status) throws SQLException {
        tripDAO.updateStatus(tripId, status);
    }

    public Trip getActiveTripForOwner(int ownerId) throws SQLException {
        return tripDAO.findActiveByOwner(ownerId);
    }

    public List<Trip> getOwnerTrips(int ownerId) throws SQLException {
        return tripDAO.findByOwner(ownerId);
    }

    public List<Trip> getDriverTrips(int driverId) throws SQLException {
        return tripDAO.findByDriver(driverId);
    }

    public List<Trip> getActiveTrips() throws SQLException {
        return tripDAO.findActive();
    }

    public List<Trip> getAllTrips() throws SQLException {
        return tripDAO.findAll();
    }

    public List<Trip> getSearchingTrips() throws SQLException {
        return tripDAO.findSearching();
    }

    public Trip getTripById(int id) throws SQLException {
        return tripDAO.findById(id);
    }

    public Map<String, Object> getAdminStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalOwners",    userDAO.countByRole("OWNER"));
        stats.put("approvedDrivers", driverDAO.countApproved());
        stats.put("activeTrips",    tripDAO.countActive());
        stats.put("todayRevenue",   tripDAO.todayRevenue());
        return stats;
    }

    public double getDriverEarningsToday(int driverId) throws SQLException {
        return tripDAO.driverEarningsToday(driverId);
    }
}
