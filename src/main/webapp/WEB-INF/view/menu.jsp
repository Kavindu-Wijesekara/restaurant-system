<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  request.setAttribute("pageTitle", "Menu");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main>
  <div class="container mt-5">
    <h1 class="text-center mb-4">Restaurant Menu</h1>
    <div class="text-center mb-4">
      <button class="btn btn-primary category-button" data-category="all">All</button>
      <button class="btn btn-secondary category-button" data-category="Appetizers">Appetizers</button>
      <button class="btn btn-success category-button" data-category="Main Courses">Main Courses</button>
      <button class="btn btn-danger category-button" data-category="Desserts">Desserts</button>
    </div>

    <div id="menu-items" class="row">
      <!-- Menu items will be dynamically added here -->
    </div>
  </div>
</main>

<!-- Footer -->
<%@include file="/WEB-INF/common/footer.jsp" %>
<script>
  // Convert Java object list to JSON
  const restaurantMenu = <%= new Gson().toJson(request.getAttribute("menuItems")) %>;

  $(document).ready(function() {
    // Function to display menu items
    function displayMenuItems(category) {
      $("#menu-items").empty(); // Clear existing items

      let itemsToDisplay = category === "all" ? restaurantMenu : restaurantMenu.filter(item => item.item_type === category);

      // Loop through the items and append them to the menu container
      itemsToDisplay.forEach(function (item) {
        const menuItem =
                '<div class="col-md-6 mb-4">' +
                '<div class="card h-100">' +
                '<div class="card-body">' +
                '<h3 class="card-title">' + item.item_name + '</h3>' +
                '<p class="card-text">' + item.item_description + '</p>' +
                '<p class="card-text"><strong>Price: $' + item.price.toFixed(2) + '</strong></p>' +
                '<button class="btn btn-primary add-to-cart" data-id="' + item.id + '" data-name="' + item.item_name + '" data-price="' + item.price + '">Add to Cart</button>' +
                '</div>' +
                '</div>' +
                '</div>';
        $("#menu-items").append(menuItem);
      });
    }

    // Event listener for category buttons
    $(".category-button").click(function() {
      const category = $(this).data("category");
      displayMenuItems(category);
    });

    // Event listener for Add to Index buttons
    $(document).on('click', '.add-to-cart', function() {
      const foodId = $(this).data('id');
      const name = $(this).data('name');
      const price = $(this).data('price');

      window.cart.addItem(foodId, name, price, 1);
      window.updateCartDisplay();

      Swal.fire({
        title: 'Added to Cart!',
        text: name + ' has been added to your cart.',
        icon: 'success',
        timer: 1500,
        showConfirmButton: false
      });
    });

    // Display all items by default on page load
    displayMenuItems("all");
  });
</script>
</body>
</html>