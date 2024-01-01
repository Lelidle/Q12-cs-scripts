#import "template.typ": *
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#import "@preview/codelst:2.0.0": sourcecode
#show: setup
#set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
#set heading (
    numbering: "1."
)


#let hm = h(1mm)



#v(1fr)
#align(center)[#text(32pt)[Synchronisation \  #align(center)[#image("images/synchronisation.png", width: 80%)] ] \ Stable Diffusion Art "Synchronisation"]
#v(1fr)

#pagebreak()
#outline(title: "Inhaltsverzeichnis", indent: auto)

#pagebreak()

#set page(
    header: align(right)[
        Synchronisation Skript 2inf1 \
  ],
  numbering: "1"
)


= Nebenläufige Prozesse und Parallelität

== Grundbegriffe

In diesem Kapitel beschäftigen wir uns mit dem Problem, dass manche Prozesse lange dauern können und gegebenenfalls andere Prozesse "warten" müssen. Im Sinne der Effizienz (also der Rechengeschwindigkeit) ist das natürlich suboptimal und muss optimiert werden. Wenn Teile eines Programms unabhängig vom Rest "out of order" ausgeführt werden können (und man dies auch macht!), so spricht man von *nebenläufigen* Prozessen. In diesem Kontext taucht auch häufig der Begriff der *Parallelität* von Prozessen auf.

#merke[Die beiden Begriffe sind nicht vollständig deckungsgleich. Bei reiner *Nebenläufigkeit* gehen wir in der Regel nur von einem CPU-Kern aus, der die Abläufe so optimiert, dass möglichst wenig "Leerlauf" entsteht. Ist diese Nebenläufigkeit gegeben, so ist auch Parallelität möglich. Bei der *Parallelität* gehen wir dagegen von mehehreren Kernen aus, die tatsächlich gleichzeitig arbeiten - häufig an Teilproblemen eines größeren Problems.]

Bevor wir allerdings tiefer in technische Details eintauchen, sollen einige "alltägliche" Probleme unter diesem Gesichtspunkt betrachten.

1. *Hausbau*: Hier finden sich beide Konzepte: einerseits kann ein einzelnes Bauarbeity seine Abläufe optimieren und beispielsweise nach dem Bearbeiten des Bodens (was den Raum unbetretbar macht) einfach in einem anderen Raum weiterarbeiten statt darauf zu warten, dass der Boden wieder betretbar ist (um dann etwas anderes in diesem Zimmer zu erledigen). Andererseits gibt es aber natürlich auch paralleles Arbeiten, wenn mehrere Handwerkys gleichzeitig auf der Baustelle arbeiten, was natürlich die Norm ist!
2. *Kochen*: Die Reihenfolge ist auch hier entscheidend, um Prozesse zu optimieren. Hat man das Hauptgericht vollständig gekocht, aber vergessen die Beilage zuzubereiten wird entsteht am Ende ein Zeitproblem (das sich hier sogar negativ auf die Produktqualität auswirken kann). Auch hier ist das Organisieren der nebenläufigen Prozesse also entscheidend. Gleichzeitig können auch hier natürlich mehrere Personen parallel arbeiten (auch wenn zu viele Köche bekanntlich den Brei verderben).
3. *Landwirtschaft*: Auch hier kann es die parallele Bearbeitung mehrerer Felder durch verschiedene Personen geben (beispielsweise beim Silieren). Nebenläufige Prozesse sind aber genauso vorhanden - so ist es wenig sinnvoll nach dem Melken der Kühe neben ihnen stehen zu bleiben und zu warten, dass sie wieder Milch geben.

All diese Beispiele verdeutlichen, dass der Umgang mit Nebenläufigkeit und Parallelität im "realen" Leben in der Regel durch den Einsatz des berühmten *gesunden Menschenverstandes* gereglt wird. Niemand würde sich einfach neben seine Kühe setzen und darauf warten, dass sie wieder Milch geben (außer man schaut gerne Kühe an!).

Leider (?) besitzen Computer keinen gesunden Menschenverstand, d.h. der Umgang mit Nebenläufigkeit und Parallelität muss in irgendeiner Form im Rahmen der Programmierung implementiert werden. Die folgenden Kapitel beschäftigen sich mit der technischen Umsetzung in Java, sowie Lösungen für die dabei auftretenden Probleme.

#pagebreak()

== Threads

Im Gegensatz zu eigenständigen Prozessen, die voneinander abgeschirmt sind (z.B. sind für jeden Prozess ein eigener Adressraum und eigene Betriebsmittel reserviert), teilen sich die einzelnen Threads eines Prozesses ihre Ressourcen (Speicherbereich, Netzwerkverbindung, andere Betriebsmittel) - wir können einen Prozess also in mehrere Threads aufteilen und das Betriebssystem entscheidet welche davon auf welchem Kern ausgeführt werden.

So ergibt sich der Vorteil, dass beim Wechsel von Threads nicht der vollständige Prozesskontext gewechselt werden muss und somit ein schnellerer Wechsel von einzelnen Programmsträngen möglich ist. Das ermöglicht mehr "Gleichzeitigkeit" (oder zumindest schnellen und koordinierten Wechsel). Außerdem können Threads z.B. durch die Verwendung eines gemeinsamen Speicherbereichs leichter miteinander kommunizieren und Daten austauschen, auch wenn sich dadurch einige Probleme ergeben.

Handelt es sich um einen Mehr-Kern-Rechner, so können mehrere Threads auch tatsächlich von mehreren Kernen gleichzeitig abgearbeitet werden und "echte" Parallelität erreicht werden.

In Java können Threads auf zwei Arten realisiert werden:

1. *Custom Threads* als Unterklasse der bereits vordefinierten Klassen _Thread_. Hier muss nur die _run_- Methode überschrieben werden, die definiert, was ein einzelner Thread tun soll.
2. Alternativ kann die Klasse, die die Arbeit eines einzelnen Threads definiert auch das Interface *Runnable* implementieren (dies wird beim Erben von Thread ebenfalls implizit gefordert!).

Beides soll im Folgenden beispielhaft thematisiert werden.

=== Konsolenausgabe mit Runnable

Das folgende Programm macht noch nichts "sinnvolles", sondern soll nur das Prinzip veranschaulichen. Es werden $10$ Threads erzeugt und jeder dieser Threads schreibt $10$ mal etwas auf die Konsole:
#align(center)[
```java
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
            /*Der Main-Thread wartet bis die gestarteten Threads fertig sind.
            join() darf nie im selben for wie start() stehen! Es wäre für
            unser Minimalbeispiel auch gar nicht notwendig, wenn man aber
            Ergebnisse aller Threads abwarten möchte, muss sichergestellt
            werden, dass alle Threads fertig sind! */
            try {
                t[i].join();
            //Notwendig damit das Programm nicht "abstürzt",
            // falls ein Thread interrupted/unterbrochen wird.
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }//Ende des Programms
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
```
]
Die zweite Klasse _MyRunnable_ definiert unser Arbeitspaket, d.h. in der _run_ Methode werden die "Aufgaben" definiert, was in diesem Fall nur einem zehnmaligem Schreiben auf die Konsole entspricht. Da in der Ausgabe die "Nummer" des Threads mit ausgegeben werden soll, muss diese Information im Konstruktor übergeben und in einem Attribut "abgespeichert" werden.

Die Klasse _RunnableExample_ enthält nur eine einzige main-Methode, die 10 der standardmäßigen Java Thread-Objekte erzeugt und in einem Array speichert.

Anschließend wird jedem Thread seine *workload*, also ein Objekt unserer _MyRunnable_-Klasse übergeben.

Zu diesem Zeitpunkt passiert allerdings noch gar nichts, da die Threads erst *gestartet* werden müssen.



#grid(
    columns:(70%, 30%),
    rows: 1,
    gutter: 12pt,
    [Am Ende müssen die Threads auch wieder *"eingefangen"* werden, deswegen wird auf jedem die _join_-Methode aufgerufen - diese führt die Threads und ihre Ergebnisse wieder zusammen (in unserem Fall ist das nicht entscheidend, da wir bereits "unterwegs" auf der Konsole ausgegeben haben, wir benötigen den Befehl trotzdem zum sauberen Beenden der Threads).

    Führt man das Programm aus, so ergibt sich beispielsweise die nebenstehende Ausgabe. Insgesamt sind es natürlich 100 Zeilen auf der Konsole, da 10 Threads jeweils 10 mal ihre Hallo-Nachricht schreiben.

    Man kann deutlich erkennen, dass die Reihenfolge wild durchgemischt ist, beispielsweise schreibt Thread Nummer 6 zweimal in Folge, Thread Nummer 4 dagegen kommt in der Liste gar nicht vor. Die genaue Struktur der Ausgabe lässt sich nicht vorhersagen.
    ], [
```terminal
Hello from Thread 8
Hello from Thread 3
Hello from Thread 8
Hello from Thread 0
Hello from Thread 6
Hello from Thread 6
Hello from Thread 5
Hello from Thread 2
Hello from Thread 7
Hello from Thread 7
Hello from Thread 1
Hello from Thread 9
Hello from Thread 9
```]
)

Die _join_-Methode muss in einem _try-catch_-Block stehen, da der Thread *unterbrochen* werden könnte (oder hängen bleibt)und dann keine Rückmeldung mehr gibt.

#hinweis(customTitle:"Hinweise")[
    1. Beim Start eines Java-Programms führt ein Thread die _main_-Methode aus. Auf diesen Thread kann man via *Thread.currentThread()* zugreifen. Es laufen auch noch weitere Threads, z.B. für den *Garbage Collector*.
    2. Mit der Methode *_interrupt_* kann ein Thread "manuell" beendet werden.
    3. Mit *_sleep_* kann ein Thread sich selbst (aber nicht einen anderen Thread!) pausieren lassen.
]

Ein Thread (auch *Aktivitätsfaden* genannt) kann die folgenden Zustände haben:

#align(center)[
    #image("images/thread_diagramm.png", width:90%)
]

Das obige Zustandsdiagramm soll nur einen Überblick verschaffen, es ist für uns im Detail nicht relevant.

#v(1cm)

=== Custom Threads

Wir betrachten wieder dasselbe Beispiel wie vorher:
#align(center)[
```java
public class ThreadExample {
    public static void main(String[] args) {
        MyThread[] t = new MyThread[10];
        for (int i = 0; i < t.length; i++) {
            //Daten, die der Thread für die Berechnungen benötigt
            // müssen übergeben werden, hier: Threadnummer.
            t[i]=new MyThread(i);
        }
        //Der Rest verläuft analog
        for (int i = 0; i < t.length; i++) {
            t[i].start();
        }
        for (int i = 0; i < t.length; i++) {
            try {
                t[i].join();Thread interrupted/unterbrochen wird.
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
```
]

#align(center)[
```java
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
```
]
Die beiden Varianten sind fast vollständig deckungsgleich, letztendlich gibt es in diesem Fall keinen deutlichen Vorteil einer Methode. Der Vorteil eines Custom Threads liegt jedoch darin, dass wir leichter an die berechneten Werte kommen, wenn wir sie nach dem Abschluss brauchen sollten.

#hinweis(customTitle: "Hinweis für Experten")[Es gibt natürlich noch mehr Varianten, wie man in Java mit Threads umgehen kann, eine allgemeinere bzw. abstraktere Variante wäre die Verwendung des *ExecutorService*.]

Bislang hat unsere Implementierung noch keine sinnvolle Arbeit verrichtet. Das soll sich jetzt ändern. Nehmen wir an für eine größere Rechnung müssen sehr große Fakultäten berechnet werden.
#hinweis(customTitle:"Zur Erinnerung")[$ n! = n dot (n-1) dot (n-2) dots.c 3 dot 2 dot 1 $]

Der Schultaschenrechner gibt bereits bei $70!$ auf und zeigt einen MathError an. Auch in Java müssen wir einige Vorkehrungen treffen, weder der Datentyp _Integer_ noch _long_ sind groß genug um Zahlen wie $50000!$ zu fassen. Für große Zahlen gibt es in Java eine eigene Klasse, den *_BigInteger_*.

#pagebreak()

Zunächst eine sequentielle Implementierung, die die Fakultät einiger großer Zahlen berechnet:

#align(center)[
```java
import java.math.BigInteger;

public class FactorialsBasic {

    public static void main(String[] args) {
        // Um die Implementierungen vergleichen zu können, wird die
        // Systemzeit vor und nach dem Aufruf der Berechnung gemessen...
        long startTime = System.nanoTime();
        calculateFactorials();
        long endTime = System.nanoTime();
        // und anschließend in Sekunden ausgegeben
        System.out.println("Execution took: " +
        (endTime - startTime)*Math.pow(10,-9) + " seconds");
    }

    private static void calculateFactorials() {
        int[] numbersToFactorial = {50000, 50001, 50002, 50003, 50004};
        // Für jede oben definierte Zahl wird die Fakultät berechnet
        for(int i : numbersToFactorial) {
            // und ausgegeben
            System.out.println("Factorial of " + i + " is: " + factorial(i));
        }
    }

    private static BigInteger factorial(int number) {
        // BigInteger benutzt ein Enum, um auf die 1 zuzugreifen
        // Eine implizite Umwandlung ist hier nicht möglich.
        BigInteger result = BigInteger.ONE;
        for (int i = 1; i <= number; i++) {
            // Ähnliches gilt für alle anderen Zahlen, hier wird jeweils
            // der int-Wert in einen BigInteger umgewandelt
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }
}
```
]

Um diese Berechnungen zu beschleunigen können wir jetzt mehrere Threads verwenden und jedem Thread die Aufgabe geben, jeweils eine Fakultät zu berechnen.

#task[Nutzen Sie die obige Vorlage (Schreiben auf die Konsole) und verändern Sie sie so, dass die Fakultäten parallel berechnet werden. Die Lösung findet sich auf der nächsten Seite.]

#pagebreak()

Es muss nicht viel am ursprünglichen Programm geändert werden. Der Thread bekommt weiterhin eine Zahl, dieses Mal wird aber die Fakultät berechnet und ausgegeben, statt nur die Zahl auf die Konsole zu schreiben:

#align(center)[
```java
import java.math.BigInteger;

public class FactorialsParallel {
    //Hier hat sich nichts verändert
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        calculateFactorials();
        long endTime = System.nanoTime();
        System.out.println("Execution took: " +
        (endTime - startTime)*Math.pow(10,-9) + " seconds");
    }

    private static void calculateFactorials() {
        int[] numbersToFactorial = {50000, 50001, 50002, 50003, 50004};
        //Wir benötigen so viele Threads wie Zahlen
        FactorialThread[] threads = new FactorialThread[numbersToFactorial.length];
        // Die Threads werden erzeugt und die Zahl übergeben, deren
        // Fakultät berechnet werden soll
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new FactorialThread(numbersToFactorial[i]);
        }
        // Analoges Vorgehen mit Starten und "einfangen".
        for (FactorialThread thread : threads) {
            thread.start();
        }
        // Wir warten darauf, dass alle Threads fertig werden
        for (FactorialThread thread : threads) {
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        /* Die Threads können ihre Ergebnisse nicht direkt zurückgeben
        * (run ist eine void Methode!) aber wir können mit einem getter
        * das Ergebnis vom Thread erfragen:*/
        for (int i = 0; i < threads.length; i++) {
            System.out.println("Factorial of " + numbersToFactorial[i] + " is: "
            + threads[i].getResult());
        }
    }
}
```
#pagebreak()
```java
class FactorialThread extends Thread {
    // Das Ergebnis wird als Attribut gespeichert, damit nach Beendigung der
    // Berechnung darauf zugegriffen werden kann.
    private final int number;
    private BigInteger result;

    public FactorialThread(int number) {
        this.number = number;
        this.result = BigInteger.ONE;
    }
    // Die eigentliche Berechnung verläuft analog zur sequentiellen Implementierung.
    public void run() {
        for (int i = 1; i <= number; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
    }
    // Ein simpler getter zum "Auslesen" der berechneten Daten.
    public BigInteger getResult() {
        return result;
    }
}
```
]

Dieses Beispiel nutzt zwar die Parallelität - die Komplexität lässt aber noch zu Wünschen übrig. Insbesondere wurden verschiedene Probleme noch umgangen - alle Threads hatten eine Aufgabe, die komplett unabhängig von den anderen Threads war. Das ist natürlich wenig realistisch, da häufig auf den gleichen Daten operiert wird, bzw. die Aufgaben der Threads (teilweise) voneinander abhängen.

#pagebreak()

== Synchronisation

Bei nebenläufigen Prozessen kommt es häufig dazu, dass *gemeinsame Ressourcen* genutzt werden müssen. Um bei einem der obigen Einleitungsbeispiele zu bleiben: ein Koch kann nicht ein weiteres Gericht zubereiten (auch wenn er Zeit hätte), wenn bereits alle Töpfe und Pfannen im Einsatz sind oder - realistischer - alle Herdplatten belegt sind. Die Verwendung einer Pfanne zur gleichzeitigen Herstellung von gegartem Hackfleisch und Karamell ist dabei sicher auch keine gute Lösung.

#merke[Wird der Zugriff auf *gemeinsame Ressourcen* geregelt, so spricht man in der Informatik von *Synchronisation*.]

In diesem Zusammenhang sind drei weitere Begriffe von Bedeutung:

#definition[
    1. *Ununterbrechbare Ressource*: diese kann durch einen Prozess erst verändert werden, wenn ein ggf. vorhandener vorheriger Prozess mit dieser Ressource "fertig ist", sie ist also gewissermaßen "gesperrt".
    2. *Kritischer Abschnitt*: soll ein Teilbereich des Codes nur von einem Prozess gleichzeitig "betreten werden" (sinnvollerweise innerhalb eines größeren Algorithmusses), dann spricht man von einem kritischen Abschnitt im Code.
    3. *Gegenseitiger Ausschluss*: So wird das konkrete *Verfahren* bezeichnet, dass die obigen Bedingungen sicherstellt. In unserem Fall wird das Konzept der *Semaphore* und das *Monitor-Prinzip* wichtig werden.
]

=== Bankkonto mit Semaphor

Nach dem mathematischen Beispiel aus den vorherigen Kapiteln widmen wir uns nun einer anderen Situation: der Modellierung eines Kontos.

Ein Konto benötigt dabei nicht viele Eigenschaften: man muss Geld abheben und einzahlen können, der Konstruktor soll bereits ein gewisses "Startkapital" als Eingabe nehmen.

#task[Implementieren Sie eine Klasse _UnsafeBankAccount_ mit einem Attribut _balance_, sowie die beiden Methoden _deposit_ (einzahlen) und _withdraw_ (abheben) passend. Geben Sie die Informationen zu Einzahlung und Abheben auch auf der Konsole aus (inklusive des aktuellen Guthabens.)]

Eine mögliche Lösung findet sich auf der nächsten Seite. #pagebreak()

```java
public class UnsafeBankAccount {
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
            System.out.println("Withdrawn: " + amount + ",
             Current Balance: " + balance);
        } else {
            System.out.println("Insufficient funds.");
        }
    }
}
```

So weit könnte es sich auch um eine Modellierungsaufgabe aus der Mittelstufe handeln. Testet man die beiden Methoden ausgiebig, so funktioniert das "Konto" so einwandfrei.

Interessant wird es erst, wenn wir die Parallelität ins Spiel bringen - es ist naheliegend anzunehmen, dass eine Transaktion von Geld von einem Thread "verwaltet" wird. Wenn es irgendein Problem mit einer Transaktion gibt, soll natürlich nicht das gesamte Online-Überweisungsportal einer Bank lahmgelegt sein.

Um den Prozess zu vereinfachen betrachten wir keinen ausführlichen Login, Sicherheitsabfragen oder sonstigen Schnickschnack und lassen auch den Transaktionspartner weg - unsere Threads sollen einfach nur Geld einzahlen, bzw. ausgeben können.

Da es sich dabei um sehr einfache Threads handelt soll an dieser Stelle eine weitere Möglichkeit der Thread-Definition vorgestellt werden, die mit wesentlich weniger Schreibarbeit verbunden ist:

```java
// Der Pfeil steht hier für eine "anonyme Funktion"
new Thread(() -> {
    /* Der hier definierte code block repräsentiert die run() Methode des Threads
    Wir sparen uns also die explizite Definition des "runnables" und geben
    dem Thread eine "anonyme" Implementierung mit. Das hat natürlich den Nachteil,
    dass wir sie nicht mehr anderswo verwenden können!*/
}).start();
```

#hinweis[Hier tauchen wir eine kleine Zehe in eine ganz andere Welt des Programmierens. Man spricht bei anonymen Funktionen auch von #link("https://de.wikipedia.org/wiki/Anonyme_Funktion")[Lambda-Funktionen].]

#pagebreak()

In unserem Fall könnten wir das Konto z.B. so testen:
```java
public class AccountTransactions {
    //Festlegen der Threadanzahl
    final static int NUM_THREADS = 10;
    //Festlegen unserer Startkapitals
    final static double INITIAL_BALANCE = 1000;

    private static void useUnsafe() {
        //Erzeugen eines neuen Kontos
        UnsafeBankAccount unsafeAccount = new UnsafeBankAccount(INITIAL_BALANCE);
        System.out.println("Unsafe Bank Account Transactions:");
        //Erzeugen und starten der Threads
        for (int i = 0; i < NUM_THREADS; i++) {
            new Thread(() -> {
                unsafeAccount.deposit(100);
                unsafeAccount.withdraw(200);
            }).start();
        }
    }
```

Wir beginnen also mit 1000 Euro (oder Dollar, oder Yen..) auf dem Konto und starten 10 Threads, die alle 100 Euro einzahlen und direkt danach wieder 200 Euro abheben.

Führen wir diese Methode aus, so steht auf der Konsole z.B. das folgende:

#grid(
    rows: auto, columns:(60%, 40%), gutter: 2pt,
    [```
    Unsafe Bank Account Transactions:
    Deposited: 100.0, Current Balance: 1700.0
    Deposited: 100.0, Current Balance: 1900.0
    Deposited: 100.0, Current Balance: 1400.0
    Deposited: 100.0, Current Balance: 1200.0
    Deposited: 100.0, Current Balance: 1800.0
    Deposited: 100.0, Current Balance: 1500.0
    Deposited: 100.0, Current Balance: 2000.0
    Deposited: 100.0, Current Balance: 1300.0
    Deposited: 100.0, Current Balance: 1100.0
    Deposited: 100.0, Current Balance: 1600.0
    Withdrawn: 200.0, Current Balance: 200.0
    Withdrawn: 200.0, Current Balance: 400.0
    Withdrawn: 200.0, Current Balance: 600.0
    Withdrawn: 200.0, Current Balance: 800.0
    Withdrawn: 200.0, Current Balance: 1000.0
    Withdrawn: 200.0, Current Balance: 1200.0
    Withdrawn: 200.0, Current Balance: 1400.0
    Withdrawn: 200.0, Current Balance: 1600.0
    Withdrawn: 200.0, Current Balance: 1800.0
    Withdrawn: 200.0, Current Balance: 0.0
```],
[Grundsätzlich kommt zwar am Ende das richtige Ergebnis heraus, denn nach dem letzten Abheben haben wir tatsächlich 0 Euro auf dem Konto - die zeitliche Abfolge scheint aber überhaupt nicht zu passen. D.h. die Ausgabe und der tatsächliche "Zustand" unserer Variable, die den Kontostand speichert passen nicht zueinander. Wir zahlen 100 Euro ein, aber der Kontostand ist zu diesem "Zeitpunkt" bereits bei 1700 Euro.

Stellt man sich nun vor, dass tatsächlich noch weitere Konten an Transaktionen beteiligt sind wird das Problem noch deutlicher: es könnte zu irgendeinem Zeitpunkt Geld abgebucht werden, das eigentlich gar nicht verfügbar ist.
]
)
Umgekehrt könnte es auch sein, dass eine Transaktion abgelehnt wird, obwohl eigentlich genug Guthaben vorhanden ist.

Wir müssen also den Zugriff auf unsere Ressource _balance_ (die *ununterbrechbare Ressource*) also limitieren. Hier kommt der *Semaphor* ins Spiel.

#definition(customTitle: "Semaphor")[Ein Semaphor ist eine Variable, deren Wert ausdrückt, ob der Zugriff auf eine gemeinsame Ressource aktuell verboten ist, weil ein anderer Prozess (oder mehrere andere Prozesse, je nachdem wie viele durch den Semaphor erlaubt sind, für uns immer 1!) sie momentan benutzt, oder erlaubt ist, weil kein anderer Prozess sie gerade nutzt.]

Der Ablauf sieht also wie folgt aus:

1. Der Thread prüft, ob der Semaphor "frei" ist.
2. Wenn "belegt" ist, dann wird gewartet und ggf. erneut geprüft.
3. Ist der Semaphor frei, wird er auf "belegt" gesetzt und die Ressource verwendet. Danach wird der Semaphor wieder frei gegeben.


#task[Übertragen Sie diese Idee auf unser Beispiel und verändern Sie die _UnsafeBankAccount_ Klasse so, dass eine "sichere" _SemaphorBankAccount_-Klasse daraus wird.

Recherchieren Sie dazu, wie die Java-Klasse _Semaphor_ funktioniert.]
Eine mögliche Lösung findet sich auf der nächsten Seite.

#pagebreak()

Wir benutzen ein Semaphor, dass nur einem Thread Zugriff auf einmal erlaubt (wird auch als *binärer Semaphor* bezeichnet).

```java
import java.util.concurrent.Semaphore;

class SemaphorBankAccount {
    private double balance;
    //Bei Erstellung eines Kontos wird auch ein Semaphor erstellst
    private Semaphore lock = new Semaphore(1);

    public SemaphorBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }

    public void deposit(double amount) {
        /*Hier muss "try" verwendet werden, da die Möglichkeit besteht, dass der
        Thread, der gerade auf dem Konto arbeitet durch irgendetwas unterbrochen
        wird.*/
        try {
            //Der Semaphor wird für den Thread reserviert und es wird gearbeitet.
            lock.acquire();
            balance += amount;
            System.out.println("Deposited: " + amount + ",
            Current Balance: " + balance);
        } catch (InterruptedException e) {
            //Ausgabe der Fehlermeldung bei Unterbrechung
            e.printStackTrace();
        } finally {
            //Wenn alles geklappt hat wird der Semaphor wieder freigegeben.
            lock.release();
        }
    }
    //Hier läuft alles analog ab!
    public void withdraw(double amount) {
        try {
            lock.acquire();
            //Wir nehmen an, dass kein Überziehen möglich ist
            while (balance < amount) {
                System.out.println("Insufficient funds. Waiting for deposit.");
                Thread.sleep(100);
            }
            balance -= amount;
            System.out.println("Withdrawn: " + amount + ",
             Current Balance: " + balance);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.release();
        }
    }
}
```
#pagebreak()
Testen können wir diese Implementierung z.B. mit der folgenden Methode:

```java
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
```

#grid(
    rows:1, columns:(50%, 50%), gutter:8pt,
    [```
    Semaphor Bank Account Transactions:
Deposited: 100.0, Current Balance: 1100.0
Withdrawn: 200.0, Current Balance: 900.0
Deposited: 100.0, Current Balance: 1000.0
Withdrawn: 200.0, Current Balance: 800.0
Deposited: 100.0, Current Balance: 900.0
Withdrawn: 200.0, Current Balance: 700.0
Deposited: 100.0, Current Balance: 800.0
Withdrawn: 200.0, Current Balance: 600.0
Deposited: 100.0, Current Balance: 700.0
Withdrawn: 200.0, Current Balance: 500.0
Deposited: 100.0, Current Balance: 600.0
Withdrawn: 200.0, Current Balance: 400.0
Deposited: 100.0, Current Balance: 500.0
Withdrawn: 200.0, Current Balance: 300.0
Deposited: 100.0, Current Balance: 400.0
Withdrawn: 200.0, Current Balance: 200.0
Deposited: 100.0, Current Balance: 300.0
Withdrawn: 200.0, Current Balance: 100.0
Deposited: 100.0, Current Balance: 200.0
Withdrawn: 200.0, Current Balance: 0.0
    ```],[#v(2mm)Führen wir diese Methode aus, so ergeben sich die - jetzt schön sortierten - nebenstehenden Transaktionen.

    Damit stellen wir sicher, dass immer nur eine Transaktion auf einmal abläuft und unsere Geldflüsse laufen wieder geordnet ab. Es gibt jedoch einen Nachteil (gerade in unserem speziellen Fall): durch das "Bestehen" auf der Ordnung haben wir im Wesentlichen alle parallele Verarbeitung aus diesem System genommen. Da es primär um das handling verschiedener Transaktionen ging, ist das nicht so schlimm, da im Zweifel viele verschiedene Konten (alle mit ihrem eigenen Semaphor) betroffen sind und nicht nur das eine.

     Trotzdem muss immer hinterfragt werden, ob sich durch die Verwendung von Parallelität wirklich eine Performance-Verbesserung ergibt (das Erzeugen der Threads benötigt z.B. auch Ressourcen!)
    ]
)

#v(0.5cm)

=== Bankkonto mit Monitor

Die Grundidee bei einem Monitor besteht darin, dass wir *kritische Abschnitte* explizit definieren, die "am Stück" von einem Prozess ausgeführt werden müssen. In Java kann so ein kritischer Abschnitt mit dem Schlüsselwort *synchronized* definiert werden. Dabei können sowohl ganze Methoden synchronisiert werden als auch nur Teile einer Methode.

Der Ablauf sieht dann wie folgt aus:
1. Ein Thread ruft eine synchronisierte Methode auf.
2. Falls der Monitor nicht frei ist, dann wartet der Thread, bis er vom Monitor benachrichtigt wird.
3. Falls der Monitor frei ist führt der Thread die Methode aus. Nach Beendigung werden die wartenden Threads vom Monitor benachrichtigt.

#pagebreak()

Wir setzen das Konzept für das obige Beispiel um:

```java
class MonitorBankAccount {
    private double balance;

    public MonitorBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }
    //Wir definieren den Monitor mit dem synchronized Schlüsselwort
    public synchronized void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: " + amount + ", Current Balance: " + balance);
    }

    public void withdraw(double amount) {
        /*Statt in der Signatur, könnte auch nur innerhalb der Methode
        ein Block definiert werden, in diesem Fall umspannt er die ganze Methode,
        ist also äquivalent zur obigen Variante.
        Wir geben dem synchronized block eine Referenz auf "this", da
        für die Umsetzung der "Sperre" hier immer ein Objekt benötigt wird
        */
        synchronized (this) {
            if (balance >= amount) {
                balance -= amount;
                System.out.println("Withdrawn: " + amount + ",
                Current Balance: " + balance);
            } else {
                System.out.println("Insufficient funds.");
            }
        }
    }
}
```

#hinweis[Beide Konzepte - Monitor und Semaphor - setzen letztendlich dasselbe Prinzip um - den "Schutz" der gemeinsamen Ressource. Für unsere Zwecke ist die Verwendung des Monitors meistens zu bevorzugen, da es wesentlich weniger Schreibaufwand bedeutet.]

#pagebreak()

=== Parallelität im Abitur

Die Abituraufgaben halten sich in Bezug auf Implementierung stark zurück, häufig werden eher die Konzepte "Semaphor" und "Monitor" in "anschaulichen" Situationen abgefragt. Für die Aufgaben im Abitur sind auch *Sequenzdiagramme* wieder wichtig. Es folgen deshalb einige Aufgaben in diesem Stil.

Als Erstes betrachten wir einen *Monitor im Straßenverkehr*(*Rechts-vor-Links-Kreuzung*)

#grid(rows:1, columns:(70%, 30%), gutter: 15pt,
[#v(3mm)In unserem informatischen Modell sind die Autos nebenläufige Prozesse und die Kreuzung ist eine gemeinsame Ressource. Der Einfachheit halber gehen wir nur von Autos aus, die so eine Kreuzung in gerader Richtung überqueren wollen.

Wenn z.B. bei B ein Auto ankommt und bei A auch, dann "sperrt" B für A die Kreuzung. A darf erst dann fahren, wenn B die Kreuzung durchfahren und gewissermaßen "freigegeben" hat. Das hat eine gewisse Ähnlichkeit mit einem Semaphor.
],[#align(center)[#image("images/monitor.png", width: 85%)]]
)

#task(customTitle: "Aufgabe 1")[Angenommen, man implementiert in einer Simulation die Regelung, welches Auto losfahren darf (abweichend von der tatsächlichen Rechts-vor-Links-Regel) mit Hilfe eines Monitors, der den Kreuzungsbereich schützt. Beschreiben Sie, was so eine Regelung in der Realität für den Verkehrsfluss bedeuten würde. Gehen Sie auf ggf unerwünschte Auswirkungen ein.
]

#task(customTitle: "Aufgabe 2")[Stellen Sie in wenigen Sätzen den Zusammenhang zwischen den folgenden Begriffen dar:

1. Semaphor
2. kritischer Abschnitt
3. nebenläufige Prozesse
4. gemeinsame Ressourcen
]

#task(customTitle: "Aufgabe 3")[In einem Zug gibt es mehrere, fortlaufend nummerierte Plätze, die von Kunden online gebucht werden können. Dabei wird eine Methode _bookSeat()_ aufgerufen.

Diese Methode prüft, welche der jeweis nächste freie Sitz ist, markiert diesen als besetzt und schickt dem Kunden seine Reservierungsnummer zu.

Stellen Sie die Vorgänge in einem Sequenzdiagramm für den Fall dar, dass
- auf Parallelität nicht geachtet wurde und zwei Kunden nahezu gleichzeitig reservieren wollen.
- das Monitor-Konzept korrekt umgesetzt wurde.

_Hinweis: Sie können davon ausgehen, dass die Plätze/Sitze in der Zug-Klasse als boolean-Array implementiert wurden und keine eigenen Objekte darstellen_
]

#task(customTitle:"Aufgabe 3: Abitur 2023")[#image("images/abi23monitor.png")]

#pagebreak()

== Erzeuger-Verbraucher Systeme

Das obige Konto-Beispiel eignet sich nicht nur für die Analyse der verschiedenen Implementierung der verschiedenen Parallelitätskonzepte, sondern ist im weitesten Sinne auch ein Beispiel für ein sogenanntes *Erzeuger-Verbraucher-Problem*.

Diese sind durch folgende Punkte gekennzeichnet.

- Ein oder mehrere *Erzeuger* legen eine produzierte Ware auf den Weg zu einem Lagerplatz, um dort die Ware abzuladen. Erst nach dem Ablegen der Waren kehren sie wieder zurück.
- Ein oder mehrere *Verbraucher* machen sich auf den Weg zum Lagerplatz, um dort eine Ware abzuholen. Erst wenn sie eine Ware aufgenommen haben, kehren sie zurück.
- Der *Lagerplatz* besitzt *maximale Kapazität* an Waren.
- Die Beteiligten benötigen eine gewisse (zufällige) Zeit für das Abladen bzw. Aufladen am Lagerplatz, sowie eine (zufällige) Zeit für das Erzeugen bzw. Verbrauchen einer Ware.

Der dritte Punkt ist für unser Konto-Beispiel problematisch, da es eher eine *minimale Kapazität* des Kontos gibt, nämlich 0€. Deswegen betrachten wir einige andere Beispiele:

#align(center)[
#tablex(rows:(auto,)*5, columns:(auto,)*3, align: center,
[*Erzeuger*], [*Verbraucher*],[*Lagerplatz*],
[Pizzabäcker], [Kellner],[Theke],
[Holzfäller], [LKW-Fahrer], [Holzstapel],
[Wasserbombenauffüller], [Wasserbombenwerfer], [Wanne],
[Liefernder Roboterarm] ,[Abholender Roboterarm], [Abstellplatz]
 )]

Etwas abstrakter und informatischer formuliert:

1. Mehrere Prozesse nutzen eine gemeinsame Datenstruktur (*Speicher!*).
2. Erzeugerprozesse fügen Objekte hinzu und Verbraucherprozesse entnehmen Objekte.
3. Das Hinzufügen ist nur möglich, wenn die maximale Kapazität der Datenstruktur noch nicht erreicht ist und das Entnehmen ist nur möglich, wenn es mindestens ein Objekt gibt.

Es gibt natürlich viele Möglichkeiten dies zu implementieren. Im einfachsten Fall ist der *Speicher* einfach nur eine ganzzahlige Variable, deren Wert gewisse Grenzen nicht über- oder unterschreiten darf.

Für uns relevant ist der Fall natürlich wieder, wenn der Zugriff auf den gemeinsamen Speicher nicht gleichzeitig erfolgen darf. Die Lösungen für dieses Problem haben wir aber bereits im vorangehenden Kapitel gefunden!

Es fehlen allerdings noch einige Begriffe, die weiter ausdifferenziert werden müssen.

#pagebreak()

=== Aktives Warten
Allgemein könnte der Code für die _insert_ Methode, also das Ablegen in unserem Stapel, naiv wie folgt aussehen, wenn wir davon ausgehen, dass die Attribute _amount_ und _maximum_ in unserer Klasse definiert sind.

```java
//Wir verwenden einen Monitor:
public synchronized void insert() {
    if(amount == maximum) {
        System.out.println("Storage is full! Waiting.")
        //Wir prüfen jede halbe Sekunde, ob der Stapel noch voll ist, oder nicht
        while(amount == max) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace()
            }
        }
        //Falls der Stapel nicht mehr voll ist:
        try {
            //Wir warten eine zufällige Zeit, um das Ablegen zu simulieren
            Thread.sleep((int) (Math.random*1000))
        } catch (InterruptedException e) {
                e.printStackTrace()
        }
        //Wir erhöhen den Zähler
        amount += 1;
    }

}
```

#task[Beschreiben Sie, welches Problem sich aus dieser Implementierung ergibt.]

Die Lösung findet sich auf der nächsten Seite.

#pagebreak()

Der Monitor ist für die gesamte Methode definiert, d.h. unsere Ressource _amount_ ist durch den Thread gesperrt, der darauf wartet (via _Thread.sleep()_), dass wieder Platz freigeschaufelt wird. Man spricht hier auch vom *aktiven Warten*, da immer wieder aktiv geprüft wird, ob die Bedingung noch gilt, anstatt ein Signal abzuwarten, dass die genutzte Ressource wieder frei ist. In unserem Fall kann kein anderes Objekt die _insert_ oder die _remove_ Methode aufrufen, da wir _Thread.sleep()_ innerhalb des Monitors aufrufen. Es wird also nie Platz auf unserem Stapel frei werden.

Folglich müssen dafür sorgen, dass die Methode nicht nur einfach innerhalb des Monitors "schläft" und diesen aufrecht erhält, sondern wieder *freigibt* (und trotzdem noch auf das freigeben wartet).

Möchte man weiterhin das *aktive Warten* benutzen, so muss das Warten in die Erzeuger-Klasse (also die Klasse der Objekte, die "ablegen" wollen) ausgelagert werden. Damit können dann andere Objekte weiterhin konsumieren, d.h. aufnehmen, um Platz zu schaffen.

#task[Geben Sie allgemeinen Quellcode für diese Umsetzung des aktiven Wartens an. Im Fall der Erzeuger Klasse genügt der Abschnitt des Codes, der für das Warten verantwortlich ist.]

Die Lösung findet sich auf der nächsten Seite.

#pagebreak()

```java
//In unserer Speicher-Klasse
public synchronized boolean insert() {
    if (amount == maximum) {
        return false;
    }
    try {
        Thread.sleep((int) (Math.random*1000))
    } catch (InterruptedException e) {
            e.printStackTrace()
    }
    amount += 1;
    return true;
}

//In der Erzeuger-Klasse wird das Warten analog zur vorherigen Variante eingebaut:
while(!storage.insert()) {
    try {
        Thread.sleep(500);
    } catch (InterruptedException e) {
        e.printStackTrace()
    }
}
```

Noch einmal grob zusammengefasst kann das aktive Warten wie folgt implementiert werden.

1. In der *Erzeuger*-Klasse wird die _produce_ Methode immer wieder _insert_ auf dem *Speicher*-Objekt aufrufen, bis dieses den Wert *true* zurückgibt.
2. Analog wird in der *Verbraucher*-Klasse in der _consume_ Methode immer wieder _remove_ aufgerufen, bis der Wert des Aufrufs nicht *null* zurückgibt (wenn wir annehmen, dass ein *Objekt* "abgelegt" wird).
3. In der *Speicher*-Klasse gibt es einerseits die _sychronized insert_-Methode, die das Objekt einfügt, falls noch Platz ist und den Zähler inkrementiert. Andererseits gibt es die _synchronized remove_-Methode, die ein Objekt zurückgibt und den Zähler dekrementiert.

#hinweis[Die Implementierungen der _remove_ Methoden sind völlig analog zur _insert_ Methode und sind deshalb dem geschätzten Lesy zur Übung selbst überlassen.]
#pagebreak()
=== Passives Warten

Man sprich von *passivem Warten*, wenn nach einmaligem Versuch das aufrufende Objekt (also der entsprechende Thread) darauf wartet, dass er benachrichtigt wird, dass die Ressource frei ist.

Unser obiges Problem kann auch durch die Verwendung von passivem Warten gelöst werden, da Java eine eingebaute Methode *_wait_* hat, die den aktuell aktiven Thread warten lässt, im Gegensatz zu _sleep_ gibt diese Methode aber den Monitor wieder frei.

Die _wait_ Methode ist bereits in der _Object_ Klasse implementiert und somit kann jedes Objekt diese aufrufen. Wir benötigen wieder einen _try-catch_-Block, da auch hier unterbrochen werden könnte.
#align(center)[
```java
try {
    wait();
} catch (InterruptedException e) {
    e.printStackTrace()
}
```
]
Damit der Thread wieder an diese Stelle zurückkommen kann muss er von einem anderen Thread via der Methode _notifyAll()_ "geweckt" bzw. benachrichtigt werden.

Mit diesen Informationen können wir wiederum den Code allgemein angeben:
#align(center)[
```java
public synchronized void insert() {
    if(amount == maximum) {
        System.out.println("Storage is full! Waiting.")
        try {
            //Wir verwenden wait() statt sleep()
            wait();
        } catch (InterruptedException e) {
            e.printStackTrace()
        }
    }
    try {
        Thread.sleep((int) (Math.random*1000))
    } catch (InterruptedException e) {
            e.printStackTrace()
    }
    amount += 1;
    //Alle anderen Threads werden ggf. aufgeweckt
    notifyAll()
    }

}
```
]

#task[Auch diese Implementierung ist noch nicht ideal, es gibt ein weiteres Problem. Beschreiben Sie, welches!]

Wie immer gibt es die Lösung auf der nächsten Seite.

#pagebreak()

Diese Variante kann zu *Inkonsistenzen* führen, also in unserem Fall zu einer Belegung über die Maximalanzahl hinaus. Das liegt daran, dass ein Erzeuger nach dem Aufwecken nicht noch einmal prüft, ob die Anzahl am Maximum angekommen ist. Ein anderer Thread hätte aber schneller sein können und der ursprünglich frei gewordene Platz ist schon wieder belegt.

Das Problem lässt sich allerdings sehr leicht beheben: anstatt nur einmal mit *if* zu prüfen, ob wir bereits einen vollen Stapel verwenden wir ein while und zwingen damit beim "Zurückkehren" den Thread dazu erneut zu prüfen:

#align(center)[
```java
public synchronized void insert() {
    while(amount == maximum) {
        System.out.println("Storage is full! Waiting.")
        try {
            wait();
        } catch (InterruptedException e) {
            e.printStackTrace()
        }
    }
    try {
        Thread.sleep((int) (Math.random*1000))
    } catch (InterruptedException e) {
            e.printStackTrace()
    }
    amount += 1;
    notifyAll()
    }
}
```
]

Auch für das passive Warten hier noch einmal zusammengefasst:

1. In der *Erzeuger*-Klasse wird die _produce_ Methode aufgerufen.
2. In der *Verbraucher*-Klasse wird die _consume_ Methode aufgerufen.
3. Im Speicher passiert die Synchronisationsarbeit, sowohl die _insert_, als auch die _remove_ Methode sind hier _synchronized_ und steuern via _wait_ und _notifyAll_ die Zugriffe der einzelnen Threads.

=== Abituraufgaben

Größere Aufgaben dieser Art finden sich in den letzten Jahren quasi nicht. Aus dem Jahr 2012 gibt es aber eine recht ausführliche Aufgabe zum aktiven Warten und dem Monitor.

#task(customTitle: "Abitur 2012")[#image("images/abi12ev.png")]

#pagebreak()

== Verklemmungen (deadlocks)

Mit Hilfe der Semaphore und Monitore haben wir die meisten Probleme gelöst - es bleibt dennoch die Möglichkeit bestehen, dass es zu einer sogenannten *Verklemmung* kommt (wenn die Konzepte nicht korrekt umgesetzt werden). Ein Ähnliches Problem hatten wir beispielsweise schon beim aktiven Warten: der Thread, der wartet, dass etwas vom Stapel entfernt wird vs. alle anderen Threads, die warten, dass dieser den Stapel wieder freigibt.

In diesem Kapitel beleuchten wir *Verklemmungen* noch etwas genauer.


#grid(rows:1, columns:(70%, 30%), gutter: 15pt,
[#v(3mm)
Das klassische "reale" Beispiel für eine Verklemmung hatten wir schon weiter oben: die Kreuzung bei der 4 Autos nahezu gleichzeitig ankommen.

Auch hier könnte bei der Implementierung des Monitors einiges schief gehen - wenn wir die Rechts-Vor-Links Regel wörtlich nehmen könnte der Ablauf so aussehen: Auto A möchte die Kreuzung sperren, bemerkt aber Auto B und wartet, Auto B aber wartet auf Auto C, C wartet auf D und D auf A.
],[#align(center)[#image("images/deadlock.jpg", width: 85%)]]
)

#hinweis[Es gibt keinen "leichten" Weg aus dieser Situation wieder herauszukommen: deswegen ist in der Fahrschule hier auch *Kommunikation* angesagt!]

*Weiteres Beispiel*

Wir erweitern gedanklich das Beispiel unserer Konten aus den vorherigen Kapiteln. Eigentlich sind an einer Überweisung ja zwei Kontent beteiligt.
Wir nehmen folgendes Szenario an:
#align(center)[
#hinweis(customTitle: "Szenario", color: rgb("95FF80"), border-color: rgb("116600"))[
Es gibt die Personen Meike und Nadja mit ihren Konten $M$ (Kontostand 500€) und $N$ (600€)

Meike schuldet Nadja 400€ und Nadja schuldet Meike umgekehrt 300€. Sie sprechen sich deswegen nicht ab, sondern überwisen sich das Geld einfach gegenseitig und auch noch nahezu gleichzeitig!

Nach den Überweisungen sollten also auf Meikes Konto $M$ 400€ sein und auf Nadjas Konto $N$ 700€.
]]

#align(center)[
#tablex(rows:(auto,)*9, columns: (auto,)*3, outset: 3pt,
[*Schritt*], [*Prozess $M -> N$*], [*Prozess $N -> M$*],
[1], [Zugriff auf $N$] , [-],
[2], [$M' = 100€$ und $N'=1000€$ werden berechnet], [-],
[3], [Zuweisung von $M = M' = 100€$], [-],
[4], [setzt aus], [Zugriff auf $M$],
[5], [-], [$M'=400€$ und $N'=300€$ werden berechnet],
[6],[-], [Zuweisung von $M=M'=400€$],
[7], [-], [Zuweisung von $N=N'=300€$],
[8], [Zuweisung von $N=N'=1000€$], [fertig]
)]

Wir haben so Geld vermehrt, da die Kontostände $M = 400€$ und $N=1000€$ betragen. Gut für uns, aber schlecht für die Bank. Bei einer "naiven" parallelen Ausführung kommt es also zu Inkonsistenzen!

Wir müssen also sicherstellen, dass der Zugriff auf $M$ bzw. $N$ wieder durch einen Semaphor oder Monitor geregelt wird. Leider kann damit immer noch z.B. folgendes Szenario auftreten:

#align(center)[
#tablex(rows:(auto,)*6, columns: (auto,)*3, outset: 3pt,
[*Schritt*], [*Prozess $M -> N$*], [*Prozess $N -> M$*],
[1], [Zugriff auf $N$, Reservierung] , [-],
[2], [-], [Zugriff auf $M$, Reservierung],
[3], [-], [Warten auf $N$],
[4], [Warten auf $M$], [-],
[5], [Warten], [Warten],
)]

Die beiden Prozesse warten also darauf, dass die Ressource auf der jeweils anderen Seite wieder freigegeben werden.

Der Prozess $M -> N$ hat $N$ gesperrt und wartet auf $M$, was wiederum vom Prozess $N -> M$ gesperrt ist, das auf $N$ wartet.

Etwas allgemeiner:

#definition[Eine *Verklemmung* kann auftreten, wenn die folgenden drei Voraussetzungen gegeben sind:
1. Die gemeinsame Ressource kann nur durch den Prozess freigegeben werden, dass diese besitzt (Beim Semaphor kann auch ein anderer Prozess freigeben!)
2. Jeder beteiligte Prozess muss versuchen mindestens zwei Sperren auf einmal zu bekommen.
3. Es muss zu einer *zirkulären Abhängigkeit* kommen. Bei zwei beteiligten Prozessen also ein wechselseitiges Warten, bei mehr Prozessen können sich aber auch "Ringe" ergeben (wie bei den Autos weiter oben!)
]

Nachdem das Problem nun identifiziert ist bleibt natürlich noch die Frage:

#align(center)[*Wer löst Verklemmungen auf und wie?*]

Die beiden Prozesse können sich nicht "von selbst" aus diesem Problem befreien, außer wir haben einen sogenannten *Timeout* implementiert: ein Prozess verzichtet nach einer bestimmten Wartezeit auf die Ressource (auch wenn nicht klar ist, ob es sich um eine Verklemmung oder nur eine lange Wartezeit handelt).

Alternativ kann die Verklemmung von einer *übergeordneten Instanz* (also üblicherweise dem Betriebssystem) aufgelöst werden, die brachial entscheidet einen der Prozesse zu unterbrechen.

#task(customTitle: "Aufgabe 1")[Begründen Sie, ob es in der folgenden Situation zu einer Verklemmung kommt ($\P1$ bis $\P5$ sind Prozesse, alles andere sind Ressourcen):

1. $\P1$ besetzt $A$ und wartet auf $C$ und $D$
2. $\P2$ besetzt nichts und wartet auf $A$, $B$ und $E$
3. $\P3$ besetzt $C$ und wartet auf $E$ und $D$
4. $\P4$ besetzt $B$ und $E$ und wartet auf $A$
5. $\P5$ besetzt $D$ und wartet auf $C$

_Tipp: Stellen Sie die Situation mit Hilfe eines Graphen dar!_
]

#task(customTitle: "Aufgabe 2")[Beim klassischen Problem der *speisenden Philosophen* haben wir folgende Situation: 8 Philosophen sitzen an einem runden Tisch. Es gibt für jeden einen Teiller und einen Löffel.

#image("images/philosophen.png")

Ein Philosoph hat jetzt folgendes Verhaltensmuster:
1. Er denkt
2. greift nach einem Löffel rechts oder links von ihm
3. Denkt weiter
4. Greift (zerstreut) nach dem anderen Löffel links oder rechts von ihm
5. Isst mit beiden Löffeln (schnell! Er muss weiter denken)
6. Legt die Löffel wieder ab.

Wie kann es in dieser Situation zu einer Verklemmung kommen?
]

#task(customTitle:"Aufgabe 3")[Beurteilen Sie die folgenden Aussagen:

Um Verklemmungen zu vermeiden, kann man...
1. Semaphore verwenden
2. Monitore verwenden
3. auf gemeinsame Ressourcen verzichten
4. den gleichzeitigen Zugriff auf gemeinsame Ressourcen immer erlauben
5. eine Art Timeout-Funktion einbauen]

#task(customTitle: "Aufgabe 4 - Abi 23")[#image("images/abi23verklemmung.png")]

