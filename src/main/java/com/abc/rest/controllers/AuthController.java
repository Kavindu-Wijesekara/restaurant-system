package com.abc.rest.controllers;


import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.LoginModel;
import com.abc.rest.models.UserModel;
import com.abc.rest.services.AuthService;
import com.abc.rest.utils.data_mapper.DataMapper;
import com.google.gson.Gson;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private static DataMapper getDataMapper() {
        return DataMapper.getDataMapper();
    }

    private static AuthService getAuthService() {
        return AuthService.getAuthService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String actionType = req.getParameter("action-type");

        if (actionType == null) {
            // Handle the case where actionType is missing
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action type.");
            return;
        }

        switch (actionType) {
            case "login":
                req.getRequestDispatcher("WEB-INF/view/login.jsp").forward(req, res);
                break;
            case "register":
                req.getRequestDispatcher("WEB-INF/view/signup.jsp").forward(req, res);
                break;
            case "logout":
                logoutUser(req, res);
                break;
            default:
                // Handle unknown action type
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action type.");
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String actionType = req.getParameter("action-type");

        if (actionType == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action type.");
            return;
        }

        switch (actionType) {
            case "login":
                loginUser(req, res);
                break;
            case "register":
                registerUser(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action type.");
        }
    }

    void loginUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        CommonMessageModel message;
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        try {
            LoginModel loginModel = new Gson().fromJson(getDataMapper().mapData(req), LoginModel.class);
            message = getAuthService().loginUser(loginModel, req);

            out.print(new Gson().toJson(message.toJsonObject()));
            out.flush();

        } catch (Exception e) {
            message = new CommonMessageModel("Something went wrong.", false, null);
            out.print(new Gson().toJson(message.toJsonObject()));
            out.flush();
            e.printStackTrace();
        }
    }

    void registerUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        CommonMessageModel message;
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        try {
            UserModel userData = new Gson().fromJson(getDataMapper().mapData(req), UserModel.class);
            message = getAuthService().registerUser(userData, req);

            out.print(new Gson().toJson(message.toJsonObject()));
            out.flush();

        } catch (Exception e) {
            message = new CommonMessageModel("Something went wrong.", false, null);
            out.print(new Gson().toJson(message.toJsonObject()));
            out.flush();
            e.printStackTrace();
        }
    }

    void logoutUser(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        HttpSession session = req.getSession(false);

        if (session.getAttribute("id") != null) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/");
        }
    }
}
