<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  request.setAttribute("pageTitle", "Menu");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main class="bg-dark text-light py-5">
  <div class="container">
    <h1 class="text-center mb-5 text-amber">Our Culinary Delights</h1>
    <div class="text-center mb-4">
      <div class="btn-group category-buttons" role="group" aria-label="Menu categories">
        <button class="btn btn-outline-amber category-button active" data-category="all">All</button>
        <button class="btn btn-outline-amber category-button" data-category="Appetizers">Appetizers</button>
        <button class="btn btn-outline-amber category-button" data-category="Main Courses">Main Courses</button>
        <button class="btn btn-outline-amber category-button" data-category="Desserts">Desserts</button>
      </div>
    </div>

    <div id="menu-items" class="row g-4">
      <!-- Menu items will be dynamically added here -->
    </div>
  </div>
</main>

<!-- Footer -->
<%@include file="/WEB-INF/common/footer.jsp" %>

<style>
  .bg-dark {
    background-color: #121212;
  }
  .text-amber {
    color: #ffc107;
  }
  .btn-outline-amber {
    color: #ffc107;
    border-color: #ffc107;
  }
  .btn-outline-amber:hover,
  .btn-outline-amber.active {
    background-color: #ffc107;
    color: #121212;
  }
  .card {
    background-color: #1a1a1a;
    border: none;
    transition: transform 0.3s ease-in-out;
  }
  .card:hover {
    transform: translateY(-5px);
  }
  .card-body {
    border-top: 2px solid #ffc107;
  }
  .card-title {
    color: #ffc107;
  }
  .card-text {
    color: #e0e0e0;
  }
  .btn-add-to-cart {
    background-color: #ffc107;
    color: #121212;
    border: none;
    transition: background-color 0.3s ease-in-out;
  }
  .btn-add-to-cart:hover {
    background-color: #ffca2c;
  }
  .price {
    font-size: 1.2rem;
    font-weight: bold;
    color: #ffc107;
  }
</style>

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
                '<div class="col-md-6 col-lg-4 mb-4">' +
                '<div class="card h-100 shadow">' +
                '<div class="card-body d-flex flex-column">' +
                '<h3 class="card-title">' + item.item_name + '</h3>' +
                '<p class="card-text flex-grow-1">' + item.item_description + '</p>' +
                '<div class="d-flex justify-content-between align-items-center">' +
                '<p class="price mb-0">$' + item.price.toFixed(2) + '</p>' +
                '<button class="btn btn-add-to-cart add-to-cart" data-id="' + item.id + '" data-name="' + item.item_name + '" data-price="' + item.price + '">Add to Cart</button>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
        $("#menu-items").append(menuItem);
      });
    }

    // Event listener for category buttons
    $(".category-button").click(function() {
      $(".category-button").removeClass("active");
      $(this).addClass("active");
      const category = $(this).data("category");
      displayMenuItems(category);
    });

    // Event listener for Add to Cart buttons
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
        showConfirmButton: false,
        background: '#1a1a1a',
        color: '#e0e0e0',
        iconColor: '#ffc107'
      });
    });

    // Display all items by default on page load
    displayMenuItems("all");
  });
</script>
</body>
</html>