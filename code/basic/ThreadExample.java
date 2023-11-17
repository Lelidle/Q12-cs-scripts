package code.basic;

public class ThreadExample {
    public static void main(String[] args) {
        MyThread[] t = new MyThread[10];
        for (int i = 0; i < t.length; i++) {
            //Daten, die der Thread für die Berechnungen benötigt, müssen übergeben werden.
            t[i]=new MyThread(i);    
        }
        // Der Rest verläuft analog
        for (int i = 0; i < t.length; i++) {
            t[i].start();           
        }
        for (int i = 0; i < t.length; i++) {
            try {
                t[i].join();                               
            } catch (InterruptedException e) { 
                e.printStackTrace();
            }
        }
    }
}
class MyThread extends Thread {
    int nummer;
    //Die übergebenen Daten müssen in Attributen "gespeichert" werden
    public MyThread(int nummer){ 
        this.nummer = nummer;
    }

    public void run(){
        for (int i = 0; i < 10; i++) {
            System.out.println("Hello from Thread " + nummer);
        }
    }

}
