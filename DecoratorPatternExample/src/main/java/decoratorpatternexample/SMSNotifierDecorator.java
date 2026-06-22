package decoratorpatternexample;

public class SMSNotifierDecorator extends NotifierDecorator {
    public SMSNotifierDecorator(Notifier notifier) {
        super(notifier);
    }

    @Override
    public void send(String message) {
        super.send(message);
        sendSms(message);
    }

    private void sendSms(String message) {
        System.out.println("Sending SMS notification: " + message);
    }
}
