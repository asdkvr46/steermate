-- =============================================================
-- SteerMate Database Schema
-- MySQL 8.0 | Normalized to 3NF
-- =============================================================

CREATE DATABASE IF NOT EXISTS steermate_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE steermate_db;

-- -------------------------------------------------------------
-- TABLE 1: users
-- All account holders. 'role' discriminates Admin/Owner/Driver.
-- Separated from role-specific data to satisfy 2NF/3NF.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(120)    NOT NULL,
    email           VARCHAR(180)    NOT NULL UNIQUE,
    password_hash   VARCHAR(255)    NOT NULL,
    phone           VARCHAR(20)     NOT NULL,
    role            ENUM('ADMIN','OWNER','DRIVER') NOT NULL DEFAULT 'OWNER',
    status          ENUM('PENDING','APPROVED','ACTIVE','SUSPENDED') NOT NULL DEFAULT 'PENDING',
    profile_photo   VARCHAR(300)    NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email  (email),
    INDEX idx_role   (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- TABLE 2: driver_profiles
-- 1-to-1 extension of users where role='DRIVER'.
-- Separated to satisfy 3NF: license data is functionally
-- dependent only on driver users, not all users.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS driver_profiles (
    id                  INT             AUTO_INCREMENT PRIMARY KEY,
    user_id             INT             NOT NULL UNIQUE,
    license_number      VARCHAR(50)     NOT NULL UNIQUE,
    license_expiry      DATE            NOT NULL,
    experience_years    TINYINT         NOT NULL DEFAULT 0,
    bio                 TEXT            NULL,
    rating              DECIMAL(3,2)    NOT NULL DEFAULT 0.00,
    total_trips         INT             NOT NULL DEFAULT 0,
    status              ENUM('PENDING','APPROVED','SUSPENDED') NOT NULL DEFAULT 'PENDING',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_dp_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- TABLE 3: vehicles
-- A car owner may own one or more vehicles.
-- Separated from trips to satisfy 2NF (vehicle attributes
-- depend only on vehicle, not on any trip).
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS vehicles (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    owner_id        INT             NOT NULL,
    make            VARCHAR(60)     NOT NULL,
    model           VARCHAR(60)     NOT NULL,
    year            YEAR            NOT NULL,
    plate_number    VARCHAR(20)     NOT NULL UNIQUE,
    color           VARCHAR(40)     NOT NULL,
    vehicle_type    ENUM('SEDAN','SUV','HATCHBACK','TRUCK','VAN','MOTORCYCLE') NOT NULL DEFAULT 'SEDAN',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vehicle_owner FOREIGN KEY (owner_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_vehicle_owner (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- TABLE 4: trips
-- Core business entity. Fee components stored as separate
-- columns (not derived from each other) to satisfy 3NF.
-- driver_id is nullable — NULL means no driver assigned yet.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS trips (
    id                  INT             AUTO_INCREMENT PRIMARY KEY,
    owner_id            INT             NOT NULL,
    driver_id           INT             NULL,
    vehicle_id          INT             NOT NULL,
    pickup_location     VARCHAR(255)    NOT NULL,
    dropoff_location    VARCHAR(255)    NOT NULL,
    distance_km         DECIMAL(8,2)    NULL,
    trip_status         ENUM(
                            'SEARCHING',
                            'DRIVER_ASSIGNED',
                            'DRIVER_ARRIVING',
                            'IN_PROGRESS',
                            'COMPLETED',
                            'CANCELLED'
                        ) NOT NULL DEFAULT 'SEARCHING',
    base_fee            DECIMAL(10,2)   NOT NULL DEFAULT 150.00,
    distance_fee        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    time_fee            DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    platform_fee        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    total_fare          DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    payment_method      ENUM('ESEWA','CASH','CARD') NOT NULL DEFAULT 'CASH',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at        DATETIME        NULL,
    CONSTRAINT fk_trip_owner   FOREIGN KEY (owner_id)  REFERENCES users(id)    ON DELETE RESTRICT,
    CONSTRAINT fk_trip_driver  FOREIGN KEY (driver_id) REFERENCES users(id)    ON DELETE SET NULL,
    CONSTRAINT fk_trip_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE RESTRICT,
    INDEX idx_trip_owner  (owner_id),
    INDEX idx_trip_driver (driver_id),
    INDEX idx_trip_status (trip_status),
    INDEX idx_trip_date   (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- TABLE 5: payments
-- Linked 1-to-1 with completed trips.
-- Separated from trips to satisfy 3NF (payment attributes
-- depend on payment transaction, not on trip route data).
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
    id                  INT             AUTO_INCREMENT PRIMARY KEY,
    trip_id             INT             NOT NULL UNIQUE,
    amount              DECIMAL(10,2)   NOT NULL,
    method              ENUM('ESEWA','CASH','CARD') NOT NULL DEFAULT 'CASH',
    status              ENUM('PENDING','COMPLETED','REFUNDED') NOT NULL DEFAULT 'PENDING',
    transaction_ref     VARCHAR(100)    NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_trip FOREIGN KEY (trip_id)
        REFERENCES trips(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================
-- SEED DATA
-- Admin password: Admin@123
-- Owner passwords: Owner@123
-- Driver passwords: Driver@123
-- (All hashed with BCrypt — generated externally)
-- =============================================================

INSERT INTO users (name, email, password_hash, phone, role, status) VALUES
-- Admin account  (password: Admin@123)
('Administrator', 'admin@steermate.com',
 '$2a$10$fdn8YQZ6F6m0yWrEC6gT/eAXVTJr.puzjIH5rGMQR6KRp3V/TuGaO',
 '9800000000', 'ADMIN', 'ACTIVE'),

-- Car Owners  (password: Owner@123)
('Aayush Shrestha', 'aayush@steermate.com',
 '$2a$10$Zsx9kxjjTAV0L7PkCt9greEx9cCLIhP8vvQPpPwm/54eLrvB7IEo.',
 '9801111111', 'OWNER', 'APPROVED'),

('Sunita Sharma', 'sunita@steermate.com',
 '$2a$10$Zsx9kxjjTAV0L7PkCt9greEx9cCLIhP8vvQPpPwm/54eLrvB7IEo.',
 '9802222222', 'OWNER', 'APPROVED'),

-- Drivers  (password: Driver@123)
('Ramesh Karki', 'ramesh@steermate.com',
 '$2a$10$MbgDQfdWTZIqTfGzGJR3Cez7mj58wy1lMWjavqujPiaE5yMkcpSHu',
 '9803333333', 'DRIVER', 'APPROVED'),

('Sunil Tamang', 'sunil@steermate.com',
 '$2a$10$MbgDQfdWTZIqTfGzGJR3Cez7mj58wy1lMWjavqujPiaE5yMkcpSHu',
 '9804444444', 'DRIVER', 'APPROVED');

INSERT INTO driver_profiles (user_id, license_number, license_expiry, experience_years, bio, rating, total_trips, status) VALUES
(4, 'DL-BAG-1234-2021', '2027-06-30', 5,
 'Professional driver with 5 years experience in Kathmandu valley.', 4.80, 42, 'APPROVED'),
(5, 'DL-BAG-5678-2020', '2026-12-31', 7,
 'Experienced driver, punctual and courteous. Specializes in airport transfers.', 4.95, 78, 'APPROVED');

INSERT INTO vehicles (owner_id, make, model, year, plate_number, color, vehicle_type) VALUES
(2, 'Hyundai', 'Creta', 2022, 'BA 21 CHA 4521', 'White', 'SUV'),
(3, 'Toyota', 'Yaris', 2021, 'BA 12 PA 9988', 'Silver', 'SEDAN');

INSERT INTO trips (owner_id, driver_id, vehicle_id, pickup_location, dropoff_location,
                   distance_km, trip_status, base_fee, distance_fee, time_fee, platform_fee, total_fare,
                   payment_method, created_at, completed_at) VALUES
(2, 4, 1, 'Thamel Marg, Kathmandu', 'Tribhuvan International Airport',
 12.5, 'COMPLETED', 150.00, 500.00, 100.00, 112.50, 862.50, 'ESEWA',
 NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 2 DAY + INTERVAL 45 MINUTE),

(3, NULL, 2, 'New Baneshwor, Kathmandu', 'Patan Durbar Square',
 8.0, 'SEARCHING', 150.00, 320.00, 80.00, 82.50, 632.50, 'CASH',
 NOW(), NULL),

(2, 5, 1, 'Yak & Yeti Hotel, Durbar Marg', 'Tribhuvan International Airport',
 15.0, 'DRIVER_ASSIGNED', 150.00, 600.00, 150.00, 135.00, 1035.00, 'ESEWA',
 NOW() - INTERVAL 30 MINUTE, NULL);
