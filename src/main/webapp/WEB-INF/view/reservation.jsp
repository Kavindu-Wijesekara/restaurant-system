<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Reservations");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="reservation-form p-4">
                    <h2 class="text-center mb-4 header-title">Make Your Reservation</h2>
                    <form id="reservationForm">
                        <div class="form-group">
                            <label for="customer_name"><i class="fas fa-user"></i> Name</label>
                            <input type="text" class="form-control" id="customer_name" name="customer_name" placeholder="Enter your name" required>
                        </div>
                        <div class="form-group">
                            <label for="customer_email"><i class="fas fa-envelope"></i> Email</label>
                            <input type="email" class="form-control" id="customer_email" name="customer_email" placeholder="Enter your email" required>
                        </div>
                        <div class="form-group">
                            <label for="customer_phone"><i class="fas fa-phone"></i> Phone</label>
                            <input type="tel" class="form-control" id="customer_phone" name="customer_phone" placeholder="Enter your phone number" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="reservation_date"><i class="fas fa-calendar-alt"></i> Date</label>
                                <input type="date" class="form-control" id="reservation_date" name="reservation_date" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="reservation_time"><i class="fas fa-clock"></i> Time</label>
                                <input type="time" class="form-control" id="reservation_time" name="reservation_time" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="number_of_people"><i class="fas fa-users"></i> Number of People</label>
                            <input type="number" class="form-control" id="number_of_people" name="number_of_people" min="1" placeholder="Enter number of people" required>
                        </div>
                        <div class="form-group">
                            <label for="special_request"><i class="fas fa-sticky-note"></i> Special Requests</label>
                            <textarea class="form-control" id="special_request" name="special_request" rows="3" placeholder="Enter any special requests"></textarea>
                        </div>
                        <button type="submit" class="btn btn-block submit-btn text-white mt-4">Submit Reservation</button>
                    </form>

                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<%@include file="/WEB-INF/common/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.getElementById('reservation_date').addEventListener('input', function() {
        const today = new Date();
        const currentTime = today.getHours();
        const selectedDate = new Date(this.value);

        // Format today's date to YYYY-MM-DD
        const formattedTodayDate = today.toISOString().split('T')[0];
        const formattedSelectedDate = selectedDate.toISOString().split('T')[0];

        // Disable today if current time is past 10 PM
        if (currentTime >= 22) {
            if (formattedSelectedDate === formattedTodayDate) {
                alert('You cannot select today\'s date as it is past 10 PM.');
                this.value = '';
            }
        } else if (formattedSelectedDate < formattedTodayDate) {
            alert('You cannot select a past date.');
            this.value = '';
        }
    });

    function validateReservationForm() {
        const emailRegex = /^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/;
        const phonePattern = /[^0-9+]/g;
        const name = document.getElementById("customer_name").value.trim();
        const email = document.getElementById("customer_email").value.trim();
        const phone = document.getElementById("customer_phone").value.trim();
        const reservationDate = document.getElementById("reservation_date").value.trim();
        const reservationTime = document.getElementById("reservation_time").value.trim();
        const numberOfPeople = document.getElementById("number_of_people").value.trim();

        // Convert reservationTime to hours for validation
        const [hours, minutes] = reservationTime.split(':').map(Number);
        const reservationHours = hours + minutes / 60;

        // Get current date and time
        const now = new Date();

        const isPastDate = new Date(reservationDate) < now.setHours(0, 0, 0, 0);

        if (name.length > 100 || name === "") {
            showDialogBox("Operation Failed.", "Invalid Name", "error");
            return false;
        } else if (!emailRegex.test(email)) {
            showDialogBox("Operation Failed.", "Invalid Email", "error");
            return false;
        } else if (phone.length > 15 || phone.length < 6 || phonePattern.test(phone)) {
            showDialogBox("Operation Failed.", "Invalid Phone Number", "error");
            return false;
        }  else if (reservationDate === "" || reservationTime === "") {
            showDialogBox("Operation Failed.", "Date and Time are required", "error");
            return false;
        } else if (numberOfPeople <= 0) {
            showDialogBox("Operation Failed.", "Number of People must be greater than 0", "error");
            return false;
        } else if (isPastDate) {
            showDialogBox("Operation Failed.", "Reservation cannot be made for a past date", "error");
            return false;
        }  else if (reservationHours >= 22 || reservationHours < 10) {
            showDialogBox("Operation Failed.", "Reservations are not allowed between 10 PM and 10 AM.", "error");
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
        $('#reservationForm').on('submit', function(e) {
            e.preventDefault(); // Prevent form from submitting normally

            showLoader()

            if (!validateReservationForm()) {
                return; // If validation fails, stop the form submission
            }

            $.ajax({
                type: 'POST',
                url: '<%= request.getContextPath() %>/reservations',
                data: $(this).serialize(), // Serialize form data
                dataType: 'json',
                success: function(response) {
                    console.log(response);
                    showDialogBox('Success', response.message, 'success');
                    if (response.success) {
                        Swal.fire({
                            title: 'Success',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        })
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
