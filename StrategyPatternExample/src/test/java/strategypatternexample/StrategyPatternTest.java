package strategypatternexample;

public class StrategyPatternTest {
    public static void main(String[] args) {
        PaymentContext context = new PaymentContext();

        context.setPaymentStrategy(new CreditCardPayment());
        context.pay(250.00);

        context.setPaymentStrategy(new PayPalPayment());
        context.pay(124.99);
    }
}
