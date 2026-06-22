package dependencyinjectionexample;

public class CustomerService {
    private final CustomerRepository repository;

    public CustomerService(CustomerRepository repository) {
        this.repository = repository;
    }

    public void showCustomer(String id) {
        String customer = repository.findCustomerById(id);
        System.out.println("Found customer: " + customer);
    }
}
