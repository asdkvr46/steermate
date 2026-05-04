package com.steermate.dao;

import com.steermate.model.Trip;
import com.steermate.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {

    private static final String SELECT_WITH_JOINS =
        "SELECT t.*, " +
        "r.name AS owner_name, " +
        "d.name AS driver_name, " +
        "v.plate_number AS vehicle_plate, " +
        "CONCAT(v.year, ' ', v.make, ' ', v.model, ' (', v.plate_number, ')') AS vehicle_display " +
        "FROM trips t " +
        "JOIN users r ON t.owner_id = r.id " +
        "LEFT JOIN users d ON t.driver_id = d.id " +
        "JOIN vehicles v ON t.vehicle_id = v.id ";

    public int create(Trip t) throws SQLException {
        String sql = "INSERT INTO trips (owner_id, driver_id, vehicle_id, pickup_location, dropoff_location, " +
                     "distance_km, trip_status, base_fee, distance_fee, time_fee, platform_fee, total_fare, payment_method) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, t.getOwnerId());
            if (t.getDriverId() != null) ps.setInt(2, t.getDriverId()); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, t.getVehicleId());
            ps.setString(4, t.getPickupLocation());
            ps.setString(5, t.getDropoffLocation());
            ps.setDouble(6, t.getDistanceKm());
            ps.setString(7, t.getTripStatus().name());
            ps.setDouble(8, t.getBaseFee());
            ps.setDouble(9, t.getDistanceFee());
            ps.setDouble(10, t.getTimeFee());
            ps.setDouble(11, t.getPlatformFee());
            ps.setDouble(12, t.getTotalFare());
            ps.setString(13, t.getPaymentMethod().name());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public Trip findById(int id) throws SQLException {
        String sql = SELECT_WITH_JOINS + "WHERE t.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public List<Trip> findByOwner(int ownerId) throws SQLException {
        String sql = SELECT_WITH_JOINS + "WHERE t.owner_id = ? ORDER BY t.created_at DESC";
        return queryWithInt(sql, ownerId);
    }

    public List<Trip> findByDriver(int driverId) throws SQLException {
        String sql = SELECT_WITH_JOINS + "WHERE t.driver_id = ? ORDER BY t.created_at DESC";
        return queryWithInt(sql, driverId);
    }

    public List<Trip> findActive() throws SQLException {
        String sql = SELECT_WITH_JOINS +
                     "WHERE t.trip_status IN ('SEARCHING','DRIVER_ASSIGNED','DRIVER_ARRIVING','IN_PROGRESS') " +
                     "ORDER BY t.created_at DESC";
        return queryAll(sql);
    }

    public List<Trip> findAll() throws SQLException {
        String sql = SELECT_WITH_JOINS + "ORDER BY t.created_at DESC";
        return queryAll(sql);
    }

    public List<Trip> findSearching() throws SQLException {
        String sql = SELECT_WITH_JOINS + "WHERE t.trip_status = 'SEARCHING' ORDER BY t.created_at ASC";
        return queryAll(sql);
    }

    public Trip findActiveByOwner(int ownerId) throws SQLException {
        String sql = SELECT_WITH_JOINS +
                     "WHERE t.owner_id = ? AND t.trip_status IN ('SEARCHING','DRIVER_ASSIGNED','DRIVER_ARRIVING','IN_PROGRESS') " +
                     "ORDER BY t.created_at DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, ownerId);
            rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public void updateStatus(int id, String status) throws SQLException {
        String sql = status.equals("COMPLETED")
            ? "UPDATE trips SET trip_status = ?, completed_at = NOW() WHERE id = ?"
            : "UPDATE trips SET trip_status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public void assignDriver(int tripId, int driverId) throws SQLException {
        String sql = "UPDATE trips SET driver_id = ?, trip_status = 'DRIVER_ASSIGNED' WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) FROM trips WHERE trip_status IN ('SEARCHING','DRIVER_ASSIGNED','DRIVER_ARRIVING','IN_PROGRESS')";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public double todayRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_fare), 0) FROM trips " +
                     "WHERE trip_status = 'COMPLETED' AND DATE(completed_at) = CURDATE()";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public double driverEarningsToday(int driverId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_fare - platform_fee), 0) FROM trips " +
                     "WHERE driver_id = ? AND trip_status = 'COMPLETED' AND DATE(completed_at) = CURDATE()";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, driverId);
            rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    private List<Trip> queryWithInt(String sql, int param) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Trip> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, param);
            rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    private List<Trip> queryAll(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Trip> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    private Trip map(ResultSet rs) throws SQLException {
        Trip t = new Trip();
        t.setId(rs.getInt("id"));
        t.setOwnerId(rs.getInt("owner_id"));
        int driverId = rs.getInt("driver_id");
        t.setDriverId(rs.wasNull() ? null : driverId);
        t.setVehicleId(rs.getInt("vehicle_id"));
        t.setPickupLocation(rs.getString("pickup_location"));
        t.setDropoffLocation(rs.getString("dropoff_location"));
        t.setDistanceKm(rs.getDouble("distance_km"));
        t.setTripStatus(Trip.TripStatus.valueOf(rs.getString("trip_status")));
        t.setBaseFee(rs.getDouble("base_fee"));
        t.setDistanceFee(rs.getDouble("distance_fee"));
        t.setTimeFee(rs.getDouble("time_fee"));
        t.setPlatformFee(rs.getDouble("platform_fee"));
        t.setTotalFare(rs.getDouble("total_fare"));
        t.setPaymentMethod(Trip.PaymentMethod.valueOf(rs.getString("payment_method")));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) t.setCreatedAt(created.toLocalDateTime());
        Timestamp completed = rs.getTimestamp("completed_at");
        if (completed != null) t.setCompletedAt(completed.toLocalDateTime());
        t.setOwnerName(rs.getString("owner_name"));
        t.setDriverName(rs.getString("driver_name"));
        t.setVehiclePlate(rs.getString("vehicle_plate"));
        t.setVehicleDisplay(rs.getString("vehicle_display"));
        return t;
    }
}
