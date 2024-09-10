package com.abc.rest.dao;

import com.abc.rest.models.UserModel;

import java.sql.SQLException;
import java.util.List;

public interface AdminDao {
    boolean createStaffUser(UserModel user) throws SQLException, ClassNotFoundException;
    List<UserModel> getAllStaff() throws SQLException, ClassNotFoundException;
    boolean deleteUser(int userId) throws SQLException, ClassNotFoundException;
    String generateReport(String reportType);
}
