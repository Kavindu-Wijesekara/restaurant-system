package com.abc.rest.services;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class StripeService {

    private static final String STRIPE_SECRET_KEY = "sk_test_51PuZGXAUgatpOVNrXKLcE3FhpGFLwTj6zrB4a0g2cJXWnzNodp3ogaiJ836iaEWFgiaGgFfCqFxQTZboOy3eYtv90043PocAyL";

    public StripeService() {
        Stripe.apiKey = STRIPE_SECRET_KEY;
    }

    public String createPaymentIntent(BigDecimal amount, int orderId) throws StripeException {
        // Convert to cents and round to ensure we have a whole number
        long amountInCents = amount.multiply(new BigDecimal("100")).setScale(0, RoundingMode.HALF_UP).longValue();

        // Ensure the amount is at least 50 cents
        if (amountInCents < 50) {
            throw new IllegalArgumentException("Amount must be at least 50 cents");
        }

        PaymentIntentCreateParams params =
                PaymentIntentCreateParams.builder()
                        .setAmount(amountInCents)
                        .setCurrency("usd")
                        .putMetadata("orderId", String.valueOf(orderId))
                        .build();

        PaymentIntent paymentIntent = PaymentIntent.create(params);
        return paymentIntent.getClientSecret();
    }
}
