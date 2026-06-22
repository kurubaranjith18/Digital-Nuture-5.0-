package module2;

public class FinancialForecast {
    public static double futureValue(double currentValue, double growthRate, int years) {
        if (years == 0) {
            return currentValue;
        }
        return futureValue(currentValue * (1 + growthRate), growthRate, years - 1);
    }
}
