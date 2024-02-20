package code.basic;

public class Example {
    private int amount;
    private int maximum;

    // Wir verwenden einen Monitor:
    public synchronized void insert() {
        if(amount == maximum) {
            System.out.println("Storage is full! Waiting.");
        //Wir prüfen jede halbe Sekunde, ob der Stapel noch voll ist, oder nicht
        while(amount == maximum) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        //Falls der Stapel nicht mehr voll ist:
        try {
            //Wir warten eine zufällige Zeit, um das Ablegen zu simulieren
            Thread.sleep((int) (Math.random()*1000));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //Wir erhöhen den Zähler
        amount += 1;
    }
   }
}
