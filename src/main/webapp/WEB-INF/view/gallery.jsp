<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Gallery");
%>
<%@include file="/WEB-INF/common/header.jsp" %>

<main>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Food Gallery</h1>
        <div class="gallery-container">
            <!-- Hardcoded image paths -->
            <div class="gallery-item">
                <img src="/assets/images/food-1.jpg" alt="Food Image 1">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-2.jpg" alt="Food Image 2">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-3.jpg" alt="Food Image 3">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-4.jpg" alt="Food Image 4">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-5.jpg" alt="Food Image 5">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-6.jpg" alt="Food Image 6">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-7.jpg" alt="Food Image 7">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-8.jpg" alt="Food Image 8">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-9.jpg" alt="Food Image 9">
            </div>
            <div class="gallery-item">
                <img src="/assets/images/food-10.jpg" alt="Food Image 10">
            </div>
        </div>
    </div>
</main>

<%@include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>