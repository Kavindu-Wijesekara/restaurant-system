package com.abc.rest.dao;

import com.abc.rest.models.ReservationModel;
import com.abc.rest.utils.database.ConnectionFactory;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReservationDaoImpl implements ReservationDao {
    private Connection getDbConnection() throws ClassNotFoundException, SQLException {
        return new ConnectionFactory().getDatabase().getConnection();
    }

    @Override
    public boolean addReservation(ReservationModel reservationModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Connection con = getDbConnection();
        String query = "INSERT INTO `reservations`(`customer_name`, `customer_email`, `customer_phone`, `reservation_date`, `reservation_time`, `number_of_people`, `special_requests`) VALUES (?,?,?,?,?,?,?)";
        PreparedStatement statement = con.prepareStatement(query);

        statement.setString(1, reservationModel.getCustomerName());
        statement.setString(2, reservationModel.getCustomerEmail());
        statement.setString(3, reservationModel.getCustomerPhone());
        statement.setDate(4, java.sql.Date.valueOf(reservationModel.getReservationDate()));
        statement.setTime(5, java.sql.Time.valueOf(reservationModel.getReservationTime()));
        statement.setInt(6, reservationModel.getNumberOfPeople());
        statement.setString(7, reservationModel.getSpecialRequest());

        int rowsInserted = statement.executeUpdate();
        statement.close();
        con.close();

        return rowsInserted > 0;
    }
}
