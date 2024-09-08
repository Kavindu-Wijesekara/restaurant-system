package com.abc.rest.services;

import com.abc.rest.dao.OrderDao;
import com.abc.rest.dao.OrderDaoImpl;
import com.abc.rest.dao.ReservationDao;
import com.abc.rest.dao.ReservationDaoImpl;
import com.abc.rest.models.Order;
import com.abc.rest.models.ReservationModel;
import com.abc.rest.utils.mail.EmailSender;

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

    private static EmailSender getEmailSender() {
        return EmailSender.getEmailSender();
    }

    public List<ReservationModel> getAllReservations(int branch_id) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getReservationDao().getAllReservations(branch_id);
    }

    public List<Order> getAllOrders(int branch_id) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getOrderDao().getAllOrders(branch_id);
    }

    public boolean updateReservationStatus(int i, String status, String message, String customerEmail) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        boolean updateStatus = getReservationDao().updateReservationStatus(i, status);

        if ("Cancelled".equals(status)) {
            getEmailSender().sendMail(customerEmail, "Reservation Cancelled", "Hey,\n" +
                    "\n" +
                    "Your reservation has been canceled. Reason: "+message+"\n" +
                    "\n" +
                    "Let us know if you need any info.\n" +
                    "\n" +
                    "Best regards,\n" +
                    "ABC Restaurant Colombo");
        }

        if ("Confirmed".equals(status)) {
            getEmailSender().sendMail(customerEmail, "Reservation Confirmed", "Hey,\n" +
                    "\n" +
                    "Your reservation has been confirmed. \n" +
                    "\n" +
                    "Let us know if you need any info.\n" +
                    "\n" +
                    "Best regards,\n" +
                    "ABC Restaurant Colombo");
        }

        if (!updateStatus) {
            throw new SQLException("Failed to update reservation status");
        }
        return true;
    }

    public boolean updateOrderStatus(int i, String status, String customerEmail) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        boolean updateStatus = getOrderDao().updateOrderStatus(i, status);

        switch (status) {
            case "Cancelled":
                getEmailSender().sendMail(customerEmail, "Order Cancelled", "Hey,\n" +
                        "\n" +
                        "Your order has been canceled. \n" +
                        "\n" +
                        "Let us know if you need any info.\n" +
                        "\n" +
                        "Best regards,\n" +
                        "ABC Restaurant Colombo");
                break;
            case "Delivered":
                getEmailSender().sendMail(customerEmail, "Order Delivered", "Hey,\n" +
                        "\n" +
                        "Your order has been delivered. \n" +
                        "\n" +
                        "Let us know if you need any info.\n" +
                        "\n" +
                        "Best regards,\n" +
                        "ABC Restaurant Colombo");
                break;
            case "Preparing":
                getEmailSender().sendMail(customerEmail, "Order Prepared", "Hey,\n" +
                        "\n" +
                        "Your order has been prepared. \n" +
                        "\n" +
                        "Let us know if you need any info.\n" +
                        "\n" +
                        "Best regards,\n" +
                        "ABC Restaurant Colombo");
                break;
            case "Ready for Pickup":
                getEmailSender().sendMail(customerEmail, "Order Ready for Pickup", "Hey,\n" +
                        "\n" +
                        "Your order has been ready for pickup. \n" +
                        "\n" +
                        "Let us know if you need any info.\n" +
                        "\n" +
                        "Best regards,\n" +
                        "ABC Restaurant Colombo");
                break;
            case "Out for Delivery":
                getEmailSender().sendMail(customerEmail, "Order Out for Delivery", "Hey,\n" +
                        "\n" +
                        "Your order has been out for delivery. \n" +
                        "\n" +
                        "Let us know if you need any info.\n" +
                        "\n" +
                        "Best regards,\n" +
                        "ABC Restaurant Colombo");
                break;
            default:
                break;
        }

        if (!updateStatus) {
            throw new RuntimeException("Failed to update order status");
        }
        return true;
    }
}
