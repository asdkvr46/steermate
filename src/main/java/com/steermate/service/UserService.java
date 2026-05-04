package com.steermate.service;

import com.steermate.dao.DriverDAO;
import com.steermate.dao.UserDAO;
import com.steermate.model.DriverProfile;
import com.steermate.model.User;

import java.sql.SQLException;
import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();
    private final DriverDAO driverDAO = new DriverDAO();

    public List<User> getAllUsers() throws SQLException {
        return userDAO.findAll();
    }

    public List<User> getUsersByRole(String role) throws SQLException {
        return userDAO.findByRole(role);
    }

    public User getUserById(int id) throws SQLException {
        return userDAO.findById(id);
    }

    public void approveUser(int id) throws SQLException {
        userDAO.updateStatus(id, "APPROVED");
    }

    public void suspendUser(int id) throws SQLException {
        userDAO.updateStatus(id, "SUSPENDED");
    }

    public List<DriverProfile> getPendingDrivers() throws SQLException {
        return driverDAO.findPending();
    }

    public List<DriverProfile> getAllDrivers() throws SQLException {
        return driverDAO.findAll();
    }

    public void approveDriver(int userId) throws SQLException {
        driverDAO.approve(userId);
    }

    public void suspendDriver(int userId) throws SQLException {
        driverDAO.suspend(userId);
    }

    public DriverProfile getDriverProfile(int userId) throws SQLException {
        return driverDAO.findByUserId(userId);
    }
}
