package com.abc.rest.services;

import com.abc.rest.dao.MenuItemDao;
import com.abc.rest.dao.MenuItemDaoImpl;
import com.abc.rest.dao.ReservationDao;
import com.abc.rest.dao.ReservationDaoImpl;
import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.MenuItemModel;
import com.abc.rest.models.ReservationModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.regex.Pattern;

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

    private ReservationDao getReservationDao() {
        return new ReservationDaoImpl();
    }

    public List<MenuItemModel> getAllMenuItems() throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getMenuItemDao().getAllMenuItems();
    }

    public CommonMessageModel addReservation(ReservationModel reservationModel) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        // Patterns for validation
        Pattern emailPattern = Pattern.compile("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");
        Pattern phonePattern = Pattern.compile("[^\\d+]");

        // Validate reservation fields
        if (reservationModel.getCustomerName().length() > 100 || reservationModel.getCustomerName().isEmpty()) {
            return new CommonMessageModel("Invalid Customer Name", false, null);
        } else if (!emailPattern.matcher(reservationModel.getCustomerEmail()).matches()) {
            return new CommonMessageModel("Invalid E-mail", false, null);
        } else if (reservationModel.getCustomerPhone().length() > 15 || reservationModel.getCustomerPhone().length() < 6 || phonePattern.matcher(reservationModel.getCustomerPhone()).find()) {
            return new CommonMessageModel("Invalid Phone Number", false, null);
        } else if (reservationModel.getNumberOfPeople() <= 0) {
            return new CommonMessageModel("Number of people must be greater than 0", false, null);
        } else if (!isValidReservationDateTime(reservationModel.getReservationDate(), reservationModel.getReservationTime())) {
            return new CommonMessageModel("Invalid Reservation Date/Time", false, null);
        } else {
            boolean isSuccess = getReservationDao().addReservation(reservationModel);
            if (isSuccess) {
                return new CommonMessageModel("Reservation successfully added. You will get a confirmation email within 24 hours.", true, null);
            } else {
                return new CommonMessageModel("Failed to add reservation.", false, null);
            }
        }
    }

    private boolean isValidReservationDateTime(LocalDate date, LocalTime time) {
        LocalDate today = LocalDate.now();
        LocalTime currentTime = LocalTime.now();

        // Check if the reservation date is in the past
        if (date.isBefore(today)) {
            return false;
        }

        // Check if the reservation is for today and the time is valid
        if (date.isEqual(today)) {
            // Time must be between 10 AM and 10 PM
            if (time.isBefore(LocalTime.of(10, 0)) || time.isAfter(LocalTime.of(22, 0))) {
                return false;
            }
            // Check if the current time is past 10 PM
            if (currentTime.isAfter(LocalTime.of(22, 0))) {
                return false;
            }
        } else {
            // Check if the time is valid for future reservations
            if (time.isBefore(LocalTime.of(10, 0)) || time.isAfter(LocalTime.of(22, 0))) {
                return false;
            }
        }
        return true;
    }
}
