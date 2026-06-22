package builderpatternexample;

public class BuilderPatternTest {
    public static void main(String[] args) {
        Computer gamingPc = new Computer.Builder()
                .setCpu("Intel Core i9")
                .setRam(32)
                .setStorage(2000)
                .setGraphicsCard("NVIDIA RTX 4090")
                .setHasWifi(true)
                .build();

        Computer officePc = new Computer.Builder()
                .setCpu("Intel Core i5")
                .setRam(16)
                .setStorage(512)
                .setGraphicsCard("Integrated")
                .setHasWifi(true)
                .build();

        System.out.println("Gaming PC: " + gamingPc);
        System.out.println("Office PC: " + officePc);
    }
}
