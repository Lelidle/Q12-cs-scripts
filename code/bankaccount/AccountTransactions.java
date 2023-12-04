package code.bankaccount;

public class AccountTransactions {
    final static int NUM_THREADS = 10;
    final static double INITIAL_BALANCE = 1000;

    public static void main(String[] args) {
        //useUnsafe();
        useSemaphor();
        //useMonitor();
    }

    private static void useUnsafe() {
        // Using the UnsafeBankAccount class
        UnsafeBankAccount unsafeAccount = new UnsafeBankAccount(INITIAL_BALANCE);
        System.out.println("Unsafe Bank Account Transactions:");

        for (int i = 0; i < NUM_THREADS; i++) {
            new Thread(() -> {
                unsafeAccount.deposit(100);
                unsafeAccount.withdraw(200);
            }).start();
        }
    }

    private static void useSemaphor() {
        SemaphorBankAccount semaphorAccount = new SemaphorBankAccount(INITIAL_BALANCE);
        System.out.println("Semaphor Bank Account Transactions:");

        for (int i = 0; i < NUM_THREADS; i++) {
            new Thread(() -> {
                semaphorAccount.deposit(100);
                semaphorAccount.withdraw(200);
            }).start();
        }
    }

    private static void useMonitor() {
        MonitorBankAccount monitorAccount = new MonitorBankAccount(INITIAL_BALANCE);
        System.out.println("\nSafe Bank Account Transactions:");

        for (int i = 0; i < NUM_THREADS; i++) {
            new Thread(() -> {
                monitorAccount.deposit(100);
                monitorAccount.withdraw(200);
            }).start();
        }
    }

}