package code.basic;

public class World {
    private boolean free;
    private int counter;

    public boolean isFree() {
        if(free) {
            free = false;
            return true;
        }
        return false;
    }

    public void setFree(Boolean b) {
        free = b;
    }

    public void increase() {
        counter++;
    }

    public int getCounter() {
        return counter;
    }

}
