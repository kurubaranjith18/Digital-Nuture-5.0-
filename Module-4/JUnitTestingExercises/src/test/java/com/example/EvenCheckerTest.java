package com.example;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class EvenCheckerTest {
    private final int input;
    private final boolean expected;

    public EvenCheckerTest(int input, boolean expected) {
        this.input = input;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: isEven({0})={1}")
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][] {
                {2, true},
                {3, false},
                {4, true},
                {7, false}
        });
    }

    @Test
    public void testIsEven() {
        EvenChecker checker = new EvenChecker();
        assertEquals(expected, checker.isEven(input));
    }
}
