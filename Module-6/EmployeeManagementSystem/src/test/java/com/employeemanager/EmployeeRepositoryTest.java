package com.employeemanager;

import com.employeemanager.model.Employee;
import com.employeemanager.repository.EmployeeRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class EmployeeRepositoryTest {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Test
    void shouldSaveAndFindByDepartment() {
        employeeRepository.save(new Employee("Alice", "Johnson", "alice@example.com", "Engineering"));
        employeeRepository.save(new Employee("Bob", "Smith", "bob@example.com", "HR"));

        List<Employee> engineeringEmployees = employeeRepository.findByDepartment("Engineering");

        assertThat(engineeringEmployees).hasSize(1);
        assertThat(engineeringEmployees.get(0).getFirstName()).isEqualTo("Alice");
    }
}
