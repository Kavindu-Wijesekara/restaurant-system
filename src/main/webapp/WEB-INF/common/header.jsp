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
        <li class="nav-item"><a class="nav-link" href="menu">Menu</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Reservations</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
        <% if (session.getAttribute("id") == null) { %>
        <li class="nav-item"><a class="nav-link" href="auth?action-type=login">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="auth?action-type=register">Sign Up</a></li>
        <% } else { %>
        <li class="nav-item"><a class="nav-link" href="auth?action-type=logout">Logout</a></li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>