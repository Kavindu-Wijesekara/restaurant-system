// order-confirmation.js

function initializeOrderConfirmation() {
    const cartItems = window.cart.getItems();
    const summaryElement = $('#orderSummary');
    const totalElement = $('#orderTotal');

    function displayCartItems() {
        summaryElement.empty();
        if (cartItems && cartItems.length > 0) {
            cartItems.forEach(function(item) {
                var itemTotal = (item.price * item.quantity).toFixed(2);
                summaryElement.append(
                    '<div class="d-flex justify-content-between mb-2">' +
                    '<span>' + item.name + ' x ' + item.quantity + '</span>' +
                    '<span>$' + itemTotal + '</span>' +
                    '</div>'
                );
            });
            totalElement.text(window.cart.getTotalPrice().toFixed(2));
        } else {
            summaryElement.append('<p>No items in cart</p>');
            totalElement.text('0.00');
        }
    }

    displayCartItems();

    $('#deliveryMethod').change(function() {
        if ($(this).val() === 'Delivery') {
            $('#deliveryAddressGroup').show();
            $('#address').prop('required', true);
        } else {
            $('#deliveryAddressGroup').hide();
            $('#address').prop('required', false);
        }
    });

    $('#deliveryMethod').trigger('change');

    $('#orderForm').submit(function(e) {
        e.preventDefault();
        submitOrder();
    });
}

function submitOrder() {
    const orderData = {
        userId: window.userId,
        deliveryMethod: $('#deliveryMethod').val(),
        branch_id: $('#branch_id').val(),
        address: $('#address').val(),
        contactNumber: $('#contactNumber').val(),
        orderItems: window.cart.getItems().map(item => ({
            menuItemId: item.foodId,
            quantity: item.quantity,
            price: item.price,
            name: item.name
        }))
    };

    console.log('Submitting order data:', orderData);

    $.ajax({
        url: '/order/submit',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(orderData),
        success: function(response) {
            console.log('Order submission response:', response);
            if (response.success) {
                $('#orderForm').hide();
                window.clearCart();
                initializeStripePayment(response.clientSecret, response.orderId);
            } else {
                showDialogBox('Error', response.message, 'error');
            }
        },
        error: function(xhr, status, error) {
            console.error('Order submission error:', error);
            console.error('Response:', xhr.responseText);
            showDialogBox('Error', 'There was an error submitting your order. Please try again.', 'error');
        }
    });
}

function initializeStripePayment(clientSecret, orderId) {
    console.log('Initializing Stripe payment. Client Secret:', clientSecret, 'Order ID:', orderId);

    if (!clientSecret || !orderId) {
        console.error('Missing client secret or order ID');
        $('#error-message').text('Unable to initialize payment. Please try again.');
        return;
    }

    try {
        const stripe = Stripe('pk_test_51PuZGXAUgatpOVNrsZhn2yQkZlI1qxPavxf5SwkzrH5g1xDo7GJlVtkuelAriy6oMJcvGgJNsKJinusH0xq6h8hr00ZqOuYFRi');

        const appearance = {
            theme: 'stripe'
        };

        const elements = stripe.elements({ clientSecret, appearance });
        const paymentElement = elements.create('payment');

        $('#payment-form').show();

        setTimeout(() => {
            paymentElement.mount('#payment-element');
            console.log('Payment element mounted successfully');
        }, 100);

        $('#payment-form').off('submit').on('submit', async function (event) {
            event.preventDefault();
            console.log('Confirming payment for Order ID:', orderId);

            try {
                const { error } = await stripe.confirmPayment({
                    elements,
                    confirmParams: {
                        return_url: `http://localhost:8080/order/confirmation?id=${encodeURIComponent(orderId)}`,
                    },
                });

                if (error) {
                    console.error('Stripe payment error:', error);
                    $('#error-message').text(error.message);
                } else {
                    console.log('Payment successful');
                }
            } catch (stripeError) {
                console.error('Error in stripe.confirmPayment:', stripeError);
                $('#error-message').text('An unexpected error occurred. Please try again.');
            }
        });
    } catch (initError) {
        console.error('Error initializing Stripe:', initError);
        $('#error-message').text('Unable to initialize payment system. Please try again later.');
    }
}

// Initialize when the document is ready
$(document).ready(initializeOrderConfirmation);