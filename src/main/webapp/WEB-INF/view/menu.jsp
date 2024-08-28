<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ABC Restaurant - Home</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/assets/css/styles.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    html, body {
      height: 100%;
    }

    body {
      display: flex;
      flex-direction: column;
    }

    main {
      flex: 1;
    }

    footer {
      flex-shrink: 0;
    }
  </style>
</head>
<body>
<!-- Navbar -->
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
  // Convert Java object list to JSON
  const restaurantMenu = <%= new Gson().toJson(request.getAttribute("menuItems")) %>;

  $(document).ready(function() {
    // Function to display menu items
    function displayMenuItems(category) {
      $("#menu-items").empty(); // Clear existing items

      let itemsToDisplay = [];

      if (category === "all") {
        // If "all" is selected, display all items
        itemsToDisplay = restaurantMenu;
      } else {
        // Otherwise, filter items based on the selected category
        itemsToDisplay = restaurantMenu.filter(item => item.item_type === category);
      }

      // Loop through the items and append them to the menu container
      itemsToDisplay.forEach(function (item) {
        const menuItem =
                '<div class="col-md-6 mb-4">' +
                '<div class="card h-100">' +
                '<div class="card-body">' +
                '<h3 class="card-title">' + item.item_name + '</h3>' +
                '<p class="card-text">' + item.item_description + '</p>' +
                '<p class="card-text"><strong>Price: $' + item.price.toFixed(2) + '</strong></p>' +
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

    // Display all items by default on page load
    displayMenuItems("all");
  });
</script>
</body>
</html>
