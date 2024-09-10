// index.js

class Cart {
    constructor() {
        this.items = JSON.parse(localStorage.getItem('cart')) || [];
    }

    addItem(foodId, name, price, quantity) {
        const existingItem = this.items.find(item => item.foodId === foodId);
        if (existingItem) {
            existingItem.quantity += quantity;
        } else {
            this.items.push({ foodId, name, price, quantity });
        }
        this.saveCart();
    }

    removeItem(foodId) {
        this.items = this.items.filter(item => item.foodId !== foodId);
        this.saveCart();
    }

    updateQuantity(foodId, quantity) {
        const item = this.items.find(item => item.foodId === foodId);
        if (item) {
            item.quantity = quantity;
            this.saveCart();
        }
    }

    getItems() {
        return this.items;
    }

    clearCart() {
        this.items = [];
        this.saveCart();
    }

    saveCart() {
        localStorage.setItem('cart', JSON.stringify(this.items));
    }

    getTotalPrice() {
        return this.items.reduce((total, item) => total + item.price * item.quantity, 0);
    }

    getTotalItems() {
        return this.items.reduce((total, item) => total + item.quantity, 0);
    }
}

// Create a global cart instance
window.cart = new Cart();

// Global functions for cart operations
window.updateCartDisplay = function() {
    const cartItemCount = window.cart.getTotalItems();
    $('#cartItemCount').text(cartItemCount);
    updateCartModal();
}

window.updateCartModal = function() {
    const cartItems = window.cart.getItems();
    const cartItemsElement = document.getElementById('cartItems');
    const cartTotalElement = document.getElementById('cartTotal');

    cartItemsElement.innerHTML = '';

    if (cartItems.length === 0) {
        cartItemsElement.innerHTML = '<p>Your cart is empty.</p>';
    } else {
        cartItems.forEach(item => {
            const itemElement = document.createElement('div');
            itemElement.className = 'cart-item mb-2';
            itemElement.innerHTML = `
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 bg-dark-gray rounded">
    <span class="text-light">${item.name} - <span class="text-amber">$${item.price.toFixed(2)}</span> x ${item.quantity}</span>
    <div>
        <button class="btn btn-sm btn-outline-amber me-2" onclick="updateQuantity(${item.foodId}, ${item.quantity - 1})">-</button>
        <button class="btn btn-sm btn-outline-amber me-2" onclick="updateQuantity(${item.foodId}, ${item.quantity + 1})">+</button>
        <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(${item.foodId})">Remove</button>
    </div>
</div>
            `;
            cartItemsElement.appendChild(itemElement);
        });
    }

    cartTotalElement.textContent = window.cart.getTotalPrice().toFixed(2);
}

window.updateQuantity = function(foodId, newQuantity) {
    if (newQuantity > 0) {
        window.cart.updateQuantity(foodId, newQuantity);
    } else {
        window.cart.removeItem(foodId);
    }
    updateCartDisplay();
}

window.removeFromCart = function(foodId) {
    window.cart.removeItem(foodId);
    updateCartDisplay();
}

window.confirmOrder = function() {
    window.location.href = '/order/confirm';
}

window.clearCart = function() {
    window.cart.clearCart();
    updateCartDisplay();
}

// Initialize cart display when the DOM is ready
$(document).ready(function() {
    updateCartDisplay();

    // Event listener for cart modal show
    $('#cartModal').on('show.bs.modal', function (event) {
        updateCartModal();
    });
});

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