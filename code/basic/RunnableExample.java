package code.basic;

public class RunnableExample {


public static void main(String[] args) {
    //Standard-Thread-Klasse von Java
    Thread[] t = new Thread[10];    
    for (int i = 0; i < t.length; i++) {
        // Das Arbeitspaket wird übergeben
        t[i]=new Thread(new MyRunnable(i));   
    }
    for (int i = 0; i < t.length; i++) {
        //Die Threads werden gestartet und parallel ausgeführt.
        t[i].start();
    }
    for (int i = 0; i < t.length; i++) {
        //Der Main-Thread wartet bis die gestarteten Threads fertig gearbeitet haben.
        //join() darf nie im selben for wie start() stehen!
        try {
            t[i].join();
        //Notwendig damit das Programm nicht "abstürzt",
        // falls ein Thread interrupted/unterbrochen wird.
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    //Ende des Programms
}
}
class MyRunnable implements Runnable {
        int number;
        //Die übergebenen Daten müssen in Attributen "gespeichert" werden
        public MyRunnable(int number){
            this.number = number;
        }
        //Die run-Methode spezifiziert, was der Thread "tun" soll.
        public void run(){
            for (int i = 0; i < 10; i++) {
                System.out.println("Hello from Thread " + number);
            }
        }
}
