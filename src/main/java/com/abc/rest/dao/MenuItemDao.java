package com.abc.rest.dao;

import com.abc.rest.models.MenuItemModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

public interface MenuItemDao {

    public List<MenuItemModel> getAllMenuItems() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

//    public boolean addMenuItem(MenuItemModel menuItemModel) throws SQLException, ClassNotFoundException;
//
//    public boolean updateMenuItem(MenuItemModel menuItemModel) throws SQLException, ClassNotFoundException;
//
//    public boolean deleteMenuItem(int id) throws SQLException, ClassNotFoundException;
}
