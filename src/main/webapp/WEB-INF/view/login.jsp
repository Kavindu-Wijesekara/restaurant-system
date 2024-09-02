<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Restaurant - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<!-- Login Form -->
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header text-center">
                    <h3>Login</h3>
                </div>
                <div class="card-body">
                    <form id="login-form" onsubmit="showLoader()" method="POST">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email">
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password">
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary" id="loginButton">Login</button>
                        </div>
                    </form>
                    <div class="text-center mt-3">
                        <a href="auth?action-type=register">Don't have an account? Sign Up</a>
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
