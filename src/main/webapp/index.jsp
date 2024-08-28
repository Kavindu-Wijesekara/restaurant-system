<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader ("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Restaurant - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
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
<%@include file="WEB-INF/common/header.jsp" %>

<main>
    <!-- Hero Section -->
    <section class="hero bg-dark text-light text-center py-5">
        <h1>Welcome, <%= session.getAttribute("full_name") %></h1>
        <div class="container">
            <h1 class="display-4">Welcome to ABC Restaurant</h1>
            <p class="lead">Delicious food, Cozy Atmosphere, Memorable Experience</p>
            <a href="/reservations" class="btn btn-primary btn-lg">Make a Reservation</a>
        </div>
    </section>
</main>

<!-- Footer -->
<%@include file="WEB-INF/common/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
