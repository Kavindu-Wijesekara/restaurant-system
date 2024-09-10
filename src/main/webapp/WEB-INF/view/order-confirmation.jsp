<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    request.setAttribute("pageTitle", "Order Confirmation");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main class="container mt-5 order-confirmation">
    <h1 class="mb-4 text-amber">Order Confirmation</h1>
    <div class="card bg-dark-gray text-light">
        <div class="card-body">
            <h5 class="card-title text-amber">Order #${order.id}</h5>
            <p class="card-text">Thank you for your order!</p>
            <div class="order-details">
                <p><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="MM/dd/yyyy HH:mm:ss"/></p>
                <p><strong>Status:</strong> <span class="badge bg-amber text-dark">${order.status}</span></p>
                <p><strong>Delivery Method:</strong> ${order.deliveryMethod}</p>
                <c:if test="${order.deliveryMethod eq 'Delivery'}">
                    <p><strong>Delivery Address:</strong> ${order.address}</p>
                </c:if>
                <p><strong>Contact Number:</strong> ${order.contactNumber}</p>
            </div>

            <h6 class="mt-4 text-amber">Order Items:</h6>
            <c:if test="${not empty order and not empty order.orderItems}">
                <div class="table-responsive">
                    <table class="table table-dark table-striped table-hover">
                        <thead>
                        <tr>
                            <th>Item</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${order.orderItems}">
                            <tr>
                                <td>${item.name != null ? item.name : 'N/A'}</td>
                                <td>${item.quantity != null ? item.quantity : 'N/A'}</td>
                                <td>$<fmt:formatNumber value="${item.price != null ? item.price : 0}" pattern="#,##0.00"/></td>
                                <td>$<fmt:formatNumber value="${(item.price != null && item.quantity != null) ? item.price * item.quantity : 0}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                        <tfoot>
                        <tr class="table-amber">
                            <th colspan="3">Total Amount:</th>
                            <th>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </c:if>
            <c:if test="${empty order or empty order.orderItems}">
                <p class="text-muted">No items found for this order.</p>
            </c:if>
        </div>
    </div>
</main>

<%@include file="/WEB-INF/common/footer.jsp" %>