package com.abc.rest.dao;

import com.abc.rest.models.Order;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public interface OrderDao {

    Order saveOrder(Order order) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    boolean updateOrderPaymentStatus(int orderId, String paymentStatus, String status, String paymentIntentId) throws SQLException, ClassNotFoundException;

    Order getOrderById(int orderId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    void updatePaymentIntentId(int orderId, String paymentIntentId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

}
