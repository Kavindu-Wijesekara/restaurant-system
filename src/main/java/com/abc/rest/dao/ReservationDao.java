package com.abc.rest.dao;

import com.abc.rest.models.ReservationModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

public interface ReservationDao {
    public boolean addReservation(ReservationModel reservationModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    public List<ReservationModel> getAllReservations(int branch_id) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    public boolean updateReservationStatus(int i, String status) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;
}
