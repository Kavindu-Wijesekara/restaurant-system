<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="com.google.gson.JsonSerializer" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", "Staff Portal");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Staff Portal</h1>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                    ${errorMessage}
            </div>
        </c:if>

        <div class="text-center mb-4">
            <button class="btn btn-primary category-button" data-category="reservations">Reservations</button>
            <button class="btn btn-secondary category-button" data-category="orders">Orders</button>
        </div>

        <div id="content-container" class="row">
            <!-- Content will be dynamically added here -->
        </div>
    </div>
</main>

<!-- Status Update Modal -->
<div class="modal fade" id="statusUpdateModal" tabindex="-1" aria-labelledby="statusUpdateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="statusUpdateModalLabel">Update Reservation Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="statusUpdateForm">
                    <input type="hidden" id="reservationId" name="reservationId">
                    <input type="hidden" id="customerEmail" name="customerEmail">
                    <div class="mb-3">
                        <label for="statusSelect" class="form-label">Status</label>
                        <select class="form-select" id="statusSelect" name="status" required>
                            <option value="">Choose status...</option>
                            <option value="Pending">Pending</option>
                            <option value="Confirmed">Confirmed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div id="cancellationReasonDiv" class="mb-3" style="display: none;">
                        <label for="cancellationReason" class="form-label">Cancellation Reason</label>
                        <textarea class="form-control" id="cancellationReason" name="cancellationReason" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="updateStatusBtn">Update Status</button>
            </div>
        </div>
    </div>
</div>

<!-- Order Status Update Modal -->
<div class="modal fade" id="orderStatusUpdateModal" tabindex="-1" aria-labelledby="orderStatusUpdateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderStatusUpdateModalLabel">Update Order Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="orderStatusUpdateForm">
                    <input type="hidden" id="orderId" name="orderId">
                    <input type="hidden" id="customerEmailOrder" name="customerEmailOrder">
                    <div class="mb-3">
                        <label for="orderStatusSelect" class="form-label">Status</label>
                        <select class="form-select" id="orderStatusSelect" name="status" required>
                            <option value="">Choose status...</option>
                            <option value="Pending">Pending</option>
                            <option value="Preparing">Preparing</option>
                            <option value="Ready for Pickup">Ready for Pickup</option>
                            <option value="Out for Delivery">Out for Delivery</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div id="orderCancellationReasonDiv" class="mb-3" style="display: none;">
                        <label for="orderCancellationReason" class="form-label">Cancellation Reason</label>
                        <textarea class="form-control" id="orderCancellationReason" name="cancellationReason" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="updateOrderStatusBtn">Update Status</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<%@include file="/WEB-INF/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    <%
        // Create custom Gson instance with LocalDate and LocalTime adapters
        JsonSerializer<LocalDate> localDateSerializer = (src, typeOfSrc, context) ->
            src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE));

        JsonSerializer<LocalTime> localTimeSerializer = (src, typeOfSrc, context) ->
            src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_TIME));

        Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, localDateSerializer)
            .registerTypeAdapter(LocalTime.class, localTimeSerializer)
            .create();
    %>
    // Convert Java object lists to JSON using custom Gson instance
    const reservations = <%= gson.toJson(request.getAttribute("reservations")) %>;
    const orders = <%= gson.toJson(request.getAttribute("orders")) %>;

    $(document).ready(function() {
        // Function to display content based on category
        function displayContent(category) {
            $("#content-container").empty(); // Clear existing content

            if (category === "reservations") {
                if (reservations.length === 0) {
                    $("#content-container").append('<p>No reservations available.</p>');
                    return;
                }
                const reservationTable =
                    '<table class="table table-striped">' +
                    '<thead>' +
                    '<tr>' +
                    '<th>ID</th>' +
                    '<th>Customer Name</th>' +
                    '<th>Date</th>' +
                    '<th>Time</th>' +
                    '<th>Party Size</th>' +
                    '<th>Type</th>' +
                    '<th>Status</th>' +
                    '<th>Actions</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>' +
                    reservations.map((reservation, index) =>
                        '<tr>' +
                        '<td>' + (reservation.reservation_id || '') + '</td>' +
                        '<td>' + (reservation.customer_name || '') + '</td>' +
                        '<td>' + (reservation.reservation_date || '') + '</td>' +
                        '<td>' + (reservation.reservation_time || '') + '</td>' +
                        '<td>' + (reservation.number_of_people || '') + '</td>' +
                        '<td>' + (reservation.reservation_type || '') + '</td>' +
                        '<td>' + (reservation.status || '') + '</td>' +
                        '<td>' +
                        '<button class="btn btn-info btn-sm me-2" type="button" data-bs-toggle="collapse" data-bs-target="#details' + index + '" aria-expanded="false" aria-controls="details' + index + '">' +
                        'Details' +
                        '</button>' +
                        '<button class="btn btn-primary btn-sm update-status" data-reservation-id="' + reservation.reservation_id + '" data-customer-email="' + reservation.customer_email + '">' +
                        'Update Status' +
                        '</button>' +
                        '</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td colspan="8" class="p-0">' +
                        '<div class="collapse" id="details' + index + '">' +
                        '<div class="card card-body">' +
                        '<p><strong>Email:</strong> ' + (reservation.customer_email || '') + '</p>' +
                        '<p><strong>Phone:</strong> ' + (reservation.customer_phone || '') + '</p>' +
                        '<p><strong>Created At:</strong> ' + (reservation.created_at || '') + '</p>' +
                        '<p><strong>Special Request:</strong> ' + (reservation.special_request || 'None') + '</p>' +
                        '</div>' +
                        '</div>' +
                        '</td>' +
                        '</tr>'
                    ).join('') +
                    '</tbody>' +
                    '</table>';

                $("#content-container").append(reservationTable);
            } else if (category === "orders") {
                if (orders.length === 0) {
                    $("#content-container").append('<p>No orders available.</p>');
                    return;
                }
                const orderTable =
                    '<table class="table table-striped">' +
                    '<thead>' +
                    '<tr>' +
                    '<th>ID</th>' +
                    '<th>Customer Name</th>' +
                    '<th>Order Date</th>' +
                    '<th>Total Amount</th>' +
                    '<th>Status</th>' +
                    '<th>Payment Status</th>' +
                    '<th>Delivery Method</th>' +
                    '<th>Actions</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>' +
                    orders.map((order, index) =>
                        '<tr>' +
                        '<td>' + (order.id || '') + '</td>' +
                        '<td>' + (order.full_name || '') + '</td>' +
                        '<td>' + (order.orderDate || '') + '</td>' +
                        '<td>$' + (order.totalAmount ? order.totalAmount.toFixed(2) : '0.00') + '</td>' +
                        '<td>' + (order.status || '') + '</td>' +
                        '<td>' + (order.paymentStatus || '') + '</td>' +
                        '<td>' + (order.deliveryMethod || '') + '</td>' +
                        '<td>' +
                        '<button class="btn btn-info btn-sm me-2" type="button" data-bs-toggle="collapse" data-bs-target="#orderDetails' + index + '" aria-expanded="false" aria-controls="orderDetails' + index + '">' +
                        'Details' +
                        '</button>' +
                        '<button class="btn btn-primary btn-sm update-order-status" data-order-id="' + order.id + '" data-customer-email="' + order.email + '">' +
                        'Update Status' +
                        '</button>' +
                        '</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td colspan="8" class="p-0">' +
                        '<div class="collapse" id="orderDetails' + index + '">' +
                        '<div class="card card-body">' +
                        '<p><strong>Address:</strong> ' + (order.address || '') + '</p>' +
                        '<p><strong>Email:</strong> ' + (order.email || '') + '</p>' +
                        '<p><strong>Contact Number:</strong> ' + (order.contactNumber || '') + '</p>' +
                        '<p><strong>User ID:</strong> ' + (order.userId || '') + '</p>' +
                        '<h6>Order Items:</h6>' +
                        '<ul>' +
                        (order.orderItems ? order.orderItems.map(item =>
                            '<li>' + item.name + ' (Quantity: ' + item.quantity + ')</li>'
                        ).join('') : '') +
                        '</ul>' +
                        '</div>' +
                        '</div>' +
                        '</td>' +
                        '</tr>'
                    ).join('') +
                    '</tbody>' +
                    '</table>';

                $("#content-container").append(orderTable);
            }
        }

        // Event listener for category buttons
        $(".category-button").click(function() {
            const category = $(this).data("category");
            displayContent(category);
        });

        // Event listener for update reservation status buttons
        $(document).on('click', '.update-status', function() {
            const reservationId = $(this).data('reservation-id');
            const customerEmail = $(this).data('customer-email');
            $('#reservationId').val(reservationId);
            $('#customerEmail').val(customerEmail);
            $('#statusUpdateModal').modal('show');
        });

        // Event listener for order update status buttons
        $(document).on('click', '.update-order-status', function() {
            const orderId = $(this).data('order-id');
            const customerEmail = $(this).data('customer-email');
            $('#orderId').val(orderId);
            $('#customerEmailOrder').val(customerEmail);
            $('#orderStatusUpdateModal').modal('show');
        });

        // Event listener for status select
        $('#statusSelect').change(function() {
            if ($(this).val() === 'Cancelled') {
                $('#cancellationReasonDiv').show();
            } else {
                $('#cancellationReasonDiv').hide();
            }
        });

        // Event listener for order status select
        $('#orderStatusSelect').change(function() {
            if ($(this).val() === 'Cancelled') {
                $('#orderCancellationReasonDiv').show();
            } else {
                $('#orderCancellationReasonDiv').hide();
            }
        });

        // Event listener for update reservation status submit
        $('#updateStatusBtn').click(function() {
            const formData = $('#statusUpdateForm').serialize();
            $.ajax({
                url: '/staff?service=reservation',
                method: 'POST',
                data: formData,
                success: function(response) {
                    $('#statusUpdateModal').modal('hide');
                    Swal.fire({
                        title: 'Success!',
                        text: 'Reservation status updated successfully.',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload(); // Reload the page to reflect changes
                        }
                    });
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        title: 'Error!',
                        text: 'Failed to update reservation status. Please try again.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        });

        // Event listener for order update status submit
        $('#updateOrderStatusBtn').click(function() {
            const formData = $('#orderStatusUpdateForm').serialize();
            $.ajax({
                url: '/staff?service=order',
                method: 'POST',
                data: formData,
                success: function(response) {
                    $('#orderStatusUpdateModal').modal('hide');
                    Swal.fire({
                        title: 'Success!',
                        text: 'Order status updated successfully.',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload(); // Reload the page to reflect changes
                        }
                    });
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        title: 'Error!',
                        text: 'Failed to update order status. Please try again.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        });

        // Display reservations by default on page load
        displayContent("reservations");
    });
</script>
</body>
</html>