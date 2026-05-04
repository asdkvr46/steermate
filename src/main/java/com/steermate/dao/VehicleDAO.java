package com.steermate.dao;

import com.steermate.model.Vehicle;
import com.steermate.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public void create(Vehicle v) throws SQLException {
        String sql = "INSERT INTO vehicles (owner_id, make, model, year, plate_number, color, vehicle_type) VALUES (?,?,?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, v.getOwnerId());
            ps.setString(2, v.getMake());
            ps.setString(3, v.getModel());
            ps.setInt(4, v.getYear());
            ps.setString(5, v.getPlateNumber());
            ps.setString(6, v.getColor());
            ps.setString(7, v.getVehicleType().name());
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public List<Vehicle> findByOwnerId(int ownerId) throws SQLException {
        String sql = "SELECT v.*, u.name AS owner_name FROM vehicles v " +
                     "JOIN users u ON v.owner_id = u.id WHERE v.owner_id = ? ORDER BY v.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Vehicle> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, ownerId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public Vehicle findById(int id) throws SQLException {
        String sql = "SELECT v.*, u.name AS owner_name FROM vehicles v " +
                     "JOIN users u ON v.owner_id = u.id WHERE v.id = ?";
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

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    private Vehicle map(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setOwnerId(rs.getInt("owner_id"));
        v.setMake(rs.getString("make"));
        v.setModel(rs.getString("model"));
        v.setYear(rs.getInt("year"));
        v.setPlateNumber(rs.getString("plate_number"));
        v.setColor(rs.getString("color"));
        v.setVehicleType(Vehicle.VehicleType.valueOf(rs.getString("vehicle_type")));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) v.setCreatedAt(ts.toLocalDateTime());
        try { v.setOwnerName(rs.getString("owner_name")); } catch (SQLException ignored) {}
        return v;
    }
}
