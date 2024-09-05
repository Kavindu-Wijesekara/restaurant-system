package com.abc.rest.dao;

import com.abc.rest.models.Order;
import com.abc.rest.models.OrderItem;
import com.abc.rest.utils.database.ConnectionFactory;

import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDaoImpl implements OrderDao {

    private Connection getDbConnection() throws ClassNotFoundException, SQLException {
        return new ConnectionFactory().getDatabase().getConnection();
    }

    @Override
    public Order saveOrder(Order order) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Connection con = getDbConnection();
        String sql = "INSERT INTO orders (user_id, order_date, total_amount, status, delivery_method, address, contact_number, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, order.getUserId());
            statement.setTimestamp(2, new Timestamp(order.getOrderDate().getTime()));
            statement.setBigDecimal(3, order.getTotalAmount());
            statement.setString(4, order.getStatus());
            statement.setString(5, order.getDeliveryMethod());
            statement.setString(6, order.getAddress());
            statement.setString(7, order.getContactNumber());
            statement.setString(8, order.getPaymentStatus());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }

            saveOrderItems(order);
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean updateOrderPaymentStatus(int orderId, String paymentStatus, String status, String paymentIntentId) throws SQLException, ClassNotFoundException {

        Connection con = getDbConnection();
        String sql = "UPDATE orders SET payment_status = ?, status = ?, payment_intent_id = ? WHERE id = ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, paymentStatus);
            statement.setString(2, status);
            statement.setString(3, paymentIntentId);
            statement.setInt(4, orderId);
            statement.executeUpdate();

            return true;
        } catch (SQLException e) {
            System.out.println("DAO updateOrderPaymentStatus Error occurred while updating order: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Order getOrderById(int orderId) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Connection con = getDbConnection();
        String sql = "SELECT * FROM orders WHERE id = ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setDeliveryMethod(rs.getString("delivery_method"));
                    order.setAddress(rs.getString("address"));
                    order.setContactNumber(rs.getString("contact_number"));
                    order.setPaymentStatus(rs.getString("payment_status"));

                    order.setOrderItems(getOrderItems(orderId));

                    return order;
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println("DAO getOrderById Error occurred while getting order: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public void updatePaymentIntentId(int orderId, String paymentIntentId) throws SQLException, ClassNotFoundException {
        Connection con = getDbConnection();
        String sql = "UPDATE orders SET payment_intent_id = ? WHERE id = ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, paymentIntentId);
            statement.setInt(2, orderId);
            statement.executeUpdate();
        }
    }


    @Override
    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        List<Order> orders = new ArrayList<>();
        Connection con = getDbConnection();
        String sql = "SELECT u.full_name, u.email, o.id, o.order_date, o.user_id, o.total_amount, o.status, o.delivery_method, o.address, o.contact_number, o.payment_status, o.payment_intent_id FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setFull_name(rs.getString("full_name"));
                    order.setEmail(rs.getString("email"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setDeliveryMethod(rs.getString("delivery_method"));
                    order.setAddress(rs.getString("address"));
                    order.setContactNumber(rs.getString("contact_number"));
                    order.setPaymentStatus(rs.getString("payment_status"));
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


    @Override
    public boolean updateOrderStatus(int orderId, String status) throws SQLException, ClassNotFoundException {
        Connection con = getDbConnection();
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        PreparedStatement statement = con.prepareStatement(sql);
        try {
            statement.setString(1, status);
            statement.setInt(2, orderId);
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("DAO updateOrderStatus Error occurred while updating order: " + e.getMessage());
            throw e;
        } finally {
            statement.close();
            con.close();
        }
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


    private void saveOrderItems(Order order) throws SQLException, ClassNotFoundException {

        Connection con = getDbConnection();
        String sql = "INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            for (OrderItem orderItem : order.getOrderItems()) {
                statement.setInt(1, order.getId());
                statement.setInt(2, orderItem.getMenuItemId());
                statement.setInt(3, orderItem.getQuantity());
                statement.setBigDecimal(4, orderItem.getPrice());
                statement.addBatch();
            }

            statement.executeBatch();
        }

    }

}
