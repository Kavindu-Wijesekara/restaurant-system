package com.abc.rest.controllers;

import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.UserModel;
import com.abc.rest.services.RegistrationService;
import com.abc.rest.utils.data_mapper.DataMapper;
import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import static java.sql.DriverManager.println;

public class RegistrationController extends HttpServlet {

    private static DataMapper getDataMapper() {
        return DataMapper.getDataMapper();
    }

    private static RegistrationService getRegistrationService() {
        return RegistrationService.getRegistrationService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        registerUser(req, res);
    }

    void registerUser(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        CommonMessageModel message = new CommonMessageModel("Something went wrong.", false, null);

        System.out.println("Registration process started");

        try {
            // Map request data to UserModel
            UserModel userData = new Gson().fromJson(getDataMapper().mapData(req), UserModel.class);

            System.out.println(userData);

            // Register user
            message = getRegistrationService().registerUser(userData);
            if(message.isSuccess()){
                // TODO: Send Email
                System.out.println("Registration process completed");
            }

        } catch (ClassNotFoundException | NoSuchAlgorithmException | SQLException e) {
            message = new CommonMessageModel("Something went wrong.", false, null);
            e.printStackTrace();
        } finally {
            req.setAttribute("message", message.getMessage());
            if (!message.isSuccess()) {
                req.setAttribute("title", "Operation Failed.");
                req.setAttribute("icon", "error");
                RequestDispatcher requestDispatcher = req.getRequestDispatcher("/signup.jsp");
                requestDispatcher.forward(req, res);
            } else {
                req.setAttribute("title", "Operation Success.");
                req.setAttribute("icon", "success");
                RequestDispatcher requestDispatcher = req.getRequestDispatcher("/login.jsp");
                requestDispatcher.forward(req, res);
            }
        }
    }
}