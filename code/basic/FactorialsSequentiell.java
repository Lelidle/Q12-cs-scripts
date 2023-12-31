package code.basic;

import java.math.BigInteger;

public class FactorialsSequentiell {

    public static void main(String[] args) {
        long startTime = System.nanoTime();
        calculateFactorials();
        long endTime = System.nanoTime();
        System.out.println("Execution took: " + (endTime - startTime)*Math.pow(10,-9) + " seconds");    
    }
    private static void calculateFactorials() {
        int[] numbersToFactorial = {50000, 65000, 71000, 75000, 99999}; 
        for(int i : numbersToFactorial) {
            System.out.println("Factorial of " + i + " is: " + factorial(i));
        }
    }
    private static BigInteger factorial(int number) {
        BigInteger result = BigInteger.ONE;
        for (int i = 1; i <= number; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }
}
