<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-styles.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .bg-dark {
            background-color: #121212 !important;
        }
        .bg-dark-gray {
            background-color: #1a1a1a !important;
        }
        .bg-dark-input {
            background-color: #2a2a2a !important;
            border-color: #3a3a3a !important;
        }
        .text-amber {
            color: #ffc107 !important;
        }
        .border-amber {
            border-color: #ffc107 !important;
        }
        .bg-amber {
            background-color: #ffc107 !important;
        }
        .btn-amber {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #121212;
        }
        .btn-amber:hover {
            background-color: #ffca2c;
            border-color: #ffca2c;
            color: #121212;
        }
        .form-control:focus, .form-select:focus {
            border-color: #ffc107;
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.25);
        }
    </style>
</head>
<body class="bg-dark text-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand text-amber" href="/">ABC Restaurant</a>
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
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card bg-dark-gray border-amber">
                <div class="card-header bg-amber text-dark">
                    <h2 class="mb-0">Add New Staff</h2>
                </div>
                <div class="card-body">
                    <form id="addStaffForm" method="POST" onsubmit="validateForm()">
                        <div class="mb-3">
                            <label for="full_name" class="form-label text-light">Full Name</label>
                            <input type="text" class="form-control bg-dark-input text-light" id="full_name" name="full_name" placeholder="Enter staff's full name" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label text-light">Email Address</label>
                            <input type="email" class="form-control bg-dark-input text-light" id="email" name="email" placeholder="Enter staff's email" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label text-light">Phone Number</label>
                            <input type="tel" class="form-control bg-dark-input text-light" id="phone" name="phone" placeholder="Enter staff's phone number" required>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label text-light">Address</label>
                            <textarea class="form-control bg-dark-input text-light" id="address" name="address" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="branch_id" class="form-label text-light">Branch</label>
                            <select class="form-select bg-dark-input text-light" id="branch_id" name="branch_id" required>
                                <option value="" disabled hidden selected>Select a branch</option>
                                <!-- Branches will be populated here by JavaScript -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label text-light">Password</label>
                            <input type="password" class="form-control bg-dark-input text-light" id="password" name="password" placeholder="Enter a password" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label text-light">Confirm Password</label>
                            <input type="password" class="form-control bg-dark-input text-light" id="confirmPassword" name="confirmPassword" placeholder="Confirm the password" required>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-amber">Add Staff</button>
                            <a href="/admin/staff" class="btn btn-outline-light">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const branches = <%= new Gson().toJson(request.getAttribute("branches")) %>;

        // Populate the branch dropdown
        const branchSelect = document.getElementById('branch_id');

        branches.forEach(branch => {
            const option = document.createElement('option');
            option.value = branch.branchId;
            option.text = branch.branchName;
            branchSelect.add(option);
        });
    })

    function validateForm() {
        const emailRegex = /^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/;
        const phonePattern = /[^0-9+]/g;
        const full_name = document.forms['addStaffForm']['full_name'].value.trim();
        const email = document.forms['addStaffForm']['email'].value.trim();
        const phoneNumber = document.forms['addStaffForm']['phone'].value.trim();
        const password = document.forms['addStaffForm']['password'].value;
        const confirmPassword = document.forms['addStaffForm']['confirmPassword'].value;

        if(full_name.length > 30 || full_name === "") {
            showDialogBox("Operation Failed.", "Invalid Full Name", "error");
            return false;
        } else if(!emailRegex.test(email)) {
            showDialogBox("Operation Failed.", "Invalid E-mail", "error");
            return false;
        } else if(phoneNumber.length > 15 || phoneNumber.length < 6 || phonePattern.test(phoneNumber)) {
            showDialogBox("Operation Failed.", "Invalid Phone Number", "error");
            return false;
        } else if (!(password.length >= 6 && password.length <= 24)) {
            showDialogBox("Operation Failed.", "Password length must be between 6 and 24 characters.", "error");
            return false;
        } else if(!password.match(/[A-Z]/) || !password.match(/\d/)) {
            showDialogBox("Operation Failed.", "Password does not meet the criteria: Must contain at least one uppercase letter and one number.", "error");
            return false;
        } else if(password !== confirmPassword) {
            showDialogBox("Operation Failed.", "Passwords do not match", "error");
            return false;
        } else {
            showLoader();
            return true;
        }
    }

    function showLoader() {
        Swal.fire({
            title: 'Loading...',
            allowOutsideClick: false,
            showConfirmButton: false,
            didOpen: () => {
                Swal.showLoading()
            }
        })
    }

    function showDialogBox(title, message, icon) {
        Swal.fire({
            title: title,
            text: message,
            icon: icon,
            confirmButtonText: 'Close'
        })
    }

    $(document).ready(function() {
        $('#addStaffForm').on('submit', function(e) {
            e.preventDefault(); // Prevent form from submitting normally

            if (!validateForm()) {
                return; // Stop submission if validation fails
            }


            $.ajax({
                type: 'POST',
                url: '/admin/staff?action=create-staff-user', // Replace with your backend endpoint
                data: {
                    full_name: $('#full_name').val(),
                    email: $('#email').val(),
                    phone: $('#phone').val(),
                    address: $('#address').val(),
                    branch_id: $('#branch_id').val(),
                    password: $('#password').val()
                },
                dataType: 'json',
                success: function(response) {
                    Swal.close(); // Close loader
                    if(response.success) {
                        Swal.fire({
                            title: 'Success',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then(() => {
                            window.location.href = '/admin/staff';
                        })
                    } else {
                        showDialogBox('Error', response.message, 'error');
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    Swal.close(); // Close loader
                    console.error("AJAX error:", textStatus, errorThrown);
                    showDialogBox('Error', "An error occurred while processing your request. Please try again.", 'error');
                }
            });
        });
    });
</script>
</body>
</html>
