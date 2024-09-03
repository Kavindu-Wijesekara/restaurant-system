package com.abc.rest.models;

import com.google.gson.annotations.SerializedName;

import java.time.LocalDate;
import java.time.LocalTime;

public class ReservationModel {
    @SerializedName("reservation_id")
    private int reservationId;

    @SerializedName("customer_name")
    private String customerName;

    @SerializedName("customer_email")
    private String customerEmail;

    @SerializedName("customer_phone")
    private String customerPhone;

    @SerializedName("reservation_date")
    private LocalDate reservationDate;

    @SerializedName("reservation_time")
    private LocalTime reservationTime;

    @SerializedName("number_of_people")
    private int numberOfPeople;

    @SerializedName("special_request")
    private String specialRequest;

    @SerializedName("reservation_type")
    private String reservationType;

    @SerializedName("status")
    private String status;

    @SerializedName("created_at")
    private LocalDate createdAt;


    // Default constructor
    public ReservationModel() {
    }


    // Parameterized constructor
    public ReservationModel(int reservationId, String customerName, String customerEmail, String customerPhone,
                       LocalDate reservationDate, LocalTime reservationTime, int numberOfPeople, String specialRequest,
                       String reservationType, String status, LocalDate createdAt) {
        this.reservationId = reservationId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.reservationDate = reservationDate;
        this.reservationTime = reservationTime;
        this.numberOfPeople = numberOfPeople;
        this.specialRequest = specialRequest;
        this.reservationType = reservationType;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public LocalDate getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
    }

    public LocalTime getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(LocalTime reservationTime) {
        this.reservationTime = reservationTime;
    }

    public int getNumberOfPeople() {
        return numberOfPeople;
    }

    public void setNumberOfPeople(int numberOfPeople) {
        this.numberOfPeople = numberOfPeople;
    }

    public String getSpecialRequest() {
        return specialRequest;
    }

    public void setSpecialRequest(String specialRequest) {
        this.specialRequest = specialRequest;
    }

    public String getReservationType() {
        return reservationType;
    }

    public void setReservationType(String reservationType) {
        this.reservationType = reservationType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }
}


