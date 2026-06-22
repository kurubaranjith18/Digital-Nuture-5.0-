package adapterpatternexample;

public class AdapterPatternTest {
    public static void main(String[] args) {
        PaymentProcessor payPalProcessor = new PayPalAdapter(new PayPalGateway());
        PaymentProcessor stripeProcessor = new StripeAdapter(new StripeGateway());

        payPalProcessor.processPayment(150.0);
        stripeProcessor.processPayment(120.0);
    }
}
