package code.bankaccount;

class MonitorBankAccount {
    private double balance;

    public MonitorBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }

    public synchronized void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: " + amount + ", Current Balance: " + balance);
    }

    public void withdraw(double amount){
        synchronized (this) {
            if (balance >= amount) {
                balance -= amount;
                System.out.println("Withdrawn: " + amount + ", Current Balance: " + balance);
            } else {
                System.out.println("Insufficient funds.");
            }
        }
    }
}