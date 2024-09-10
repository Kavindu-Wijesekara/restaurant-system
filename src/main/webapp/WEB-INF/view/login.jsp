<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Restaurant - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            background-color: #121212;
            background-image: url('/assets/images/food-8.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            height: 100vh;
            color: #e0e0e0;
        }
        .container {
            height: 100%;
            display: flex;
            align-items: center;
        }
        .card {
            background-color: rgba(33, 33, 33, 0.9);
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }
        .card-header {
            background-color: #ffc107;
            color: #121212;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
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
        a {
            color: #ffc107;
        }
        a:hover {
            color: #ffca2c;
        }
        .form-control {
            border-color: #444;
            color: #e0e0e0;
        }
        .form-control:focus {
            background-color: #444;
            border-color: #ffc107;
            color: #fff;
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.25);
        }
        .form-label {
            color: #e0e0e0;
        }
    </style>
</head>
<body>

<!-- Login Form -->
<div class="container">
    <div class="row justify-content-center w-100">
        <div class="col-md-6 col-lg-4">
            <div class="card">
                <div class="card-header text-center py-3">
                    <h3 class="mb-0">Welcome Back!</h3>
                </div>
                <div class="card-body p-4">
                    <form id="login-form" onsubmit="showLoader()" method="POST">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg" id="loginButton">Login</button>
                        </div>
                    </form>
                    <div class="text-center mt-4">
                        <a href="auth?action-type=register" class="text-decoration-none">Don't have an account? Sign Up</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function showDialogBox(title, message, icon) {
        Swal.fire({
            title: title,
            text: message,
            icon: icon,
            confirmButtonText: 'Close'
        })
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

        setTimeout(() => {
            Swal.close();
        }, 10000);
    }

    $(document).ready(function() {
        $('#login-form').on('submit', function(e) {
            e.preventDefault(); // Prevent form from submitting normally

            $.ajax({
                type: 'POST',
                url: '<%= request.getContextPath() %>/auth?action-type=login',
                data: $(this).serialize(), // Serialize form data
                dataType: 'json',
                success: function(response) {
                    showDialogBox('Success', response.message, 'success');
                    if(response.success) {
                        Swal.fire({
                            title: 'Success',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then(() => {
                            window.location.href = response.redirectUrl;
                        });

                        // Optionally, you can set a timeout to automatically redirect
                        setTimeout(() => {
                            window.location.href = response.redirectUrl;
                        }, 5000); // Redirect after 5 seconds
                    } else {
                        showDialogBox('Error', response.message, 'error');
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("AJAX error:", textStatus, errorThrown);
                    showDialogBox('Error', "An error occurred while processing your request. Please try again.", 'error');
                }
            });
        });
    });
</script>
</body>
</html>
