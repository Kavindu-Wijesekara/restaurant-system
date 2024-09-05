<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Restaurant - Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <h2>Customer Sign-Up</h2>
    <form method="POST" name="register-form" id="register-form" onsubmit="return validateForm()">
        <div class="mb-3">
            <label for="full_name" class="form-label">First Name</label>
            <input type="text" class="form-control" id="full_name" name="full_name" required>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" class="form-control" id="phone" name="phone" required>
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm Password</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
        </div>
        <input type="hidden" name="role" value="customer">
        <button type="submit" class="btn btn-primary">Sign Up</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function validateForm() {
        const emailRegex = /^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/;
        const phonePattern = /[^0-9+]/g;
        const full_name = document.forms["register-form"]["full_name"].value.trim();
        const email = document.forms["register-form"]["email"].value.trim();
        const phoneNumber = document.forms["register-form"]["phone"].value.trim();
        const password = document.forms["register-form"]["password"].value;
        const confirmPassword = document.forms["register-form"]["confirmPassword"].value;

        if(full_name.length > 30 || full_name === ""){
            showDialogBox("Operation Failed.", "Invalid First Name", "error");
            return false;
        } else if(!emailRegex.test(email)){
            showDialogBox("Operation Failed.", "Invalid E-mail", "error");
            return false;
        } else if(phoneNumber.length > 15 || phoneNumber.length < 6 || phonePattern.test(phoneNumber)){
            showDialogBox("Operation Failed.", "Invalid Phone Number", "error");
            return false;
        } else if (!(password.length >= 6 && password.length <= 24)){
            showDialogBox("Operation Failed.", "Password length must be between 6 and 24 characters.", "error");
            return false;
        } else if(!password.match(/[A-Z]/) || !password.match(/\d/)){
            showDialogBox("Operation Failed.", "Password does not meet the criteria: Must contain at least one uppercase letter and one number.", "error");
            return false;
        } else if(password !== confirmPassword){
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

        setTimeout(() => {
            Swal.close();
        }, 10000);
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
        $('#register-form').on('submit', function(e) {
            e.preventDefault(); // Prevent form from submitting normally

            $.ajax({
                type: 'POST',
                url: '<%= request.getContextPath() %>/auth?action-type=register',
                data: $(this).serialize(), // Serialize form data
                dataType: 'json',
                success: function(response) {
                    if(response.success) {
                        Swal.fire({
                            title: 'Success',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then(() => {
                            window.location.href = response.redirectUrl;
                        });

                        // Timeout to automatically redirect
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
