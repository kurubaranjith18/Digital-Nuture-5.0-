package proxypatternexample;

public class ProxyPatternTest {
    public static void main(String[] args) {
        Image image1 = new ProxyImage("photo1.jpg");
        Image image2 = new ProxyImage("photo2.jpg");

        System.out.println("First display of photo1:");
        image1.display();

        System.out.println("Second display of photo1:");
        image1.display();

        System.out.println("Display of photo2:");
        image2.display();
    }
}
