package adapterpatternexample;

public class StripeGateway {
    public void makePayment(double amountInCents) {
        System.out.println("Processing Stripe payment of $" + (amountInCents / 100));
    }
}
