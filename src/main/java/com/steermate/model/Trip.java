package com.steermate.model;

import java.time.LocalDateTime;

public class Trip {

    public enum TripStatus {
        SEARCHING, DRIVER_ASSIGNED, DRIVER_ARRIVING, IN_PROGRESS, COMPLETED, CANCELLED
    }

    public enum PaymentMethod { ESEWA, CASH, CARD }

    private int id;
    private int ownerId;
    private Integer driverId;
    private int vehicleId;
    private String pickupLocation;
    private String dropoffLocation;
    private double distanceKm;
    private TripStatus tripStatus;
    private double baseFee;
    private double distanceFee;
    private double timeFee;
    private double platformFee;
    private double totalFare;
    private PaymentMethod paymentMethod;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    // Transient — joined from other tables for display
    private String ownerName;
    private String driverName;
    private String vehiclePlate;
    private String vehicleDisplay;

    public Trip() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public Integer getDriverId() { return driverId; }
    public void setDriverId(Integer driverId) { this.driverId = driverId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }

    public String getDropoffLocation() { return dropoffLocation; }
    public void setDropoffLocation(String dropoffLocation) { this.dropoffLocation = dropoffLocation; }

    public double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(double distanceKm) { this.distanceKm = distanceKm; }

    public TripStatus getTripStatus() { return tripStatus; }
    public void setTripStatus(TripStatus tripStatus) { this.tripStatus = tripStatus; }

    public double getBaseFee() { return baseFee; }
    public void setBaseFee(double baseFee) { this.baseFee = baseFee; }

    public double getDistanceFee() { return distanceFee; }
    public void setDistanceFee(double distanceFee) { this.distanceFee = distanceFee; }

    public double getTimeFee() { return timeFee; }
    public void setTimeFee(double timeFee) { this.timeFee = timeFee; }

    public double getPlatformFee() { return platformFee; }
    public void setPlatformFee(double platformFee) { this.platformFee = platformFee; }

    public double getTotalFare() { return totalFare; }
    public void setTotalFare(double totalFare) { this.totalFare = totalFare; }

    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }

    public String getVehicleDisplay() { return vehicleDisplay; }
    public void setVehicleDisplay(String vehicleDisplay) { this.vehicleDisplay = vehicleDisplay; }

    public String getTripId() {
        return String.format("#TRP-%04d", id);
    }

    public double getDriverEarnings() {
        return totalFare - platformFee;
    }
}
