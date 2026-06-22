package adapterpatternexample;

public class PayPalGateway {
    public void sendPayment(double amount) {
        System.out.println("Processing PayPal payment of $" + amount);
    }
}
