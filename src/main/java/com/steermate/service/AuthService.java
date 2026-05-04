package com.steermate.service;

import com.steermate.dao.DriverDAO;
import com.steermate.dao.UserDAO;
import com.steermate.model.DriverProfile;
import com.steermate.model.User;
import com.steermate.util.PasswordUtil;

import java.sql.SQLException;
import java.time.LocalDate;

public class AuthService {

    private final UserDAO userDAO = new UserDAO();
    private final DriverDAO driverDAO = new DriverDAO();

    public User login(String email, String password) throws Exception {
        if (email == null || email.trim().isEmpty())
            throw new Exception("Email is required.");
        if (password == null || password.trim().isEmpty())
            throw new Exception("Password is required.");

        User user = userDAO.findByEmail(email.trim().toLowerCase());
        if (user == null)
            throw new Exception("Invalid email or password.");
        if (!PasswordUtil.checkPassword(password, user.getPasswordHash()))
            throw new Exception("Invalid email or password.");
        if (user.getStatus() == User.Status.PENDING)
            throw new Exception("Your account is pending approval. Please wait for admin review.");
        if (user.getStatus() == User.Status.SUSPENDED)
            throw new Exception("Your account has been suspended. Contact support.");

        return user;
    }

    public void registerOwner(String name, String email, String password,
                              String confirmPassword, String phone) throws Exception {
        validateCommonFields(name, email, password, confirmPassword, phone);
        User u = buildUser(name, email, password, phone, User.Role.OWNER);
        userDAO.create(u);
    }

    public void registerDriver(String name, String email, String password,
                               String confirmPassword, String phone,
                               String licenseNumber, String licenseExpiry,
                               String experienceYears, String bio) throws Exception {
        validateCommonFields(name, email, password, confirmPassword, phone);

        if (licenseNumber == null || licenseNumber.trim().isEmpty())
            throw new Exception("License number is required.");
        if (licenseExpiry == null || licenseExpiry.trim().isEmpty())
            throw new Exception("License expiry date is required.");

        LocalDate expiry;
        try {
            expiry = LocalDate.parse(licenseExpiry.trim());
        } catch (Exception e) {
            throw new Exception("Invalid license expiry date format (use YYYY-MM-DD).");
        }
        if (expiry.isBefore(LocalDate.now()))
            throw new Exception("License has already expired.");

        int years = 0;
        try {
            years = Integer.parseInt(experienceYears.trim());
        } catch (NumberFormatException ignored) {}

        User u = buildUser(name, email, password, phone, User.Role.DRIVER);
        try {
            userDAO.create(u);
            User saved = userDAO.findByEmail(email.trim().toLowerCase());
            DriverProfile dp = new DriverProfile();
            dp.setUserId(saved.getId());
            dp.setLicenseNumber(licenseNumber.trim());
            dp.setLicenseExpiry(expiry);
            dp.setExperienceYears(years);
            dp.setBio(bio != null ? bio.trim() : "");
            driverDAO.create(dp);
        } catch (SQLException e) {
            throw new Exception("Registration failed: " + e.getMessage());
        }
    }

    private void validateCommonFields(String name, String email, String password,
                                      String confirmPassword, String phone) throws Exception {
        if (name == null || name.trim().isEmpty())
            throw new Exception("Full name is required.");
        if (email == null || email.trim().isEmpty())
            throw new Exception("Email is required.");
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw new Exception("Invalid email format.");
        if (password == null || password.length() < 6)
            throw new Exception("Password must be at least 6 characters.");
        if (!password.equals(confirmPassword))
            throw new Exception("Passwords do not match.");
        if (phone == null || phone.trim().isEmpty())
            throw new Exception("Phone number is required.");

        try {
            if (new UserDAO().emailExists(email.trim().toLowerCase()))
                throw new Exception("An account with this email already exists.");
        } catch (SQLException e) {
            throw new Exception("Registration failed: " + e.getMessage());
        }
    }

    private User buildUser(String name, String email, String password,
                           String phone, User.Role role) {
        User u = new User();
        u.setName(name.trim());
        u.setEmail(email.trim().toLowerCase());
        u.setPasswordHash(PasswordUtil.hashPassword(password));
        u.setPhone(phone.trim());
        u.setRole(role);
        u.setStatus(User.Status.PENDING);
        return u;
    }
}
