package com.steermate.model;

import java.time.LocalDateTime;

public class Payment {

    public enum Method { ESEWA, CASH, CARD }
    public enum Status { PENDING, COMPLETED, REFUNDED }

    private int id;
    private int tripId;
    private double amount;
    private Method method;
    private Status status;
    private String transactionRef;
    private LocalDateTime createdAt;

    public Payment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Method getMethod() { return method; }
    public void setMethod(Method method) { this.method = method; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
