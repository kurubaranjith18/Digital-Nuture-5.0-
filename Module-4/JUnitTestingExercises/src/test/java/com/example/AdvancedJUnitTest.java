package com.example;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.assertThrows;

public class AdvancedJUnitTest {
    @Rule
    public ExpectedException thrown = ExpectedException.none();

    @Test
    public void testExceptionThrower() {
        ExceptionThrower thrower = new ExceptionThrower();
        thrown.expect(IllegalArgumentException.class);
        thrown.expectMessage("Exception thrown");
        thrower.throwException();
    }

    @Test(timeout = 200)
    public void testPerformance() {
        new PerformanceTester().performTask();
    }
}
