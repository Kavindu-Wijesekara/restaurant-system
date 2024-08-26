package com.abc.rest.dao;

import com.abc.rest.models.LoginModel;
import com.abc.rest.models.UserModel;
import com.abc.rest.utils.database.ConnectionFactory;
import com.abc.rest.utils.encrypter.HashPassword;

import javax.servlet.http.HttpServletRequest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AuthDaoImpl implements AuthDao {
    private Connection getDbConnection() throws ClassNotFoundException, SQLException {
        return new ConnectionFactory().getDatabase().getConnection();
    }

    private static HashPassword getEncrypter() {
        return new HashPassword();
    }

    @Override
    public UserModel loginUser(LoginModel loginModel, HttpServletRequest req) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Connection con = getDbConnection();
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, loginModel.getEmail());
            statement.setString(2, getEncrypter().hashPassword(loginModel.getPassword()));

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return new UserModel(
                            rs.getInt("id"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role")
                    );
                }
            }
        }
        return null;
    }

    private String determineRedirectUrl(String role, String contextPath) {
        return switch (role) {
            case "ADMIN" -> contextPath + "/admin";
            case "STAFF" -> contextPath + "/staff";
            default -> contextPath + "/";
        };
    }

    @Override
    public boolean registerUser(UserModel userModel) throws ClassNotFoundException, SQLException, NoSuchAlgorithmException {
        Connection connection = getDbConnection();
        String query = "INSERT INTO users (full_name, phone, address, email, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement statement = connection.prepareStatement(query);

        statement.setString(1, userModel.getFullName());
        statement.setString(2, userModel.getPhoneNumber());
        statement.setString(3, userModel.getAddress());
        statement.setString(4, userModel.getEmail());
        statement.setString(5, getEncrypter().hashPassword(userModel.getPassword()));
        statement.setString(6, userModel.getRole());

        int result = statement.executeUpdate();
        statement.close();
        connection.close();

        return result > 0;
    }

    @Override
    public boolean checkIfUserExists(String email) throws SQLException, ClassNotFoundException {
        Connection connection = getDbConnection();
        String query = "SELECT COUNT(*) AS count FROM users WHERE email = ?";
        PreparedStatement statement = connection.prepareStatement(query);
        statement.setString(1, email);

        boolean result = statement.executeQuery().next();

        if (result) {
            int count = statement.getResultSet().getInt("count");
            result = count > 0;
        } else {
            result = false;
        }

        statement.close();
        connection.close();
        return result;
    }
}
