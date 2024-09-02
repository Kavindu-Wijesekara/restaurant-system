package com.abc.rest.controllers;

import com.abc.rest.models.Order;
import com.abc.rest.models.OrderItem;
import com.abc.rest.services.OrderService;
import com.abc.rest.services.StripeService;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/order/*")
public class OrderController extends HttpServlet {

    private OrderService orderService;
    private StripeService stripeService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        orderService = new OrderService(); // Assuming you have this implemented
        stripeService = new StripeService();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
            return;
        }

        String[] splits = pathInfo.split("/");
        if (splits.length != 2) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
            return;
        }

        String action = splits[1];
        switch (action) {
            case "confirm":
                req.getRequestDispatcher("/WEB-INF/view/order-confirmation-form.jsp").forward(req, resp);
                break;
            case "confirmation":
                showOrderConfirmation(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if ("/submit".equals(pathInfo)) {
            submitOrder(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void submitOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            // Read JSON data from request body
            BufferedReader reader = req.getReader();
            JsonObject jsonObject = JsonParser.parseReader(reader).getAsJsonObject();

            // Extract order details
            Order order = gson.fromJson(jsonObject, Order.class);

            // Extract order items
            JsonArray itemsArray = jsonObject.getAsJsonArray("orderItems");
            List<OrderItem> orderItems = gson.fromJson(itemsArray, new TypeToken<List<OrderItem>>(){}.getType());


            // Set order items to the order
            order.setOrderItems(orderItems);

            // Create and save the order
            Order savedOrder = orderService.createOrder(order);

            // Create Stripe PaymentIntent
            String clientSecret = stripeService.createPaymentIntent(savedOrder.getTotalAmount(), savedOrder.getId());

            // Prepare response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("orderId", savedOrder.getId());
            responseData.put("clientSecret", clientSecret);

            out.print(gson.toJson(responseData));
        } catch (IllegalArgumentException e) {
            // Handle validation errors
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Validation error: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        } catch (SQLException e) {
            // Handle database errors
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Database error occurred. Please try again later.");
            out.print(gson.toJson(errorResponse));
            e.printStackTrace();
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Error processing order: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }

    private void showOrderConfirmation(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderId = req.getParameter("id");
        String payment_intent_id = req.getParameter("payment_intent");

        if (orderId == null || orderId.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
            return;
        }

        try {
            boolean success = orderService.updateOrderPaymentStatus(Integer.parseInt(orderId), "Paid", "Preparing", payment_intent_id);

            if (!success) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update order status");
                return;
            }
            Order order = orderService.getOrderById(Integer.parseInt(orderId));
            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            req.setAttribute("order", order);
            req.getRequestDispatcher("/WEB-INF/view/order-confirmation.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            System.out.println("Controller Invalid Order ID: " + orderId);
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Order ID");
        } catch (SQLException e) {
            System.out.println("Controller Database error when retrieving order: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
        catch (Exception e) {
            System.out.println("Controller Unexpected error when retrieving order: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error occurred");
            e.printStackTrace();
        }
    }
}




