<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${pageTitle} - ABC Restaurant</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container">
    <a class="navbar-brand" href="/">ABC Restaurant</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="/">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Gallery</a></li>
        <li class="nav-item"><a class="nav-link" href="/menu">Menu</a></li>
        <li class="nav-item"><a class="nav-link" href="/reservations">Reservations</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
        <% if (session.getAttribute("id") == null) { %>
        <li class="nav-item"><a class="nav-link" href="/auth?action-type=login">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="/auth?action-type=register">Sign Up</a></li>
        <% } else { %>
        <li class="nav-item"><a class="nav-link" href="/auth?action-type=logout">Logout</a></li>
        <% } %>
        <li class="nav-item">
          <button class="btn btn-outline-primary ms-2" type="button" data-bs-toggle="modal" data-bs-target="#cartModal">
            <i class="bi bi-cart"></i> Cart <span class="badge bg-secondary" id="cartItemCount">0</span>
          </button>
        </li>
      </ul>
    </div>
  </div>
</nav>