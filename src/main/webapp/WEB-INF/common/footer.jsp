<!-- Cart Modal -->
<div class="modal fade" id="cartModal" tabindex="-1" aria-labelledby="cartModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content bg-dark text-light">
      <div class="modal-header border-amber">
        <h5 class="modal-title text-amber" id="cartModalLabel">Your Cart</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="cartItems"></div>
        <div class="text-end mt-3">
          <h5 class="text-amber">Total: $<span id="cartTotal">0.00</span></h5>
        </div>
      </div>
      <div class="modal-footer border-amber">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-amber" onclick="confirmOrder()">Confirm Order</button>
      </div>
    </div>
  </div>
</div>

<footer class="bg-light py-4">
  <div class="container text-center">
    <p class="mb-0">&copy; 2024 ABC Restaurant. All Rights Reserved.</p>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/index.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>