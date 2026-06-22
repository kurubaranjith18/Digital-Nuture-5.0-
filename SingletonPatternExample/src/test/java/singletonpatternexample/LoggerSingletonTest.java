package singletonpatternexample;

public class LoggerSingletonTest {
    public static void main(String[] args) {
        Logger logger1 = Logger.getInstance();
        Logger logger2 = Logger.getInstance();

        System.out.println("logger1 == logger2: " + (logger1 == logger2));

        if (logger1 == logger2) {
            System.out.println("Singleton pattern works: only one Logger instance exists.");
        } else {
            System.out.println("Singleton pattern failed: multiple Logger instances exist.");
        }
    }
}
