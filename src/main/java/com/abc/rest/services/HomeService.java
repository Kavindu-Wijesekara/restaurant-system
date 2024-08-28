package com.abc.rest.services;

import com.abc.rest.dao.MenuItemDao;
import com.abc.rest.dao.MenuItemDaoImpl;
import com.abc.rest.models.MenuItemModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

public class HomeService {

    private static HomeService homeService;

    public static synchronized HomeService getHomeService() {
        if(homeService == null) {
            homeService = new HomeService();
        }
        return homeService;
    }

    private MenuItemDao getMenuItemDao() {
        return new MenuItemDaoImpl();
    }

    public List<MenuItemModel> getAllMenuItems() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getMenuItemDao().getAllMenuItems();
    }
}
