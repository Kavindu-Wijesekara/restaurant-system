<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .card {
            background-color: #1a1a1a;
            border: none;
            transition: transform 0.3s ease-in-out;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-title {
            color: #ffc107;
        }
        .btn-primary {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #121212;
        }
        .btn-primary:hover {
            background-color: #ffca2c;
            border-color: #ffca2c;
            color: #121212;
        }
        .admin-header {
            background-color: #1a1a1a;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 30px;
            border-radius: 0 5px 5px 0;
        }
        .report-icon {
            font-size: 2rem;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
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
<div class="container mt-5">
    <div class="admin-header">
        <h1 class="mb-0">Reports Dashboard</h1>
    </div>
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title text-center">Orders</h5>
                    <p class="card-text text-center flex-grow-1">Detailed breakdown of order activity.</p>
                    <a href="/admin/reports?type=orders" class="btn btn-primary mt-auto w-100">View Report</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title text-center">Reservations</h5>
                    <p class="card-text text-center flex-grow-1">Detailed breakdown of reservation activity.</p>
                    <a href="/admin/reports?type=reservations" class="btn btn-primary mt-auto w-100">View Report</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>