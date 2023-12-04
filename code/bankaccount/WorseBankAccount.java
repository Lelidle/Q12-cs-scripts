package code.bankaccount;

public class WorseBankAccount {
    private double balance;

    public WorseBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }

    public void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: " + amount + ", Current Balance: " + balance);
    }

    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            System.out.println("Withdrawn: " + amount + ", Current Balance: " + balance);
        } else {
            System.out.println("Insufficient funds.");
        }
    }

}
