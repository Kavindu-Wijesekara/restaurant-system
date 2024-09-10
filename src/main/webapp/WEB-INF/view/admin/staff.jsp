<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Staff - ABC Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-styles.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        .container {
            background-color: #1a1a1a;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }
        h1 {
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
        .table {
            color: #e0e0e0;
            border-color: #333;
        }
        .table-dark th {
            background-color: #ffc107;
            color: #121212;
            border-color: #333;
        }
        .table tbody tr td {
            color: #e0e0e0 !important;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(255, 255, 255, 0.05);
        }
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #bb2d3b;
            border-color: #bb2d3b;
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
    <h1 class="mb-4">Manage Staff</h1>
    <a href="/admin/staff?action=create-staff-user" class="btn btn-primary mb-3">
        Add Staff
    </a>
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Branch</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="staffTableBody">
            <!-- Data will be populated here by jQuery -->
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const staff = <%= new Gson().toJson(request.getAttribute("staff")) %>;

    $(document).ready(function() {
        const $staffTableBody = $('#staffTableBody');

        if (staff && staff.length > 0) {
            staff.forEach(function(staffMember) {
                const row = '<tr>' +
                    '<td>' + staffMember.id + '</td>' +
                    '<td>' + staffMember.full_name + '</td>' +
                    '<td>' + staffMember.phone + '</td>' +
                    '<td>' + staffMember.email + '</td>' +
                    '<td>' + staffMember.branch_name + '</td>' +
                    '<td>' +
                    '<button class="btn btn-sm btn-danger delete-btn"><i class="fas fa-trash-alt me-2"></i>Delete</button>' +
                    '</td>' +
                    '</tr>';
                $staffTableBody.append(row);
            });
        } else {
            $staffTableBody.append('<tr><td colspan="6" class="text-center">No staff members available</td></tr>');
        }

        $('.delete-btn').click(function() {
            alert('Delete functionality to be implemented.');
        });
    });
</script>
</body>
</html>