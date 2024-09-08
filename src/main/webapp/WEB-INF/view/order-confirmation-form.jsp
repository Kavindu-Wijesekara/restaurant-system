<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", "Confirm Order");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main class="container mt-5">
    <h1 class="mb-4">Confirm Your Order</h1>
    <form id="orderForm" method="post">
        <div class="row">
            <div class="col-md-6 mb-3">
                <h3>Delivery Information</h3>
                <div class="mb-3">
                    <label for="deliveryMethod" class="form-label">Delivery Method</label>
                    <select class="form-select" id="deliveryMethod" name="deliveryMethod" required>
                        <option value="">Choose...</option>
                        <option value="Delivery">Delivery</option>
                        <option value="Store Pickup">Store Pickup</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="branch_id" class="form-label">Branch</label>
                    <select class="form-control" id="branch_id" name="branch_id" required>
                        <option value="" disabled hidden selected>Select a branch</option>
                        <!-- Branches will be populated here by JavaScript -->
                    </select>
                </div>
                <div id="deliveryAddressGroup" class="mb-3">
                    <label for="address" class="form-label">Delivery Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3">${sessionScope.address}</textarea>
                </div>
                <div class="mb-3">
                    <label for="contactNumber" class="form-label">Contact Number</label>
                    <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="${sessionScope.phone}" required>
                </div>
            </div>
            <div class="col-md-6">
                <h3>Order Summary</h3>
                <div id="orderSummary"></div>
                <div class="text-end mt-3">
                    <h4>Total: $<span id="orderTotal">0.00</span></h4>
                </div>
            </div>
        </div>
        <button type="submit" class="btn btn-primary mt-3">Proceed to Payment</button>
    </form>

    <form id="payment-form" class="mt-4" style="display: none;">
        <div id="payment-element">
            <!-- Stripe Elements will create form elements here -->
        </div>
        <button id="submit" class="btn btn-primary mt-3">Pay now</button>
        <div id="error-message" class="text-danger mt-2">
            <!-- Display error message to your customers here -->
        </div>
    </form>

</main>

<%@include file="/WEB-INF/common/footer.jsp" %>

<script src="https://js.stripe.com/v3/"></script>
<script src="${pageContext.request.contextPath}/assets/js/order-confirmation.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    window.userId = <%= session.getAttribute("id") %>
    const branches = <%= new Gson().toJson(request.getAttribute("branches")) %>;

    // Populate the branch dropdown
    const branchSelect = document.getElementById('branch_id');

    branches.forEach(branch => {
        const option = document.createElement('option');
        option.value = branch.branchId;
        option.text = branch.branchName;
        branchSelect.add(option);
    });
})
</script>