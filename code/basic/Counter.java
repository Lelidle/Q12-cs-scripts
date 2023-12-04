package code.basic;

public class Counter extends Thread {

    public static void main(String[] args) {
        World world = new World();
        Counter[] counters = new Counter[100];
        for (int i = 0; i < 100; i++) {
            counters[i] = new Counter(world);
        }
        for (int i = 0; i < counters.length; i++) {
            counters[i].start();
        }
        for (int i = 0; i < counters.length; i++) {
            try {
                counters[i].join();

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println(world.getCounter());
    }

    private World world;

    public Counter(World world) {
        this.world = world;
    }

    public void run() {
        while (!world.isFree()) {
            try {
                sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            world.setFree(false);
            for (int i = 0; i < 10000; i++) {
                world.increase();
            }
            world.setFree(true);
        }
    }
}
