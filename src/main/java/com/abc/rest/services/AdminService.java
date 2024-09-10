package com.abc.rest.services;

import com.abc.rest.dao.AdminDao;
import com.abc.rest.models.UserModel;

import java.sql.SQLException;
import java.util.List;

public class AdminService {
    private final AdminDao adminDao;

    public AdminService(AdminDao adminDao) {
        this.adminDao = adminDao;
    }

    public boolean createStaffUser(UserModel newUser) throws SQLException, ClassNotFoundException {
        return adminDao.createStaffUser(newUser);
    }

    public List<UserModel> getAllStaffUsers() throws SQLException, ClassNotFoundException {
        return adminDao.getAllStaff();
    }

    public boolean deleteStaffUser(int userId) throws SQLException, ClassNotFoundException {
        return adminDao.deleteUser(userId);
    }

    public String generateReport(String reportType) {
        return adminDao.generateReport(reportType);
    }
}
