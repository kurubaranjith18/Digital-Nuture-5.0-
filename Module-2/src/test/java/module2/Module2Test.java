package module2;

public class Module2Test {
    public static void main(String[] args) {
        // Inventory management
        InventoryManager inventoryManager = new InventoryManager();
        Product product = new Product("P001", "Keyboard", 10, 45.99);
        inventoryManager.addProduct(product);
        inventoryManager.updateProduct("P001", 12, 42.99);
        inventoryManager.deleteProduct("P001");

        // Search example
        Product[] products = {
                new Product("P002", "Monitor", 5, 199.99),
                new Product("P003", "Mouse", 20, 19.99),
                new Product("P004", "Laptop", 3, 999.99)
        };
        System.out.println("Linear search result: " + ProductSearch.linearSearch(products, "Mouse"));
        System.out.println("Binary search result: " + ProductSearch.binarySearch(new Product[]{
                new Product("P003", "Mouse", 20, 19.99),
                new Product("P002", "Monitor", 5, 199.99),
                new Product("P004", "Laptop", 3, 999.99)
        }, "Monitor"));

        // Order sorting
        Order[] orders = {
                new Order("O001", "Alice", 120.50),
                new Order("O002", "Bob", 580.20),
                new Order("O003", "Carol", 230.75)
        };
        OrderSorter.bubbleSort(orders);
        OrderSorter.quickSort(orders);

        // Employee array
        EmployeeManager employeeManager = new EmployeeManager(5);
        employeeManager.addEmployee(new Employee("E001", "John", "Developer", 55000));
        employeeManager.traverseEmployees();

        // Task linked list
        TaskList taskList = new TaskList();
        taskList.addTask(new Task("T001", "Design", "Open"));
        taskList.traverseTasks();

        // Library search
        Book[] books = {
                new Book("B001", "Algorithms", "Author A"),
                new Book("B002", "Data Structures", "Author B")
        };
        System.out.println("Library linear search: " + LibrarySearch.linearSearch(books, "Algorithms"));

        // Financial forecast
        System.out.println("Future value: " + FinancialForecast.futureValue(1000, 0.05, 3));
    }
}
