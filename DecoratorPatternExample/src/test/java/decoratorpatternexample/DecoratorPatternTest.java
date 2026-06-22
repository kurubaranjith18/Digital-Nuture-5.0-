package decoratorpatternexample;

public class DecoratorPatternTest {
    public static void main(String[] args) {
        Notifier emailNotifier = new EmailNotifier();
        Notifier smsAndEmailNotifier = new SMSNotifierDecorator(emailNotifier);
        Notifier fullNotifier = new SlackNotifierDecorator(smsAndEmailNotifier);

        System.out.println("Email only:");
        emailNotifier.send("New user signup.");

        System.out.println("Email + SMS:");
        smsAndEmailNotifier.send("New order received.");

        System.out.println("Email + SMS + Slack:");
        fullNotifier.send("System alert triggered.");
    }
}
