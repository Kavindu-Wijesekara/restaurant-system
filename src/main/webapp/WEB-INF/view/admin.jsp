<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Home Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-styles.css">
    <style>
        body {
            background-color: #121212;
            color: #e0e0e0;
        }
        .navbar {
            background-color: #1a1a1a !important;
        }
        .navbar-brand, .nav-link {
            color: #ffc107 !important;
        }
        .nav-link:hover {
            color: #ffca2c !important;
        }
        .tile {
            background-color: #1a1a1a;
            border: none;
            transition: all 0.3s ease;
        }
        .tile:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(255, 193, 7, 0.2) !important;
        }
        .tile .card-body {
            padding: 2rem;
        }
        .tile .icon {
            font-size: 3rem;
            color: #ffc107;
        }
        .tile .card-title {
            color: #ffc107;
            font-weight: bold;
        }
        .tile .card-text {
            color: #e0e0e0;
        }
        .shadow-custom {
            box-shadow: 0 4px 6px rgba(255, 193, 7, 0.1);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">ABC Restaurant</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/admin">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/auth?action-type=logout">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="container-fluid min-vh-100 d-flex align-items-center justify-content-center">
    <div class="row text-center g-4">
        <div class="col-md-6 mb-4">
            <div class="tile card shadow-custom" onclick="window.location.href='/admin/staff';">
                <div class="card-body">
                    <i class="bi bi-people-fill icon mb-3"></i>
                    <h3 class="card-title">Manage Staff</h3>
                    <p class="card-text">Add, edit, or remove staff members.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6 mb-4">
            <div class="tile card shadow-custom" onclick="window.location.href='/admin/reports';">
                <div class="card-body">
                    <i class="bi bi-bar-chart-fill icon mb-3"></i>
                    <h3 class="card-title">Reports</h3>
                    <p class="card-text">View system and user reports.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>