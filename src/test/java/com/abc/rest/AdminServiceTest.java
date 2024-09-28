package com.abc.rest;

import com.abc.rest.dao.AdminDao;
import com.abc.rest.models.UserModel;
import com.abc.rest.services.AdminService;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class AdminServiceTest {

    private AdminService adminService;
    private AdminDao mockAdminDao;

    @Before
    public void setUp() {
        mockAdminDao = mock(AdminDao.class);
        adminService = new AdminService(mockAdminDao);
    }

    @Test
    public void testCreateStaffUser() throws SQLException, ClassNotFoundException {
        UserModel newUser = new UserModel(1,"John Doe", "0723822478", "Colmmbo", "john@example.com", "password123", "STAFF", 1);
        when(mockAdminDao.createStaffUser(any(UserModel.class))).thenReturn(true);

        boolean result = adminService.createStaffUser(newUser);

        assertTrue(result);
        verify(mockAdminDao).createStaffUser(newUser);
    }

    @Test
    public void testGetAllStaffUsers() throws SQLException, ClassNotFoundException {
        List<UserModel> expectedUsers = Arrays.asList(
                new UserModel(1,"John Doe", "john@example.com", "0723822478",  "Kandy"),
                new UserModel(2,"John Doe", "john@example.com", "0723822478",  "Kandy")
        );
        when(mockAdminDao.getAllStaff()).thenReturn(expectedUsers);

        List<UserModel> result = adminService.getAllStaffUsers();

        assertEquals(expectedUsers, result);
        verify(mockAdminDao).getAllStaff();
    }

    @Test
    public void testDeleteStaffUser() throws SQLException, ClassNotFoundException {
        int userId = 1;
        when(mockAdminDao.deleteUser(userId)).thenReturn(true);

        boolean result = adminService.deleteStaffUser(userId);

        assertTrue(result);
        verify(mockAdminDao).deleteUser(userId);
    }
}
