package com.abc.rest.controllers;

import com.abc.rest.models.MenuItemModel;
import com.abc.rest.services.HomeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/")
public class HomeController extends HttpServlet {

    private static HomeService getHomeService() {
        return HomeService.getHomeService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String requestURI = req.getRequestURI();
        String actionType = req.getParameter("action-type");

        switch (requestURI) {
            case "/menu":
                handleMenu(req, res);
                break;
            default:
                handleHome(req, res);
                break;
        }
    }

    private void handleMenu(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Add any menu-specific logic here
        List<MenuItemModel> menuItems = new ArrayList<MenuItemModel>();
        try {
            menuItems = getHomeService().getAllMenuItems();
            req.setAttribute("menuItems", menuItems);
        } catch (SQLException | ClassNotFoundException | NoSuchAlgorithmException e) {
            // Handle the exception
            System.out.println(e.getMessage());
            req.setAttribute("errorMessage", e.getMessage());
            e.printStackTrace();
        } finally {
            req.getRequestDispatcher("WEB-INF/view/menu.jsp").forward(req, res);
        }
    }

    private void handleHome(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Add any home page-specific logic here
        req.getRequestDispatcher("/").forward(req, res);
    }
}
