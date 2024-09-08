package com.abc.rest.dao;

import com.abc.rest.models.ReservationModel;
import com.abc.rest.utils.database.ConnectionFactory;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ReservationDaoImpl implements ReservationDao {
    private Connection getDbConnection() throws ClassNotFoundException, SQLException {
        return new ConnectionFactory().getDatabase().getConnection();
    }

    @Override
    public boolean addReservation(ReservationModel reservationModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Connection con = getDbConnection();
        String query = "INSERT INTO `reservations`(`customer_name`, `customer_email`, `customer_phone`, `reservation_date`, `reservation_time`, `number_of_people`, `special_requests`, `branch_id`) VALUES (?,?,?,?,?,?,?,?)";
        PreparedStatement statement = con.prepareStatement(query);

        statement.setString(1, reservationModel.getCustomerName());
        statement.setString(2, reservationModel.getCustomerEmail());
        statement.setString(3, reservationModel.getCustomerPhone());
        statement.setDate(4, java.sql.Date.valueOf(reservationModel.getReservationDate()));
        statement.setTime(5, java.sql.Time.valueOf(reservationModel.getReservationTime()));
        statement.setInt(6, reservationModel.getNumberOfPeople());
        statement.setString(7, reservationModel.getSpecialRequest());
        statement.setInt(8, reservationModel.getBranch_id());

        int rowsInserted = statement.executeUpdate();
        statement.close();
        con.close();

        return rowsInserted > 0;
    }

    @Override
    public List<ReservationModel> getAllReservations(int branch_id) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {

        List<ReservationModel> reservations = new ArrayList<>();
        Connection con = getDbConnection();
        String sql = "SELECT * FROM reservations WHERE branch_id = ?";

        PreparedStatement statement = con.prepareStatement(sql);
        statement.setInt(1, branch_id);
        ResultSet rs = statement.executeQuery();

        while (rs.next()) {
            int id = rs.getInt("reservation_id");
            String customerName = rs.getString("customer_name");
            String customerEmail = rs.getString("customer_email");
            String customerPhone = rs.getString("customer_phone");
            LocalDate reservationDate = rs.getDate("reservation_date").toLocalDate();
            LocalTime reservationTime = rs.getTime("reservation_time").toLocalTime();
            int numberOfPeople = rs.getInt("number_of_people");
            String specialRequest = rs.getString("special_requests");
            String reservationType = rs.getString("reservation_type");
            String status = rs.getString("status");
            LocalDate createdAt = rs.getDate("created_at").toLocalDate();
            reservations.add(new ReservationModel(id, customerName, customerEmail, customerPhone, reservationDate, reservationTime, numberOfPeople, specialRequest, reservationType, status, createdAt));
        }

        rs.close();
        statement.close();
        con.close();

        return reservations;
    }

    @Override
    public boolean updateReservationStatus(int i, String status) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {

        Connection con = getDbConnection();
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        PreparedStatement statement = con.prepareStatement(sql);

        try {
            statement.setString(1, status);
            statement.setInt(2, i);
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("DAO updateReservationStatus Error occurred while updating reservation: " + e.getMessage());
            throw e;
        } finally {
            statement.close();
            con.close();
        }
    }
}
