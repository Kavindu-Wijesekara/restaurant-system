<!-- Cart Modal -->
<div class="modal fade" id="cartModal" tabindex="-1" aria-labelledby="cartModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cartModalLabel">Your Cart</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="cartItems"></div>
        <div class="text-end mt-3">
          <h5>Total: $<span id="cartTotal">0.00</span></h5>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="confirmOrder()">Confirm Order</button>
      </div>
    </div>
  </div>
</div>

<footer class="bg-light py-4 mt-5">
  <div class="container text-center">
    <p class="mb-0">&copy; 2024 ABC Restaurant. All Rights Reserved.</p>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
