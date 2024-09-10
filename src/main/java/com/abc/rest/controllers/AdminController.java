package com.abc.rest.controllers;

import com.abc.rest.dao.AdminDao;
import com.abc.rest.dao.AdminDaoImpl;
import com.abc.rest.models.Branch;
import com.abc.rest.models.CommonMessageModel;
import com.abc.rest.models.UserModel;
import com.abc.rest.services.AdminService;
import com.abc.rest.services.HomeService;
import com.abc.rest.utils.data_mapper.DataMapper;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private AdminService adminService;
    private HomeService homeService;

    @Override
    public void init() throws ServletException {
        super.init();
        AdminDao adminDao = new AdminDaoImpl();
        this.adminService = new AdminService(adminDao);
        this.homeService = new HomeService();
    }

    private static DataMapper getDataMapper() {
        return DataMapper.getDataMapper();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        String action = request.getParameter("action");

        // Check if the request is for a static resource
        if (uri.startsWith("/assets/")) {
            getServletContext().getNamedDispatcher("default").forward(request, response);
            return;
        }

        if (uri.endsWith("/admin")) {
            request.getRequestDispatcher("WEB-INF/view/admin.jsp").forward(request, response);
        } else if (uri.endsWith("/admin/staff")) {
            if ("create-staff-user".equals(action)) {
                handleCreateStaffUserGet(request, response);
            } else {
                handleStaff(request, response);
            }
        } else if (uri.endsWith("/admin/reports")) {
            request.getRequestDispatcher("/WEB-INF/view/admin/reports.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        String action = request.getParameter("action");

        if (uri.endsWith("/admin/staff") && "create-staff-user".equals(action)) {
            handleCreateStaffUser(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleCreateStaffUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean res;
        CommonMessageModel message;
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            UserModel userData = new UserModel(
                    request.getParameter("full_name"),
                    request.getParameter("email"),
                    request.getParameter("phone"),
                    request.getParameter("address"),
                    Integer.parseInt(request.getParameter("branch_id")),
                    request.getParameter("password")
            );

            res = adminService.createStaffUser(userData);


            if (res) {
                message = new CommonMessageModel("User created successfully.", true, null);
                out.println(new Gson().toJson(message));
            } else {
                message = new CommonMessageModel("User creation failed. A user with the same email already exists", false, null);
                out.println(new Gson().toJson(message));
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            out.flush();
        }
    }

    private void handleCreateStaffUserGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Branch> branches = new ArrayList<Branch>();
        try {
            branches = homeService.getAllBranches();
            request.setAttribute("branches", branches);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException | NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        } finally {
            request.getRequestDispatcher("/WEB-INF/view/admin/new-staff-form.jsp").forward(request, response);
        }
    }

    private void handleStaff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<UserModel> staff = new ArrayList<UserModel>();
        try {
            staff = adminService.getAllStaffUsers();
            request.setAttribute("staff", staff);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } finally {
            request.getRequestDispatcher("/WEB-INF/view/admin/staff.jsp").forward(request, response);
        }
    }

}
