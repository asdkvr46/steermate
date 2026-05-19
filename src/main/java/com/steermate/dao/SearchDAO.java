package com.steermate.dao;

import com.steermate.model.DriverProfile;
import com.steermate.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SearchDAO {

    public List<DriverProfile> searchDrivers(String query) throws SQLException {
        String sql = "SELECT dp.*, u.name AS driver_name, u.email AS driver_email, u.phone AS driver_phone " +
                     "FROM driver_profiles dp " +
                     "JOIN users u ON dp.user_id = u.id " +
                     "WHERE dp.status = 'APPROVED' " +
                     "  AND (u.name LIKE ? OR dp.license_number LIKE ? OR u.phone LIKE ?) " +
                     "ORDER BY dp.rating DESC";
        String pattern = "%" + query + "%";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<DriverProfile> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            rs = ps.executeQuery();
            while (rs.next()) {
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
                list.add(dp);
            }
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }
}
