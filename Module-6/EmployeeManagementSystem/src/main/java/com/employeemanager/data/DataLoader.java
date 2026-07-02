package com.employeemanager.data;

import com.employeemanager.model.Employee;
import com.employeemanager.repository.EmployeeRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner loadEmployees(EmployeeRepository employeeRepository) {
        return args -> {
            employeeRepository.save(new Employee("Alice", "Johnson", "alice@example.com", "Engineering"));
            employeeRepository.save(new Employee("Bob", "Smith", "bob@example.com", "HR"));
            employeeRepository.save(new Employee("Charlie", "Brown", "charlie@example.com", "Engineering"));
            employeeRepository.save(new Employee("Diana", "Miller", "diana@example.com", "Finance"));
        };
    }
}
