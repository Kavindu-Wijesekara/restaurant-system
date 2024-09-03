package com.abc.rest.models;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private String full_name;
    private Date orderDate;
    private BigDecimal totalAmount;
    private String status;
    private String deliveryMethod;
    private String address;
    private String contactNumber;
    private String paymentStatus;
    private String paymentIntentId;
    private List<OrderItem> orderItems;

    // Constructors
    public Order() {}

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeliveryMethod() {
        return deliveryMethod;
    }

    public void setDeliveryMethod(String deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentIntentId() {
        return paymentIntentId;
    }

    public void setPaymentIntentId(String paymentIntentId) {
        this.paymentIntentId = paymentIntentId;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    // You might want to add a method to calculate the total amount
    public void calculateTotalAmount() {
        this.totalAmount = BigDecimal.ZERO;
        if (orderItems != null) {
            for (OrderItem item : orderItems) {
                this.totalAmount = this.totalAmount.add(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
            }
        }
    }
}