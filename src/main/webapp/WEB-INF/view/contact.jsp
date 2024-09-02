<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Contact Us");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main>
    <div class="container">
        <div class="contact-container">
            <h2>Contact Us</h2>
            <form id="contactForm" action="submitContactForm" method="post">
                <!-- Name Field -->
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Enter your name" required>
                </div>
                <!-- Email Field -->
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                </div>
                <!-- Phone Field -->
                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="Enter your phone number" required>
                </div>
                <!-- Subject Field -->
                <div class="form-group">
                    <label for="subject">Subject:</label>
                    <input type="text" class="form-control" id="subject" name="subject" placeholder="Enter the subject" required>
                </div>
                <!-- Message Field -->
                <div class="form-group">
                    <label for="message">Message:</label>
                    <textarea class="form-control" id="message" name="message" rows="5" placeholder="Enter your message" required></textarea>
                </div>
                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary btn-block">Submit</button>
            </form>
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