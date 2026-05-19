package com.steermate.dao;

import com.steermate.model.DriverProfile;
import com.steermate.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DriverDAO {

    public void create(DriverProfile dp) throws SQLException {
        String sql = "INSERT INTO driver_profiles (user_id, license_number, license_expiry, experience_years, bio) VALUES (?,?,?,?,?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dp.getUserId());
            ps.setString(2, dp.getLicenseNumber());
            ps.setDate(3, Date.valueOf(dp.getLicenseExpiry()));
            ps.setInt(4, dp.getExperienceYears());
            ps.setString(5, dp.getBio());
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public DriverProfile findByUserId(int userId) throws SQLException {
        String sql = "SELECT dp.*, u.name AS driver_name, u.email AS driver_email, u.phone AS driver_phone " +
                     "FROM driver_profiles dp JOIN users u ON dp.user_id = u.id WHERE dp.user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public List<DriverProfile> findAll() throws SQLException {
        String sql = "SELECT dp.*, u.name AS driver_name, u.email AS driver_email, u.phone AS driver_phone " +
                     "FROM driver_profiles dp JOIN users u ON dp.user_id = u.id ORDER BY dp.created_at DESC";
        return query(sql);
    }

    public List<DriverProfile> findPending() throws SQLException {
        String sql = "SELECT dp.*, u.name AS driver_name, u.email AS driver_email, u.phone AS driver_phone " +
                     "FROM driver_profiles dp JOIN users u ON dp.user_id = u.id " +
                     "WHERE dp.status = 'PENDING' ORDER BY dp.created_at ASC";
        return query(sql);
    }

    public List<DriverProfile> findApproved() throws SQLException {
        String sql = "SELECT dp.*, u.name AS driver_name, u.email AS driver_email, u.phone AS driver_phone " +
                     "FROM driver_profiles dp JOIN users u ON dp.user_id = u.id " +
                     "WHERE dp.status = 'APPROVED' ORDER BY dp.rating DESC";
        return query(sql);
    }

    public void approve(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            ps1 = conn.prepareStatement("UPDATE driver_profiles SET status = 'APPROVED' WHERE user_id = ?");
            ps1.setInt(1, userId);
            ps1.executeUpdate();
            ps2 = conn.prepareStatement("UPDATE users SET status = 'APPROVED' WHERE id = ?");
            ps2.setInt(1, userId);
            ps2.executeUpdate();
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (ps1 != null) try { ps1.close(); } catch (SQLException ignored) {}
            DBUtil.close(conn, ps2);
        }
    }

    public void suspend(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            ps1 = conn.prepareStatement("UPDATE driver_profiles SET status = 'SUSPENDED' WHERE user_id = ?");
            ps1.setInt(1, userId);
            ps1.executeUpdate();
            ps2 = conn.prepareStatement("UPDATE users SET status = 'SUSPENDED' WHERE id = ?");
            ps2.setInt(1, userId);
            ps2.executeUpdate();
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            if (ps1 != null) try { ps1.close(); } catch (SQLException ignored) {}
            DBUtil.close(conn, ps2);
        }
    }

    public void updateProfile(int userId, String bio, int experienceYears) throws SQLException {
        String sql = "UPDATE driver_profiles SET bio = ?, experience_years = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, bio);
            ps.setInt(2, experienceYears);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public void updateRating(int userId, double rating) throws SQLException {
        String sql = "UPDATE driver_profiles SET rating = ?, total_trips = total_trips + 1 WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDouble(1, rating);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public int countApproved() throws SQLException {
        String sql = "SELECT COUNT(*) FROM driver_profiles WHERE status = 'APPROVED'";
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

    private List<DriverProfile> query(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<DriverProfile> list = new ArrayList<>();
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

    private DriverProfile map(ResultSet rs) throws SQLException {
        DriverProfile dp = new DriverProfile();
        dp.setId(rs.getInt("id"));
        dp.setUserId(rs.getInt("user_id"));
        dp.setLicenseNumber(rs.getString("license_number"));
        Date expiry = rs.getDate("license_expiry");
        if (expiry != null) dp.setLicenseExpiry(expiry.toLocalDate());
        dp.setExperienceYears(rs.getInt("experience_years"));
        dp.setBio(rs.getString("bio"));
        dp.setRating(rs.getDouble("rating"));
        dp.setTotalTrips(rs.getInt("total_trips"));
        dp.setStatus(DriverProfile.Status.valueOf(rs.getString("status")));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) dp.setCreatedAt(ts.toLocalDateTime());
        dp.setDriverName(rs.getString("driver_name"));
        dp.setDriverEmail(rs.getString("driver_email"));
        dp.setDriverPhone(rs.getString("driver_phone"));
        return dp;
    }
}
