package code.basic;

import java.math.BigInteger;

public class FactorialsParallel {
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        calculateFactorials();
        long endTime = System.nanoTime();
        System.out.println("Execution took: " + (endTime - startTime)*Math.pow(10,-9) + " seconds");    
    }

    private static void calculateFactorials() {
        // Numbers to calculate factorials
        int[] numbersToFactorial = {50005, 50006, 50007, 50008, 50009}; 
        FactorialThread[] threads = new FactorialThread[numbersToFactorial.length];
        // Create threads
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new FactorialThread(numbersToFactorial[i]);
        }

        // Start threads
        for (FactorialThread thread : threads) {
            thread.start();
        }

        // Wait for threads to finish
        for (FactorialThread thread : threads) {
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // Retrieve and display results
        for (int i = 0; i < threads.length; i++) {
            System.out.println("Factorial of " + numbersToFactorial[i] + " is: " + threads[i].getResult());
        }
    }


}

class FactorialThread extends Thread {
    private final int number;
    private BigInteger result;

    public FactorialThread(int number) {
        this.number = number;
        this.result = BigInteger.ONE;
    }

    public void run() {
        for (int i = 1; i <= number; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
    }

    public BigInteger getResult() {
        return result;
    }
}
