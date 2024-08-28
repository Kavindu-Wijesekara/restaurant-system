package com.abc.rest.dao;

import com.abc.rest.models.ReservationModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public interface ReservationDao {
    public boolean addReservation(ReservationModel reservationModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;
}
