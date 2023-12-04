package code.bankaccount;

class UnsafeBankAccount {
    private double balance;

    public UnsafeBankAccount(double initialBalance) {
        balance = initialBalance;
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