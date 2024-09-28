package com.abc.rest.dao;

import com.abc.rest.models.Order;
import com.abc.rest.models.OrderItem;
import com.abc.rest.models.ReservationModel;
import com.abc.rest.models.UserModel;
import com.abc.rest.utils.database.ConnectionFactory;
import com.abc.rest.utils.encrypter.HashPassword;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AdminDaoImpl implements AdminDao {

    private Connection getDbConnection() throws ClassNotFoundException, SQLException {
        return new ConnectionFactory().getDatabase().getConnection();
    }

    private static HashPassword getEncrypter() {
        return new HashPassword();
    }

    @Override
    public boolean createStaffUser(UserModel user) throws SQLException, ClassNotFoundException {
        Connection con = getDbConnection();
        String sql = "INSERT INTO users (full_name, phone, address, email, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, getEncrypter().hashPassword(user.getPassword()));
            stmt.setString(6, "STAFF");
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<UserModel> getAllStaff() throws SQLException, ClassNotFoundException {
        Connection connection = getDbConnection();
        List<UserModel> users = new ArrayList<>();
        String sql = "SELECT u.id, u.full_name, u.email, u.phone, b.branch_name FROM users u LEFT JOIN branches b ON u.branch_id = b.branch_id WHERE u.role = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "STAFF");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                UserModel user = new UserModel(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("branch_name")
                );
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<ReservationModel> getAllReservations() throws SQLException, ClassNotFoundException {
        List<ReservationModel> reservations = new ArrayList<>();
        Connection con = getDbConnection();
        String sql = "SELECT r.*, b.branch_name FROM reservations r LEFT JOIN branches b ON r.branch_id = b.branch_id";

        PreparedStatement statement = con.prepareStatement(sql);
        ResultSet rs = statement.executeQuery();

        while (rs.next()) {
            ReservationModel reservation = new ReservationModel();
            reservation.setReservationId(rs.getInt("reservation_id"));
            reservation.setCustomerName(rs.getString("customer_name"));
            reservation.setCustomerEmail(rs.getString("customer_email"));
            reservation.setCustomerPhone(rs.getString("customer_phone"));
            reservation.setReservationDate(rs.getDate("reservation_date").toLocalDate());
            reservation.setReservationTime(rs.getTime("reservation_time").toLocalTime());
            reservation.setNumberOfPeople(rs.getInt("number_of_people"));
            reservation.setSpecialRequest(rs.getString("special_requests"));
            reservation.setReservationType(rs.getString("reservation_type"));
            reservation.setStatus(rs.getString("status"));
            reservation.setBranch_name(rs.getString("branch_name"));
            reservations.add(reservation);
        }

        rs.close();
        statement.close();
        con.close();

        return reservations;
    }

    @Override
    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        Connection con = getDbConnection();
        String sql = "SELECT u.full_name, u.email, o.order_date, o.total_amount, o.status, o.delivery_method, o.address, o.contact_number, o.payment_status, b.branch_name FROM orders o JOIN users u ON o.user_id = u.id LEFT JOIN branches b ON o.branch_id = b.branch_id ORDER BY o.order_date DESC;";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setFull_name(rs.getString("full_name"));
                    order.setEmail(rs.getString("email"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setDeliveryMethod(rs.getString("delivery_method"));
                    order.setAddress(rs.getString("address"));
                    order.setContactNumber(rs.getString("contact_number"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setBranch_name(rs.getString("branch_name"));
                    order.setOrderItems(getOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.out.println("DAO getAllOrders Error occurred while getting all orders: " + e.getMessage());
            throw e;
        }

        return orders;
    }

    private List<OrderItem> getOrderItems(int orderId) throws SQLException, ClassNotFoundException {
        Connection con = getDbConnection();
        String sql = "SELECT mi.item_name AS name, oi.quantity, mi.price AS item_price " +
                "FROM order_items oi " +
                "JOIN menu_items mi ON oi.menu_item_id = mi.id " +
                "WHERE oi.order_id = ?";
        List<OrderItem> orderItems = new ArrayList<>();

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setName(rs.getString("name"));
                    orderItem.setQuantity(rs.getInt("quantity"));
                    orderItem.setPrice(rs.getBigDecimal("item_price"));  // Changed from "price" to "item_price"
                    orderItems.add(orderItem);
                }
            }
        } catch (SQLException e) {
            System.out.println("DAO getOrderItems Error occurred while getting order items: " + e.getMessage());
            throw e;
        }

        return orderItems;
    }

    @Override
    public boolean deleteUser(int userId) throws SQLException, ClassNotFoundException {
        Connection connection = getDbConnection();
        String sql = "DELETE FROM users WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, userId);
        int rowsDeleted = statement.executeUpdate();
        statement.close();
        connection.close();
        return rowsDeleted != 0;
    }
}
