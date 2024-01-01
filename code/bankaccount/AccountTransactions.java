package code.bankaccount;

public class AccountTransactions {
    final static int NUM_THREADS = 100;
    final static double INITIAL_BALANCE = 10000;

    public static void main(String[] args) throws InterruptedException {
        useUnsafeFirst();
    }

    private static void useUnsafe() {
        // Using the UnsafeBankAccount class
        UnsafeBankAccount unsafeAccount = new UnsafeBankAccount(INITIAL_BALANCE);
        System.out.println("Unsafe Bank Account Transactions:");

        for (int i = 0; i < NUM_THREADS; i++) {
            new Thread(() -> {
                //unsafeAccount.deposit(100);
                //unsafeAccount.withdraw(200);
            }).start();
        }
    }

    private static void useUnsafeFirst() {
        UnsafeBankAccount unsafeAccount = new UnsafeBankAccount(INITIAL_BALANCE);
        MyFred[] threads = new MyFred[NUM_THREADS];
        for(int i = 0; i < NUM_THREADS; i++) {
            threads[i] = new MyFred(unsafeAccount, i);
        }
        for(int i = 0; i < NUM_THREADS; i++) {
            threads[i].start();
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

class MyFred extends Thread {
    private UnsafeBankAccount acc;
    private int counter;

    public MyFred(UnsafeBankAccount acc, int counter) {
        this.acc = acc;
        this.counter = counter;
    }

    public void run() {
        System.out.println("Thread " + counter + " withdraws: ");
        acc.withdraw(200, counter);
        System.out.println("Thread " + counter + " deposits: ");
        acc.deposit(100, counter);
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}