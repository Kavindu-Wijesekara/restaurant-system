package com.abc.rest.dao;

import com.abc.rest.models.LoginModel;
import com.abc.rest.models.UserModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public interface AuthDao {
    public UserModel loginUser(LoginModel loginModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    public boolean registerUser(UserModel userModel) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException;

    public boolean checkIfUserExists(String email) throws SQLException, ClassNotFoundException;

}
