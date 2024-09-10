<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("pageTitle", "Reservations");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main class="reservation-page bg-dark text-light py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="reservation-form bg-dark-gray p-4 rounded shadow-lg">
                    <h2 class="text-center mb-4 header-title text-amber">Make Your Reservation</h2>
                    <form id="reservationForm">
                        <div class="form-group mb-3">
                            <label for="customer_name" class="form-label"><i class="fas fa-user text-amber"></i> Name</label>
                            <input type="text" class="form-control bg-input text-light border-0" id="customer_name" name="customer_name" placeholder="Enter your name" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="customer_email" class="form-label"><i class="fas fa-envelope text-amber"></i> Email</label>
                            <input type="email" class="form-control bg-input text-light border-0" id="customer_email" name="customer_email" placeholder="Enter your email" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="customer_phone" class="form-label"><i class="fas fa-phone text-amber"></i> Phone</label>
                            <input type="tel" class="form-control bg-input text-light border-0" id="customer_phone" name="customer_phone" placeholder="Enter your phone number" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label for="reservation_date" class="form-label"><i class="fas fa-calendar-alt text-amber"></i> Date</label>
                                <input type="date" class="form-control bg-input text-light border-0" id="reservation_date" name="reservation_date" required>
                            </div>
                            <div class="col-md-6">
                                <label for="reservation_time" class="form-label"><i class="fas fa-clock text-amber"></i> Time</label>
                                <input type="time" class="form-control bg-input text-light border-0" id="reservation_time" name="reservation_time" required>
                            </div>
                        </div>
                        <div class="form-group mb-3">
                            <label for="number_of_people" class="form-label"><i class="fas fa-users text-amber"></i> Number of People</label>
                            <input type="number" class="form-control bg-input text-light border-0" id="number_of_people" name="number_of_people" min="1" placeholder="Enter number of people" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="branch" class="form-label"><i class="fas fa-building text-amber"></i> Branch</label>
                            <select class="form-select bg-input text-light border-0" id="branch" name="branch" required>
                                <option value="" disabled hidden selected>Select a branch</option>
                                <!-- Branches will be populated here by JavaScript -->
                            </select>
                        </div>
                        <div class="form-group mb-4">
                            <label for="special_request" class="form-label"><i class="fas fa-sticky-note text-amber"></i> Special Requests</label>
                            <textarea class="form-control bg-input text-light border-0" id="special_request" name="special_request" rows="3" placeholder="Enter any special requests"></textarea>
                        </div>
                        <button type="submit" class="btn btn-amber btn-lg w-100 submit-btn">Submit Reservation</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<%@include file="/WEB-INF/common/footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const branches = <%= new Gson().toJson(request.getAttribute("branches")) %>;

        console.log(branches);

        // Populate the branch dropdown
        const branchSelect = document.getElementById('branch');

        branches.forEach(branch => {
            const option = document.createElement('option');
            option.value = branch.branchId;
            option.text = branch.branchName;
            branchSelect.add(option);
        });

        document.getElementById('reservation_date').addEventListener('input', function() {
            const today = new Date();
            const currentTime = today.getHours();
            const selectedDate = new Date(this.value);

            const formattedTodayDate = today.toISOString().split('T')[0];
            const formattedSelectedDate = selectedDate.toISOString().split('T')[0];

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
            const branch = document.getElementById("branch").value.trim();

            const [hours, minutes] = reservationTime.split(':').map(Number);
            const reservationHours = hours + minutes / 60;

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
            } else if (reservationDate === "" || reservationTime === "") {
                showDialogBox("Operation Failed.", "Date and Time are required", "error");
                return false;
            } else if (numberOfPeople <= 0) {
                showDialogBox("Operation Failed.", "Number of People must be greater than 0", "error");
                return false;
            } else if (isPastDate) {
                showDialogBox("Operation Failed.", "Reservation cannot be made for a past date", "error");
                return false;
            } else if (reservationHours >= 22 || reservationHours < 10) {
                showDialogBox("Operation Failed.", "Reservations are not allowed between 10 PM and 10 AM.", "error");
                return false;
            } else if (!branch) {
                showDialogBox("Operation Failed.", "Branch selection is required", "error");
                return false;
            } else {
                showLoader();
                return true;
            }
        }

        $('#reservationForm').on('submit', function(e) {
            e.preventDefault(); // Prevent form from submitting normally

            showLoader();

            if (!validateReservationForm()) {
                return; // If validation fails, stop the form submission
            }

            $.ajax({
                type: 'POST',
                url: '<%= request.getContextPath() %>/reservations',
                data: $(this).serialize(), // Serialize form data including branch selection
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
                        });
                        $('#reservationForm').trigger('reset');
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
