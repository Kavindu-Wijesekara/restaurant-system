package com.abc.rest.dao;

import com.abc.rest.models.UserModel;
import com.abc.rest.utils.database.ConnectionFactory;
import com.abc.rest.utils.encrypter.HashPassword;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    public String generateReport(String reportType) {

        return "Report data for " + reportType;
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
