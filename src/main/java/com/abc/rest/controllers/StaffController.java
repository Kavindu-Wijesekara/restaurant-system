package com.abc.rest.controllers;

import com.abc.rest.models.Order;
import com.abc.rest.models.ReservationModel;
import com.abc.rest.services.StaffService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

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

@WebServlet("/staff")
public class StaffController extends HttpServlet {

    private static StaffService getStaffService() {
        return StaffService.getStaffService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Check if the request is for a static resource
        if (path.startsWith("/assets/")) {
            // Let the default servlet handle static resources
            getServletContext().getNamedDispatcher("default").forward(req, res);
            return;
        }

        switch (path) {
            case "/staff":
                handleStaffHome(req, res);
                break;
            default:
                req.getRequestDispatcher("/").forward(req, res);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String service = req.getParameter("service");

        if (service == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing service.");
            return;
        }

        switch (service) {
            case "reservation":
                handleReservation(req, res);
                break;
            case "order":
                handleOrder(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action type.");
        }
    }

    private void handleReservation(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String reservationId = req.getParameter("reservationId");
        String status = req.getParameter("status");
        String cancellationReason = req.getParameter("cancellationReason");
        String customerEmail = req.getParameter("customerEmail");

        if (reservationId == null || status == null || customerEmail == null) {
            sendJsonResponse(res, HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        if ("Cancelled".equals(status) && (cancellationReason == null || cancellationReason.trim().isEmpty())) {
            sendJsonResponse(res, HttpServletResponse.SC_BAD_REQUEST, "Cancellation reason is required when status is Cancelled");
            return;
        }

        try {
            boolean updated = getStaffService().updateReservationStatus(
                    Integer.parseInt(reservationId),
                    status,
                    "Cancelled".equals(status) ? cancellationReason : null,
                    customerEmail
            );

            if (updated) {
                sendJsonResponse(res, HttpServletResponse.SC_OK, "Reservation status updated successfully");
            } else {
                sendJsonResponse(res, HttpServletResponse.SC_NOT_FOUND, "Reservation not found or update failed");
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(res, HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
        } catch (Exception e) {
            sendJsonResponse(res, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating reservation status: " + e.getMessage());
        }
    }

    private void handleOrder(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String orderId = req.getParameter("orderId");
        String status = req.getParameter("status");

        if (orderId == null || status == null) {
            sendJsonResponse(res, HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try {
            boolean updated = getStaffService().updateOrderStatus(
                    Integer.parseInt(orderId),
                    status
            );

            if (updated) {
                sendJsonResponse(res, HttpServletResponse.SC_OK, "Order status updated successfully");
            } else {
                sendJsonResponse(res, HttpServletResponse.SC_NOT_FOUND, "Order not found or update failed");
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(res, HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        } catch (Exception e) {
            sendJsonResponse(res, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating order status: " + e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse res, int status, String message) throws IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        res.setStatus(status);

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("message", message);

        PrintWriter out = res.getWriter();
        out.print(new Gson().toJson(jsonResponse));
        out.flush();
    }

    private void handleStaffHome(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ReservationModel> reservations = new ArrayList<>();
        List<Order> orders = new ArrayList<>();

        try {
            reservations = getStaffService().getAllReservations();
            orders = getStaffService().getAllOrders();
        } catch (SQLException | ClassNotFoundException | NoSuchAlgorithmException e) {
            // Handle the exception
            System.out.println("Error fetching data: " + e.getMessage());
            req.setAttribute("errorMessage", "An error occurred while fetching data. Please try again later.");
            e.printStackTrace();
        } finally {
            // Always set these attributes, even if they're empty
            req.setAttribute("reservations", reservations);
            req.setAttribute("orders", orders);

            req.getRequestDispatcher("/WEB-INF/view/staff.jsp").forward(req, res);
        }
    }
}
