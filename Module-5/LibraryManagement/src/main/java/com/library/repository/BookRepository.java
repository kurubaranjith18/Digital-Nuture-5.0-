package com.library.repository;

import java.util.Arrays;
import java.util.List;

public class BookRepository {

    public List<String> findAllBooks() {
        return Arrays.asList("The Hobbit", "1984", "Clean Code");
    }

    public String findBookByTitle(String title) {
        return "Book found: " + title;
    }
}
