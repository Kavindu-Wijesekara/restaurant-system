package com.abc.rest.dao;

import com.abc.rest.models.UserModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public interface RegistrationDao {

    public boolean registerUser(UserModel userModel) throws ClassNotFoundException, NoSuchAlgorithmException, SQLException;

    public boolean checkIfUserExists(String email) throws SQLException, ClassNotFoundException;
}
