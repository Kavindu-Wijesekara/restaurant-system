package com.abc.rest.controllers;

import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.LoginModel;
import com.abc.rest.models.MenuItemModel;
import com.abc.rest.models.ReservationModel;
import com.abc.rest.services.HomeService;
import com.abc.rest.utils.data_mapper.DataMapper;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/")
public class HomeController extends HttpServlet {

    private static DataMapper getDataMapper() {
        return DataMapper.getDataMapper();
    }

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
            case "/reservations":
                req.getRequestDispatcher("WEB-INF/view/reservation.jsp").forward(req, res);
                break;
            default:
                handleHome(req, res);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String requestURI = req.getRequestURI();

        switch (requestURI) {
            case "/reservations":
                handleReservation(req, res);
                break;
            default:
                handleHome(req, res);
                break;
        }
    }

    private void handleReservation(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        CommonMessageModel message;
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        try {
            String name = req.getParameter("customer_name");
            String email = req.getParameter("customer_email");
            String phone = req.getParameter("customer_phone");
            String date = req.getParameter("reservation_date");
            String time = req.getParameter("reservation_time");
            String numberOfPeopleStr = req.getParameter("number_of_people");
            String specialRequest = req.getParameter("special_request");

            // Convert numberOfPeople to integer
            int numberOfPeople = Integer.parseInt(numberOfPeopleStr);

            // Parse date and time
            LocalDate reservationDate = LocalDate.parse(date);
            LocalTime reservationTime = LocalTime.parse(time);

            // Create ReservationModel
            ReservationModel reservationModel = new ReservationModel();
            reservationModel.setCustomerName(name);
            reservationModel.setCustomerEmail(email);
            reservationModel.setCustomerPhone(phone);
            reservationModel.setReservationDate(reservationDate);
            reservationModel.setReservationTime(reservationTime); // You may need a custom type or format for time
            reservationModel.setNumberOfPeople(numberOfPeople);
            reservationModel.setSpecialRequest(specialRequest);

            message = getHomeService().addReservation(reservationModel);

            out.println(new Gson().toJson(message));
            out.flush();

        } catch (Exception e) {
            message = new CommonMessageModel("Something went wrong.", false, null);
            out.print(new Gson().toJson(message.toJsonObject()));
            out.flush();
            e.printStackTrace();
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
