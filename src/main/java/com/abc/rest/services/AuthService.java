package com.abc.rest.services;

import com.abc.rest.dao.AuthDao;
import com.abc.rest.dao.AuthDaoImpl;
import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.LoginModel;
import com.abc.rest.models.UserModel;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AuthService {

    private static AuthService authService;

    public static synchronized AuthService getAuthService() {
        if (authService == null) {
            authService = new AuthService();
        }
        return authService;
    }

    private AuthDao getAuthDao() {
        return new AuthDaoImpl();
    }

    public CommonMessageModel loginUser(LoginModel loginModel, HttpServletRequest req) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        UserModel user = getAuthDao().loginUser(loginModel);

        if(user != null) {
            setUserSession(req, user);
            String redirectUrl = determineRedirectUrl(user.getRole(), req.getContextPath());
            return new CommonMessageModel("Login successful", true, Map.of("redirectUrl", redirectUrl));
        } else {
            return new CommonMessageModel("Incorrect Email or Password.", false, null);
        }
    }

    private void setUserSession(HttpServletRequest req, UserModel user) {
        HttpSession session = req.getSession();
        session.setMaxInactiveInterval(60 * 60);
        session.setAttribute("id", user.getId());
        session.setAttribute("full_name", user.getFullName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("phone", user.getPhoneNumber());
        session.setAttribute("address", user.getAddress());
        session.setAttribute("role", user.getRole());
        session.setAttribute("branch_id", user.getBranch_id());
    }

    private String determineRedirectUrl(String role, String contextPath) {
        return switch (role) {
            case "ADMIN" -> contextPath + "/admin";
            case "STAFF" -> contextPath + "/staff";
            default -> contextPath + "/";
        };
    }


    public CommonMessageModel registerUser(UserModel userModel, HttpServletRequest req) throws ClassNotFoundException, SQLException, NoSuchAlgorithmException {
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
        }else if(getAuthDao().checkIfUserExists(userModel.getEmail())){
            return new CommonMessageModel("User already with the same Email.", false, null);
        } else {
            boolean isSuccess = getAuthDao().registerUser(userModel);
            if(isSuccess){
                return new CommonMessageModel("We have sent you an E-mail. Please check your email and verify your account.", true,Map.of("redirectUrl", req.getContextPath() + "/auth?action-type=login") );
            } else {
                return new CommonMessageModel("Something went wrong.", false, null);
            }
        }
    }
}

