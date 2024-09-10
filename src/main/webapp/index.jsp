<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader ("Expires", 0);
%>
<%@include file="WEB-INF/common/header.jsp" %>

<main>
    <!-- Hero Section -->
    <section class="hero bg-dark text-light text-center py-4">
        <div class="container">
            <% if (session.getAttribute("full_name") != null) { %>
            <h3 class="text-amber">Welcome back, <%= session.getAttribute("full_name") %>!</h3>
            <% } %>
            <h1 class="display-4 mb-3">ABC Restaurant</h1>
            <p class="lead mb-4">Exquisite Dining in the Heart of the City</p>
            <a href="/reservations" class="btn btn-amber btn-lg">Make a Reservation</a>
        </div>
    </section>

    <!-- About Section -->
    <section class="about py-5 bg-dark-gray">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2 class="text-amber mb-3">Our Story</h2>
                    <p class="text-light">ABC Restaurant has been serving delightful culinary experiences since 1995. Our passion for food and dedication to quality ingredients have made us a favorite among food enthusiasts.</p>
                </div>
                <div class="col-md-6">
                    <img src="/assets/images/food-2.jpg" alt="Restaurant interior" class="img-fluid rounded shadow">
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Dishes Section -->
    <section class="featured-dishes py-5 bg-darker-gray">
        <div class="container">
            <h2 class="text-amber text-center mb-4">Featured Dishes</h2>
            <div class="row g-4 masonry-grid">
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-1.jpg" alt="Dish 1" class="img-fluid rounded shadow">
                </div>
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-5.jpg" alt="Dish 2" class="img-fluid rounded shadow">
                </div>
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-3.jpg" alt="Dish 3" class="img-fluid rounded shadow">
                </div>
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-6.jpg" alt="Dish 4" class="img-fluid rounded shadow">
                </div>
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-9.jpg" alt="Dish 5" class="img-fluid rounded shadow">
                </div>
                <div class="col-6 col-md-4 col-lg-3">
                    <img src="/assets/images/food-7.jpg" alt="Dish 6" class="img-fluid rounded shadow">
                </div>
            </div>
        </div>
    </section>

    <!-- Special Offer Section -->
    <section class="special-offer py-5 bg-dark-gray">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 order-md-2">
                    <h2 class="text-amber mb-3">Special Offer</h2>
                    <p class="text-light">Join us for our Chef's Tasting Menu, available every Friday and Saturday evening. Experience a curated selection of our finest dishes paired with exquisite wines.</p>
                    <a href="/menu" class="btn btn-outline-amber">View Menu</a>
                </div>
                <div class="col-md-6 order-md-1 mt-3 mt-md-0">
                    <img src="/api/placeholder/600/400" alt="Chef's Tasting Menu" class="img-fluid rounded shadow">
                </div>
            </div>
        </div>
    </section>
</main>

<!-- Footer -->
<%@include file="WEB-INF/common/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
