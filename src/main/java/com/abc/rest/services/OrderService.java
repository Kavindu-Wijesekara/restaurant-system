package com.abc.rest.services;


import com.abc.rest.dao.OrderDao;
import com.abc.rest.dao.OrderDaoImpl;
import com.abc.rest.models.Order;
import com.abc.rest.models.OrderItem;
import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import java.math.BigDecimal;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class OrderService {
    private OrderDao orderDao;

    public OrderService() {
        this.orderDao = new OrderDaoImpl();
    }

    public Order createOrder(Order order) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException, IllegalArgumentException {
        validateOrder(order);

        // Set default values
        order.setOrderDate(new Date());
        order.setStatus("Pending");
        order.setPaymentStatus("Unpaid");

        // Calculate total amount
        BigDecimal totalAmount = calculateTotalAmount(order);
        order.setTotalAmount(totalAmount);

        // Save the order
        Order savedOrder = orderDao.saveOrder(order);

        if (savedOrder == null) {
            throw new SQLException("Failed to save the order");
        }

        return savedOrder;
    }

    private void validateOrder(Order order) throws IllegalArgumentException {
        if (order == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }

        if (order.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }

        if (order.getDeliveryMethod() == null || order.getDeliveryMethod().trim().isEmpty()) {
            throw new IllegalArgumentException("Delivery method is required");
        }

        if ("Delivery".equals(order.getDeliveryMethod()) && (order.getAddress() == null || order.getAddress().trim().isEmpty())) {
            throw new IllegalArgumentException("Address is required for delivery orders");
        }

        if (order.getContactNumber() == null || order.getContactNumber().trim().isEmpty()) {
            throw new IllegalArgumentException("Contact number is required");
        }

        if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
            throw new IllegalArgumentException("Order must contain at least one item");
        }

        for (OrderItem item : order.getOrderItems()) {
            validateOrderItem(item);
        }
    }

    private void validateOrderItem(OrderItem item) throws IllegalArgumentException {
        if (item.getMenuItemId() <= 0) {
            throw new IllegalArgumentException("Invalid menu item ID");
        }

        if (item.getQuantity() <= 0) {
            throw new IllegalArgumentException("Item quantity must be greater than zero");
        }

        if (item.getPrice() == null || item.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Item price must be greater than zero");
        }
    }

    private BigDecimal calculateTotalAmount(Order order) {
        return order.getOrderItems().stream()
                .map(item -> item.getPrice().multiply(new BigDecimal(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean updateOrderPaymentStatus(int orderId, String paymentStatus, String status, String paymentIntentId) throws SQLException, ClassNotFoundException, IllegalArgumentException {
        if (orderId <= 0) {
            throw new IllegalArgumentException("Invalid order ID");
        }

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment status cannot be empty");
        }

        boolean updated = orderDao.updateOrderPaymentStatus(orderId, paymentStatus, status, paymentIntentId);

        if (!updated) {
            throw new IllegalArgumentException("Failed to update payment status");
        }

        return true;
    }

    public Order getOrderById(int orderId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException, IllegalArgumentException {
        if (orderId <= 0) {
            throw new IllegalArgumentException("Invalid order ID");
        }

        Order order = orderDao.getOrderById(orderId);

        if (order == null) {
            throw new IllegalArgumentException("Order not found");
        }

        return order;
    }

    public void updatePaymentIntentId(int orderId, String paymentIntentId) throws SQLException, ClassNotFoundException, IllegalArgumentException, NoSuchAlgorithmException {
        if (orderId <= 0) {
            throw new IllegalArgumentException("Invalid order ID");
        }

        if (paymentIntentId == null || paymentIntentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment intent ID cannot be empty");
        }

        orderDao.updatePaymentIntentId(orderId, paymentIntentId);
    }
}
