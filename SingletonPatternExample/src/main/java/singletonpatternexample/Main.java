package singletonpatternexample;

public class Main {
    public static void main(String[] args) {
        Logger logger = Logger.getInstance();
        logger.log("Singleton logger initialized.");
    }
}
