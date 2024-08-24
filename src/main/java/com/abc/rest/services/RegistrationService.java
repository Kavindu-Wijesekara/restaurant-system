package com.abc.rest.services;

import com.abc.rest.dao.RegistrationDao;
import com.abc.rest.dao.RegistrationDaoImpl;
import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.UserModel;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegistrationService {
    private static RegistrationService registrationService;

    public static RegistrationService getRegistrationService() {
        if (registrationService == null) {
            registrationService = new RegistrationService();
        }
        return registrationService;
    }

    private RegistrationDao getRegistrationDao() {
        return new RegistrationDaoImpl();
    }

    public CommonMessageModel registerUser(UserModel userModel) throws ClassNotFoundException, SQLException, NoSuchAlgorithmException {
        String regex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        Pattern emailPattern = Pattern.compile(regex);
        Matcher emailMatcher = emailPattern.matcher(userModel.getEmail());
        Pattern phonePattern = Pattern.compile("[^\\d+]");
        Matcher phoneMatcher = phonePattern.matcher(userModel.getPhoneNumber());

        if(userModel.getFullName().length() > 30 || userModel.getFullName().isEmpty()){
            return new CommonMessageModel("Invalid First Name", false, null);
        } else if(!emailMatcher.matches()){
            return new CommonMessageModel("Invalid E-mail", false, null);
        } else if(userModel.getPhoneNumber().length() > 15 || userModel.getPhoneNumber().length() < 6 || phoneMatcher.find()){
            return new CommonMessageModel("Invalid Phone Number", false, null);
        } else if (!(userModel.getPassword().length() >= 6 && userModel.getPassword().length() <= 24)){
            return new CommonMessageModel("Password length must be between 6 and 24 characters.", false, null);
        } else if(!userModel.getPassword().matches(".*[A-Z].*") || !userModel.getPassword().matches(".*\\d.*")){
            return new CommonMessageModel("Password does not meet the criteria: must contain at least one uppercase letter and one number.", false, null);
        }else if(!userModel.getPassword().equals(userModel.getConfirmPassword())){
            return new CommonMessageModel("Passwords does not match", false, null);
        }else if(getRegistrationDao().checkIfUserExists(userModel.getEmail())){
            return new CommonMessageModel("User already with the same Email or Phone Number", false, null);
        } else {
            boolean isSuccess = getRegistrationDao().registerUser(userModel);
            if(isSuccess){
                return new CommonMessageModel("We have sent you an E-mail. Please check your email for the login information.", true, null);
            } else {
                return new CommonMessageModel("Something went wrong.", false, null);
            }
        }
    }
}
