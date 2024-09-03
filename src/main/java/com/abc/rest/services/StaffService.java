package com.abc.rest.services;

import com.abc.rest.dao.OrderDao;
import com.abc.rest.dao.OrderDaoImpl;
import com.abc.rest.dao.ReservationDao;
import com.abc.rest.dao.ReservationDaoImpl;
import com.abc.rest.models.Order;
import com.abc.rest.models.ReservationModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

public class StaffService {

    private static StaffService staffService;

    public static synchronized StaffService getStaffService() {
        if(staffService == null) {
            staffService = new StaffService();
        }
        return staffService;
    }

    private ReservationDao getReservationDao() {
        return new ReservationDaoImpl();
    }

    private OrderDao getOrderDao() {
        return new OrderDaoImpl();
    }

    public List<ReservationModel> getAllReservations() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getReservationDao().getAllReservations();
    }

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getOrderDao().getAllOrders();
    }

    public boolean updateReservationStatus(int i, String status, String message, String customerEmail) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        boolean updateStatus = getReservationDao().updateReservationStatus(i, status);

        // TODO: Send email to customer

        if (!updateStatus) {
            throw new SQLException("Failed to update reservation status");
        }
        return true;
    }

    public boolean updateOrderStatus(int i, String status) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        boolean updateStatus = getOrderDao().updateOrderStatus(i, status);
        if (!updateStatus) {
            throw new RuntimeException("Failed to update order status");
        }
        return true;
    }
}
