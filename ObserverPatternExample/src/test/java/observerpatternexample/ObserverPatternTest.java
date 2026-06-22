package observerpatternexample;

public class ObserverPatternTest {
    public static void main(String[] args) {
        StockMarket stockMarket = new StockMarket();
        Observer mobileApp = new MobileApp();
        Observer webApp = new WebApp();

        stockMarket.registerObserver(mobileApp);
        stockMarket.registerObserver(webApp);

        stockMarket.setStockPrice("AAPL", 173.45);
        stockMarket.setStockPrice("GOOGL", 2987.12);

        stockMarket.removeObserver(webApp);
        stockMarket.setStockPrice("MSFT", 322.10);
    }
}
