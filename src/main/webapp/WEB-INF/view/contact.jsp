<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Contact Us");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main class="contact-page bg-dark text-light py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="contact-container bg-darker-gray p-4 rounded-lg shadow-lg">
                    <h2 class="text-amber text-center mb-4">Contact Us</h2>
                    <form id="contactForm" action="submitContactForm" method="post">
                        <div class="row">
                            <!-- Name Field -->
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="name" class="form-label text-light">Name:</label>
                                    <input type="text" class="form-control bg-dark-gray text-light border-0" id="name" name="name" placeholder="Enter your name" required>
                                </div>
                            </div>
                            <!-- Email Field -->
                            <div class="col-md-6 mb-3">
                                <div class="form-group">
                                    <label for="email" class="form-label text-light">Email:</label>
                                    <input type="email" class="form-control bg-dark-gray text-light border-0" id="email" name="email" placeholder="Enter your email" required>
                                </div>
                            </div>
                        </div>
                        <!-- Phone Field -->
                        <div class="form-group mb-3">
                            <label for="phone" class="form-label text-light">Phone:</label>
                            <input type="text" class="form-control bg-dark-gray text-light border-0" id="phone" name="phone" placeholder="Enter your phone number" required>
                        </div>
                        <!-- Subject Field -->
                        <div class="form-group mb-3">
                            <label for="subject" class="form-label text-light">Subject:</label>
                            <input type="text" class="form-control bg-dark-gray text-light border-0" id="subject" name="subject" placeholder="Enter the subject" required>
                        </div>
                        <!-- Message Field -->
                        <div class="form-group mb-4">
                            <label for="message" class="form-label text-light">Message:</label>
                            <textarea class="form-control bg-dark-gray text-light border-0" id="message" name="message" rows="5" placeholder="Enter your message" required></textarea>
                        </div>
                        <!-- Submit Button -->
                        <div class="text-center">
                            <button type="submit" class="btn btn-amber btn-lg px-5">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>


<%@include file="/WEB-INF/common/footer.jsp" %>
<script>
    $(document).ready(function () {
        $('#contactForm').on('submit', function (e) {
            var name = $('#name').val().trim();
            var email = $('#email').val().trim();
            var phone = $('#phone').val().trim();
            var subject = $('#subject').val().trim();
            var message = $('#message').val().trim();

            if (name === '' || email === '' || phone === '' || subject === '' || message === '') {
                alert('Please fill in all fields.');
                e.preventDefault();
            }
            // Further client-side validation can be added here
        });
    });
</script>
</body>
</html>