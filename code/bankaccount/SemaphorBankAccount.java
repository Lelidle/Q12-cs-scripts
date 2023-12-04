package code.bankaccount;

import java.util.concurrent.Semaphore;

class SemaphorBankAccount {
    private double balance;
    private Semaphore lock = new Semaphore(1);

    public SemaphorBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }

    public void deposit(double amount) {
        try {
            lock.acquire();
            balance += amount;
            System.out.println("Deposited: " + amount + ", Current Balance: " + balance);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.release();
        }
    }

    public void withdraw(double amount) {
        try {
            lock.acquire();
            while (balance < amount) {
                System.out.println("Insufficient funds. Waiting for deposit...");
                Thread.sleep(100);
            }
            balance -= amount;
            System.out.println("Withdrawn: " + amount + ", Current Balance: " + balance);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.release();
        }
    }
}
