package code.bankaccount;

class UnsafeBankAccount {
    private double balance;

    public UnsafeBankAccount(double initialBalance) {
        balance = initialBalance;
    }

    public void deposit(double amount, int counter) {
        balance += amount;
        System.out.println("Deposited: " + amount + ", Current Balance: " + balance + " by Fred " + counter);
    }

    public void withdraw(double amount, int counter) {
            balance += amount;
            System.out.println("Withdrawn: " + amount + ", Current Balance: " + balance + " by Fred " + counter);
    }
}