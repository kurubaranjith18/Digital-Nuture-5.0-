package mvcpatternexample;

public class StudentView {
    public void displayStudentDetails(String name, String id, String grade) {
        System.out.println("Student: ");
        System.out.println("Name: " + name);
        System.out.println("ID: " + id);
        System.out.println("Grade: " + grade);
    }
}
