package com.steermate.model;

import java.time.LocalDateTime;

public class Vehicle {

    public enum VehicleType { SEDAN, SUV, HATCHBACK, TRUCK, VAN, MOTORCYCLE }

    private int id;
    private int ownerId;
    private String make;
    private String model;
    private int year;
    private String plateNumber;
    private String color;
    private VehicleType vehicleType;
    private LocalDateTime createdAt;

    // Transient — owner name for display
    private String ownerName;

    public Vehicle() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getMake() { return make; }
    public void setMake(String make) { this.make = make; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public VehicleType getVehicleType() { return vehicleType; }
    public void setVehicleType(VehicleType vehicleType) { this.vehicleType = vehicleType; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getDisplayName() {
        return year + " " + make + " " + model + " (" + plateNumber + ")";
    }
}
