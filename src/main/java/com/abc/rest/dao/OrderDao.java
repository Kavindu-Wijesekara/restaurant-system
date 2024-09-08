package com.abc.rest.dao;

import com.abc.rest.models.Branch;
import com.abc.rest.models.Order;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

public interface OrderDao {

    Order saveOrder(Order order) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    boolean updateOrderPaymentStatus(int orderId, String paymentStatus, String status, String paymentIntentId) throws SQLException, ClassNotFoundException;

    Order getOrderById(int orderId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    void updatePaymentIntentId(int orderId, String paymentIntentId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    List<Order> getAllOrders(int branch_id) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    boolean updateOrderStatus(int orderId, String status) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    List<Branch> getAllBranches() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

}
