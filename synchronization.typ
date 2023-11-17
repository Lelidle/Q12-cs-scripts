#import "template.typ": *
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#show: setup
#set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
#set heading (
    numbering: "1."
)


#let hm = h(1mm)

#v(1fr)
#align(center)[#text(32pt)[Synchronisation \  #align(center)[#image("images/art.png", width: 80%)] ] \ Stable Diffusion Art "Networks"]
#v(1fr)

#pagebreak()
#outline(title: "Inhaltsverzeichnis", indent: auto)

#pagebreak()

= Nebenläufige Prozesse und Parallelität

== Grundbegriffe

In diesem Kapitel beschäftigen wir uns mit dem Problem, dass manche Prozesse lange dauern können und gegebenenfalls andere Prozesse "warten" müssen. Im Sinne der Effizienz (also der Rechengeschwindigkeit) ist das natürlich suboptimal und muss optimiert werden. Sind mehrere Prozesse gleichzeitig aktiv, nennt man sie *nebenläufig*. In diesem Kontext taucht auch häufig der Begriff der *Parallelität* von Prozessen auf.

#merke[Die beiden Begriffe sind nicht vollständig deckungsgleich. Bei reiner *Nebenläufigkeit* gehen wir nur von einem CPU-Kern aus, der die Abläufe so optimiert, dass möglichst wenig "Leerlauf" entsteht. Bei der *Parallelität* gehen wir dagegen von mehehreren Kernen aus, die tatsächlich gleichzeitig arbeiten - häufig an Teilproblemen eines größeren Problems.]

Bevor wir allerdings tiefer in technische Details eintauchen, sollen einige "alltägliche" Probleme unter diesem Gesichtspunkt betrachten.

1. *Hausbau*: Hier finden sich beide Konzepte: einerseits kann ein einzelner Bauarbeity seine Abläufe optimieren und beispielsweise nach dem Bearbeiten des Bodens (was den Raum unbetretbar macht) einfach in einem anderen Raum weiterarbeiten statt darauf zu warten, dass der Boden wieder betretbar ist (um dann etwas anderes in diesem Zimmer zu erledigen). Andererseits gibt es aber natürlich auch paralleles Arbeiten, wenn mehrere Handwerkys gleichzeitig auf der Baustelle arbeiten, was natürlich die Norm ist!
2. *Kochen*: Die Reihenfolge ist auch hier entscheidend, um Prozesse zu optimieren. Hat man das Hauptgericht vollständig gekocht, aber vergessen die Beilage zuzubereiten wird entsteht am Ende ein Zeitproblem (das sich hier sogar negativ auf die Produktqualität auswirken kann). Auch hier ist das Organisieren der nebenläufigen Prozesse also entscheidend. Gleichzeitig können auch hier natürlich mehrere Personen parallel arbeiten (auch wenn zu viele Köche bekanntlich den Brei verderben).
3. *Landwirtschaft*: Auch hier kann es die parallele Bearbeitung mehrerer Felder durch verschiedene Personen geben (beispielsweise beim Silieren). Nebenläufige Prozesse sind aber genauso vorhanden - so ist es wenig sinnvoll nach dem Melken der Kühe neben ihnen stehen zu bleiben und zu warten, dass sie wieder Milch geben.

All diese Beispiele verdeutlichen, dass der Umgang mit Nebenläufigkeit und Parallelität im "realen" Leben in der Regel durch den Einsatz des berühmten *gesunden Menschenverstandes* gereglt wird. Niemand würde sich einfach neben seine Kühe setzen und darauf warten, dass sie wieder Milch geben (außer man schaut gerne Kühe an!).

Leider (?) besitzen Computer keinen gesunden Menschenverstand, d.h. der Umgang mit Nebenläufigkeit und Parallelität muss in irgendeiner Form im Rahmen der Programmierung implementiert werden. Die folgenden Kapitel beschäftigen sich mit der technischen Umsetzung in Java, sowie Lösungen für die dabei auftretenden Probleme.

#pagebreak()

== Threads

Im Gegensatz zu eigenständigen Prozessen, die voneinander abgeschirmt sind (z.B. sind für jeden Prozess ein eigener Adressraum und eigene Betriebsmittel reserviert), teilen sich die einzelnen Threads eines Prozesses ihre Ressourcen (Speicherbereich, Netzwerkverbindung, andere Betriebsmittel) - ein Thread führt also nur einen Teil eines Prozesses aus.

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
            //Der Main-Thread wartet bis die gestarteten Threads fertig sind.
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

    Man kann deutlich erkennen, dass die Reihenfolge wild durchgemischt ist, beispielsweise schreibt Thread Nummer 6 zweimal in Folge, Thread Nummer 4 dagegen kommt in der Liste gar nicht vor.

    Die genaue Struktur der Ausgabe lässt sich nicht vorhersagen.
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
#pagebreak()
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
Die beiden Varianten sind fast vollständig deckungsgleich, letztendlich gibt es in diesem Fall keinen deutlichen Vorteil einer Methode.

#hinweis(customTitle: "Hinweis für Experten")[Es gibt natürlich noch mehr Varianten, wie man in Java mit Threads umgehen kann, eine allgemeinere bzw. abstraktere Variante wäre die Verwendung des *ExecutorService*.]

Bislang hat unsere Implementierung noch keine sinnvolle Arbeit verrichtet. Das soll sich jetzt ändern. Nehmen wir an für eine größere Rechnung müssen sehr große Fakultäten berechnet werden.
#hinweis(customTitle:"Zur Erinnerung")[$ n! = n dot (n-1) dot (n-2) dots.c 3 dot 2 dot 1 $]

Der Schultaschenrechner gibt bereits bei $70!$ auf und zeigt einen MathError an. Auch in Java müssen wir einige Vorkehrungen treffen, weder der Datentyp _Integer_ noch _long_ sind groß genug um Zahlen wie $50000!$ zu fassen. Für große Zahlen gibt es in Java eine eigene Klasse, den *_BigInteger_*.

Zunächst eine sequentielle Implementierung, die die Fakultät einiger großer Zahlen berechnet:

#align(center)[
```java
import java.math.BigInteger;

public class FactorialsSequentiell {

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
```
#v(1cm)
```java
    private static void calculateFactorials() {
        int[] numbersToFactorial = {50000, 50001, 50002, 50003, 50004};
        // Für jede oben definierte Zahl wird die Fakultät berechnet
        for(int i : numbersToFactorial) {
            // und ausgegeben
            System.out.println("Factorial of " + i + " is: " + faculty(i));
        }
    }

    private static BigInteger faculty(int number) {
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

#task[Nutzen Sie die obige Vorlage (Schreiben auf die Konsole) und verändern Sie sie so, dass die Fakultäten berechnet werden. Die Lösung findet sich auf der nächsten Seite.]

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
        // Wait for threads to finish
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

Bei nebenläufigen Prozessen kommt es häufig dazu, dass *gemeinsame Ressourcen* genutzt werden müssen. Um bei einem der obigen beispiele zu bleiben: ein Koch kann nicht ein weiteres Gericht zubereiten (auch wenn er Zeit hätte), wenn bereits alle Töpfe und Pfannen im Einsatz sind oder - realistischer - alle Herdplatten belegt sind. Die Verwendung einer Pfanne zur gleichzeitigen Herstellung von gegartem Hackfleisch und Karamell ist dabei sicher auch keine gute Lösung.

#merke[Wird der Zugriff auf *gemeinsame Ressourcen* geregelt, so spricht man in der Informatik von *Synchronisation*.]

In diesem Zusammenhang sind drei weitere Begriffe von Bedeutung:

#definition[
    1. *Ununterbrechbare Ressource*: diese kann durch einen Prozess erst verändert werden, wenn ein ggf. vorhandener vorheriger Prozess mit dieser Ressource "fertig ist", sie ist also gewissermaßen "gesperrt".
    2. *Kritischer Abschnitt*: soll ein Teilbereich des Codes nur von einem Prozess gleichzeitig "betreten werden" (sinnvollerweise innerhalb eines größeren Algorithmusses), dann spricht man von einem kritischen Abschnitt im Code.
    3. *Gegenseitiger Ausschluss*: So wird das konkrete *Verfahren* bezeichnet, dass die obigen Bedingungen sicherstellt. In unserem Fall wird das Konzept der *Semaphore* und das *Monitor-Prinzip* wichtig werden.
]

