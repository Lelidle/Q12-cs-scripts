#import "template.typ": *
#import "@preview/truthfy:0.2.0": generate-table, generate-empty
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#import "@preview/codelst:2.0.0": sourcecode
#show: setup
#set heading (
    numbering: "1."
)


#let sc = sourcecode.with(
    numbers-style: (lno) => text(
        size: 10pt,
        font: "Times New Roman",
        fill: rgb(255,255,255),
        str(lno)
    ),
    frame: block.with(
        stroke: 1pt + rgb("#a2aabc"),
        radius: 2pt,
        inset: (x: 10pt, y: 5pt),
        fill: rgb("777777")
    )
)


#let hm = h(1mm)


#v(1fr)
#align(center)[#text(32pt)[Zeitkomplexität und Grenzen der Berechenbarkeit \  #align(center)[#image("images/timecomplexity.png", width: 80%)] ] \ Stable Diffusion Art "Time Complexity"]
#v(1fr)

#pagebreak()

#set page(
    header: align(right)[
       Zeitkomplexität - Skript 2inf1 \
  ],
  numbering: "1"
)

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

#outline(title: "Inhaltsverzeichnis", indent: auto)

#pagebreak()


= Zeitkomplexität

== Zeitmessungen von Algorithmen

=== Einzelmessungen


Bevor wir uns mit der Theorie beschäftigen wollen wir einige Algorithmen ganz praktisch analysieren, d.h. wir messen die Zeit, die diese Algorithmen brauchen, um zu einem Ergebnis zu kommen.

Wie so oft benutzen wir dafür die Fibonaccizahlen, hier noch einmal die rekursive und iterative Implementierung:


#sc[```java
public static long fibRek(int n) {
  if (n < 3) {
    return 1;
  } else {
    return fibRek(n-1) + fibRek(n-2);
  }
}
```]

#sc[```java
public static long fibIt(int n){
   long x = 1;
   long y = 1;
   long result = 1;
   for (int i=3; i<=n; i++){
      result = x + y;
      x = y;
      y = result;
   }
   return result;
}
```]

*Zur Erinnerung*: um Zeitmessungen durchzuführen können wir in Java den Befehl *System.nanoTime()* verwenden, eine Zeitmessungsmethode sieht also typischerweise so aus:

#sc[```java
public static void timeMeasurement() {
    long start = System.nanoTime();
    methodToMeasure();
    long ende = System.nanoTime();
    System.out.println("The measurement took " + (start - ende) + " nanoseconds");
}
```]

Damit können wir jetzt die Zeit für große Eingaben messen, also z.B. die $5000$. Fibonaccizahl berechnen.

Insgesamt sind diese Einzelmessungen aber noch nicht wirklich aussagekräftig, da wir nur eine absolute Dauer in einem *einzigen* Fall bekommen - möglicherweise hat das Betriebssystem zu dieser Zeit einfach einen anderen Thread bevorzugt.

Um dieses Problem zu umgehen könnte man auf die Idee kommen, die Methode mehrfach ausführen und dann einen Mittelwert zu bilden, z.B.:

#sc[```java
    private static final int RUNS = 100;

    public static void main(String[] args) {
        timeMeasurementMeans();
    }

    public static void timeMeasurementMeans() {
        long sum = 0;
        for(int i = 0; i < RUNS; i++) {
            long start = System.nanoTime();
            fibIt(5000);
            long end = System.nanoTime();
            sum += (end-start);
        }
        System.out.println("The measurement took " + (sum/RUNS) + " nanoseconds");
    }
```]

Leider macht uns Java hier einen Strich durch die Rechnung, denn nach einer gewissen Zeit dauert eine einzige Messung plötzlich verdächtig kurz, siehe #link(<measurementMean>)[hier].

Java weigert sich also offensichtlich das Ganze immer wieder neu zu berechnen und liest nach einer Weile das Ergebnis aus einem Cache.

Wählt man für RUNS den Wert $10$ scheint dies allerdings noch nicht zu passieren und wir können die statistische Varianz zumindest etwas reduzieren.

=== Messreihen

Noch interessanter als Einzelmessungen sind aber ganze Messreihen. Unser endgültiges Ziel wird sein, Algorithmen nach ihrer generellen Laufzeit zu klassifizieren. (siehe #link(<onotation>)[nächstes Kapitel]).

Dabei ist der wichtigste Faktor, wie sich die Laufzeit eines Algorithmus verhält, wenn die Problemgröße zunimmt - in unserem Fall also immer größere Fibonaccizahlen berechnet werden sollen.

Um eine ganze Messreihe aufnehmen zu können, muss nur noch eine weitere Methode geschrieben werden, die diese durchführt. _timeMeasureMeans_ muss dann auch umgeschrieben werden, und einen Eingabeparameter annehmen, das Ganze sieht dann z.B. so aus:

#sc[```java
    private static final int RUNS = 10;
    private static final int INPUT_SIZE = 45;

    public static String timeMeasurementSeries(){
        String result = "";
        for(int i = 0; i < INPUT_SIZE; i++) {
            result += timeMeasurementMeans(i);
        }
        return result;
    }

    public static String timeMeasurementMeans(int n) {
        long sum = 0;
        for(int i = 0; i < RUNS; i++) {
            long start = System.nanoTime();
            fibRek(n);
            long end = System.nanoTime();
            sum += (end-start);
        }
        return n + ";" + (sum/RUNS) + "\n";
    }
```]

Eine zweite Änderung, die an dieser Stelle nützlich ist wurde ebenfalls eingepflegt: die Ergebnisse werden jetzt nicht mehr auf die Konsole ausgegeben, sondern in einem String gespeichert.

Der Strichpunkt und die neue Zeile \\n deuten schon darauf hin, dass wir die Werte dann in einer Datei speichern wollen - bevorzugt in einer .csv Datei, diese kann direkt von z.B. Excel gelesen werden.

Der Vollständigkeit halber hier noch die _save_-Methode, mit der wir die Dateien dann abspeichern können:

#sc[```java
    public static void main(String[] args) {
        save(timeMeasurementSeries());
    }

    public static void save(String str) {
        Path path
            = Paths.get("measurement.csv");
        try {
            Files.writeString(path, str, StandardCharsets.UTF_8);
        }
        catch (IOException ex) {
            System.out.print("Invalid Path");
        }
    }
```]

Die Ergebnisse können dann mit einem Tabellenkalkulationsprogramm als Diagramm dargestellt werden, z.B. als *Punktdiagramm*.

#task[Nutzen Sie den bereitgestellten Code und führen Sie verschiedene Messreihen mit _fibIt_ und _fibRek_ durch.

Analysieren Sie anschließend ihre Ergebnisse mit Hilfe von Diagrammen.]

#merke[In Excel kann in einer .csv Datei ein Diagramm erstellt, aber nicht gespeichert werden! Kopieren Sie also z.B. Ihre Ergebnisse in eine .xlsx Datei und erstellen Sie die Diagramme dort. ]

#pagebreak()

*Analyse der rekursiven Implementierung*

Versucht man den Bereich für die rekursive Implementierung zu vergrößern, so stellt man bereits bei der etwa $45.$ Fibonacci Zahl fest, dass die Berechnung sehr lange dauert.

#align(center)[#image("images/fibrek.png", width:70%)]

Betrachtet man das erste Diagramm, so kann man bereits einen exponentiellen Zusammenhang vermuten. Dies wird bestätigt, wenn man die y-Achse logarithmisch skaliert (zweite Abbildung).

Ein exponentieller Zusammenhang führt in einer logarithmischen Darstellung zu einer Geraden, die hier (nach einigen Ausreißerwerten bei kleinen Größen von $n$) gut zu sehen ist.

Offensichtlich ist eine rein rekursive Berechnung der Fibonacci Zahlen ohne weitere Methoden wie z.B. *dynamische Programmierung* extrem ineffizient.

#task(customTitle:"Denkaufgabe")[Begründen Sie anhand des Codes, warum hier ein exponentieller Zusammenhang beobachtbar ist!]

#pagebreak()

*Analyse der iterativen Implementierung*

Bei der iterativen Implementierung können leicht viel größere Fibonacci-Zahlen berechnet werden, das folgende Beispiel zeigt die Ergebnisse für alle Zahlen bis $400$ und dann bis $10000$:

#align(center)[#image("images/fibiter.png", width: 70%)]


Grundlegend sehen wir in der zweiten Graphik schön den linearen Trend, den wir aufgrund der einen *Wiederholung* im Code erwarten würden.

Bei kleinen Größen scheint noch etwas wunderliches zu passieren, deswegen sind die ersten 400 Werte extra aufgetragen. Während der genaueren Analyse dieser Ausreißer hat sich ein kleines Kaninchenloch aufgetan. Die Ergebnisse dieser Recherche sind sicher nicht für das Abitur relevant, aber eventuell interessant und finden sich im #link(<results>)[Anhang].



#pagebreak()

<onotation>
== Die O-Notation

Wir haben uns bereits in der 11. Klasse mit der sogenannten $cal(O)$ -Notation beschäftigt, zur Erinnerung hier noch einmal der Auszug aus dem Skript zu Bäumen.

Grundsätzlich geht es bei der $cal(O)$-Notation darum, wie der Ressourcenbedarf eines Algorithmuses für große Eingaben skaliert- dabei kann sowohl die Laufzeit als auch der Speicherplatzbedarf betrachtet werden.

Es wird explizit *nicht* betrachtet:
- Programmiersprache
- Betriebssystem
- Prozessorleistung
- Speicherausstattung
- Computerarchitektur
- etc.

Es geht rein um die prinzipielle _Effizienz_ des Algorithmuses, nicht um seine Umsetzung auf einer bestimmten Hardware. Ist der Algorithmus zu "schlecht", so ist er ggf. auf keiner Hardware praktisch umsetzbar!

Bei der Analyse geht es in der Regel darum eine *Worst Case*, oder eine *Average Case*- Abschätzung zu machen, d.h. wie lange braucht mein Algorithmus im schlechtesten Fall, oder im "Durchschnittsfall".

*Beispiel*:

Ist ein Array bereits sortiert, so wird ein guter Sortieralgorithmus nicht so lange brauchen wie bei einem "durchschnittlichen" Array - sprich einem Array, das Werte in einer völlig zufälligen Reihenfolge enthält.

Im *Best Case* wäre der Algorithmus also "sofort" fertig, in den anderen Fällen braucht er länger.

#hinweis[Der *Best Case* wird selten betrachtet, da er ebenfalls recht selten auftritt. Es handelt sich meistens um einen Spezialfall mit wenig praktischer Relevanz, wir beschränken uns also auf die anderen beiden Fälle.]

Grob gesprochen ist es unser Ziel, eine Funktion $T(n)$ zu finden, die das Wachstum unserer Laufzeit *nach oben* begrenzt. Diese Funktion können wir z.B. durch Messreihen wie im vorangehenden Kapitel bestimmen.

Der Eingabeparameter $n$ entspricht dann der Problemgröße, so wie auch schon zuvor.

Findet man eine solche Funktion, so gibt man diese in der Regel mit dem *Landau-Symbol* $cal(O)$ an, man schreibt z.B.:

$ T(n) in cal(O)(n^2) $

Das würde bedeuten: die Funktion, die die Laufzeit unserer Algorithmus beschreibt verhält sich wie eine quadratische Funktion.

#hinweis[Dabei ist es uns völlig egal, ob es sich um $n^2$ oder $1000n^2$ handelt. Was entscheidend ist, ist der _quadratische_ Zusammenhang, denn auf lange Sicht wird z.B. $n^3$ trotzdem immer stärker wachsen als jede beliebige quadratische Funktion.]

Wenn ein Algorithmus designed wird ist das Ziel demzufolge natürlich, dass die beschreibende Funktion eine möglichst "gute" Funktion ist, d.h. eine Funktion, die möglichst schwach "steigt". Im besten Fall ist es sogar eine konstante Funktion, dann schreibt man $cal(O)(1)$

Man spricht bei der *O-Notation* auch von *Komplexitätsklassen*. Die folgende Abbildung zeigt einige weitere Komplexitätsklassen.

#align(center)[#image("images/o.png")]

Man sieht bereits deutlich, dass eine logarithmische Laufzeit immer besser als sogar eine lineare Laufzeit ist. Das bei _fibRek_ auftretenden *exponentielle* Verhalten ist hier gar nicht abgebildet, da es fast an der y-Achse "kleben" würde.


#task[Messen Sie die Laufzeit verschiedener Algorithmen, die sie im Laufe der 11. Klasse implementiert haben, z.B.:
- Berechnung der Länge einer Liste
- Suchen in einem binären Baum
- Graphenalgorithmen wie Tiefensuche
- Sortierverfahren

Nutzen Sie dazu auch weiterhin Diagramme! Geben Sie anschließend an, in welche Komplexitätsklasse diese Algorithmen fallen. (Wir betrachten hier immer die Laufzeit).
]

#pagebreak()

Natürlich ist es unpraktisch den Algorithmus zuerst zu schreiben und dann seine Zeitkomplexität zu testen. Ggf. dauert es sehr lange einen passenden Algorithmus für sein Problem zu entwickeln, nur um dann festzustellen, dass er gar nicht in sinnvoller Zeit terminiert.

Deswegen ist es üblich die Laufzeit bereits durch den *Code* abzuschätzen. Dies kann natürlich beliebig kompliziert werden, es gibt aber einige *Faustregeln* für einfachere Programme, z.B.:

- "einfache" Operationen wie das Verrechnen von Zahlen, das Prüfen einer Bedingung, eine Zuweisung, etc. haben eine *konstante* Laufzeit.
- ist eine Wiederholung im Spiel (z.B. for $i = 0$ bis $n$), dann ist mindestens eine *lineare* Laufzeit zu erwarten.
- auch wenn die Wiederholung "nur" bis z.B. $n/2$ läuft spricht man von einer linearen Laufzeit, mathematisch ausgedrückt: multiplikative Konstanten spielen keine Rolle (siehe oben).
- Werden Wiederholungen ineinander geschachtelt, so erhält man höhere Polynome als Laufzeit, da beispielsweise für jeden einzelnen Listeneintrag die gesamte Liste wieder durchlaufen wird (das ergibt dann $n^2$), usw.
- bei Strukturen wie dem binären Baum kommt es häufig zu logarithmischen Laufzeiten, da wir immer die Hälfte unseres Problemraums (z.B. den Suchraum) einschränken

*Ein Beispiel*:

#sc[```java
  int sum = 0;
  for(int i = 0; i < n; i++) {
      for(int j = 0; j < n/2; i++) {
          summe += 1;
      }
  }
  for(int k = 0; k < n; k++) {
      sum -= 1;
  }
```]

Im ersten Block gibt es zwei ineinandergeschachtelte Wiederholungen, d.h. das inkrementieren wird $n dot n/2 = 1/2 n^2$ mal ausgeführt. In der zweiten Wiederholung gibt es dagegen $n$ Ausführungen.

Damit insgesamt: $ 1/2 n^2 + n $ Operationen. Konstante multiplikative Faktoren spielen keine Rolle, ebensowenig wie das $n$, denn für $n -> infinity$ wächst das Quadrat viel stärker als der lineare Anteil. Insgesamt ergibt sich hier also: $cal(O)(n^2)$

Gelegentlich müssen diese Analysen auch im Abitur durchgeführt werden, dann ist das Programm in der Regel aber nicht rekursiv und relativ einfach angelegt, ein Beispiel findet sich im nächsten Kapitel.

#pagebreak()

== Brute-Force-Attacken

Wie meistens gehen Abitur-Aufgaben nicht so tief in die Materie wie oben dargestellt, explizite Zeitmessungen müssen natürlich nicht durchgeführt werden, auch muss in der Regel kein Code dafür angegeben werden. Die Analyse von Laufzeiten spielt aber schon eine Rolle.

 Häufig haben die Aufgaben mit *Brute-Force-Attacken* zu tun, d.h. wir versuchen einfach systematisch Lösungen zu "erraten", z.B. bei der Bestimmung eines Passworts.

Hat das Passwort die Länge n und besteht der Zeichenvorrat aus $z$ Zeichen, so gibt es $z^n$ Möglichkeiten, die ausprobiert werden müssen, die Zeitkomplexität liegt also in $cal(O)(z^n)$

Es liegt also wieder ein *exponentieller* Zusammenhang vor, der in der Praxis nicht knackbar ist, ohne weitere Tricks anzuwenden.

Zwei der äußerst komplizierten Aufgaben aus dem Abitur 2023 finden sich unten und veranschaulichen das grundlegende Niveau:

#task[#image("images/abi23lz3.png")]

#task[#image("images/abi23lz1.png") \ #image("images/abi23lz2.png")]

#pagebreak()
#set page(
    header: align(right)[
       Grenzen der Berechenbarkeit - Skript 2inf1 \
  ]
)
= Grenzen der Berechenbarkeit

Neben der Frage, wie schnell oder wie effizient ein Algorithmus ist gibt es natürlich noch eine weitere, noch grundlegendere Frage:

#align(center)[*Existiert überhaupt ein Algorithmus, der in vernünftiger Zeit ein gegebenes Problem löst?*]

Man möchte natürlich nicht Jahre- oder Jahrzehntelang an einem Problem arbeiten, nur um dann festzustellen, dass es gar nicht lösbar ist!

Stellt man sich die Frage in dieser Allgemeinheit, so ist man zunächst etwas verloren, wie man das Ganze angehen soll.

Es braucht eine große Menge theoretischen Unterbaus, um die folgenden Ergebnisse wirklich zu verstehen, aber wir tauchen dennoch eine kleine Zehe in die tiefsten Wasser der *theoretischen Informatik* und beleuchten einige Aussagen, z.B. die folgende:

#satz(customTitle: "Die Church-Thuring-These")[Die Klasse der Turing-berechenbaren Funktionen stimmt mit der Klasse der intuitiv berechenbaren Funktionen überein.]

Hier tauchen zunächst zwei Namen auf, die in den Fundamenten der Informatik nicht wegzudenken sind: #link("https://de.wikipedia.org/wiki/Alan_Turing")[Alan Turing] und #link("https://de.wikipedia.org/wiki/Alonzo_Church")[Alonzo Church].

Was ebenfalls bemerkenswert ist: Es ist kein mathematischer Satz, sondern eine *These*, die hier aufgestellt wurde. Es gibt also keinen formalen Beweis, sondern "nur" eine mit vielen Begründungen versehene Behauptung, die auch allgemeine Anerkennung findet.

Nun aber zum Inhalt, zunächst einige Begriffsklärungen:

- *intuitiv-berechenbar*: Turing selbst stellte sich hier alles vor, was ein Mensch mit Papier und Stift auf Papier berechnen kann.
- *turing-berechenbar*: alles, was durch eine *Turingmaschine* berechnet werden kann. Eine Turingmaschine ist im Wesentlichen ebenfalls der Prototyp eines Computers, aber nicht in technischer, sondern in konzeptioneller Hinsicht. Vereinfacht gesagt besteht eine Turingmaschine aus einem Band, auf das Daten geschrieben werden können, einem Kopf, der sich nach links oder rechts bewegen kann und der Zeichen auf das Band schreiben kann (und auch löschen).

Eine Turingmaschine ist im Wesentlichen eine Verallgemeinerung der endlichen Automaten, die wir bereits in der Theorie der formalen Sprachen betrachtet haben (man kann z.B. zeigen, dass die Wörter beliebiger Typ-0 Sprachen von Turingmaschinen erkannt werden können).

Auf diesen Turingmaschinen basiert demzufolge eines der vielen *Berechenbarkeitsmodelle*, also Antworten auf die Frage:

#align(center)[
"Was kann ich überhaupt berechnen"?
]
Die Aussage der Church-Turing-These besagt nun: alles was ein Mensch nur potentiell ausrechnen könnte, kann eine Turingmaschine auch ausrechnen.

Das klingt erst einmal wunderbar, d.h. wir konstruieren einfach munter Turingmaschinen und versuchen eine zu finden, die unser Problem löst!

Auf vielen mathematischen Umwegen lassen sich viele der Probleme, die man gerne lösen möchte auf *Wortprobleme* zurückführen, also Probleme der Form:

#align(center)[*Ist ein gegebenes Wort in einer Sprache $L$*]

Diese Art Frage haben wir bereits z.B. mit den Automaten beantwortet, aber nur für den Fall der *regulären Sprachen*.

Für allgemeinere Sprachen (die allgemeinere Probleme beschreiben) kann man sich also fragen, welche "Antwort" eine gegebene Turingmaschine *T* bei Eingabe eines bestimmten Wortes $omega$ ausgibt. (Die Antwort dabei kann nur sein: "Ist Teil der Sprache" oder "Ist nicht Teil der Sprache")

Turing ging noch einen Schritt weiter, er fragte sich, ob die Turingmaschine bei Eingabe eines Wortes überhaupt immer hält und eine Antwort gibt, ausformuliert:

#definition(customTitle: "Das Halteproblem")[Das allgemeine _Halteproblem_ lautet wie folgt:

- Gegeben: eine Turingmaschine $T$ und ein Eingabewort $omega$
- Gesucht: Terminiert (also "hält") $T$ bei Eingabe von $omega$]

Wenn man weiß, dass die Maschine hält, hat man zumindest Hoffnung, sie klassifizieren zu können und ggf für eine Berechnung zu nutzen. *Turing* machte dies aber völlig zunichte, indem er den folgenden Satz bewies (und zwar mathematisch formal!):

#satz[Das allgemeine Halteproblem ist *unentscheidbar*]

Das bedeutet leider genau das wonach es sich anhört: wenn eine Turingmaschine anfängt zu rechnen können wir *prinzipiell nicht* vorhersagen, ob diese jemals halten wird. Wenn sie losläuft könnte sie nach 100 Jahren stoppen, vielleicht aber auch nie, es gibt keinen Weg dies festzustellen. Diese prinzipielle Nicht-Vorhersagbarkeit hat für die Informatik ähnlich tragische Folgen wie z.B. der #link("https://de.wikipedia.org/wiki/G%C3%B6delscher_Unvollst%C3%A4ndigkeitssatz")[Gödelsche Unvollständigkeitssatz] für die Mathematik.

Die Folgerungen aus dem Halteproblem sind monumental und macht die obige Frage nach der Existenz eines Algorithmus noch wesentlich schwerer. Außerdem ist es für den menschlichen Forschergeist natürlich extrem unbefriedigend bewiesen zu haben, dass wir etwas nicht wissen *können*.

Mit dieser traurigen Erkenntnis endet der Stoff der 12. Klasse.

#align(center)[#text(24pt)[*Ab hier kommt nur noch das Abitur*]

#text(8pt)[(nach dem Anhang)]

#text(24pt)[*Viel Erfolg*]]

#pagebreak()
= Anhang

<measurementMean>

```terminal
The measurement took 51900 nanoseconds
The measurement took 46100 nanoseconds
The measurement took 45900 nanoseconds
The measurement took 43300 nanoseconds
The measurement took 69900 nanoseconds
The measurement took 46000 nanoseconds
The measurement took 68300 nanoseconds
The measurement took 70300 nanoseconds
The measurement took 46000 nanoseconds
The measurement took 45400 nanoseconds
The measurement took 46100 nanoseconds
The measurement took 42400 nanoseconds
The measurement took 57000 nanoseconds
The measurement took 17200 nanoseconds
The measurement took 46100 nanoseconds
The measurement took 24400 nanoseconds
The measurement took 7000 nanoseconds
The measurement took 35100 nanoseconds
The measurement took 23400 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 32000 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 24600 nanoseconds
The measurement took 31400 nanoseconds
The measurement took 6800 nanoseconds
The measurement took 26800 nanoseconds
The measurement took 6900 nanoseconds
The measurement took 31300 nanoseconds
The measurement took 27200 nanoseconds
The measurement took 7000 nanoseconds
The measurement took 44100 nanoseconds
The measurement took 10200 nanoseconds
The measurement took 34500 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 22700 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 21700 nanoseconds
The measurement took 6600 nanoseconds
The measurement took 20700 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 23100 nanoseconds
The measurement took 6700 nanoseconds
The measurement took 1400 nanoseconds
The measurement took 1300 nanoseconds
The measurement took 1300 nanoseconds
```

#pagebreak()

<results>

== Interessantes Laufzeitverhalten

Ausgangspunkt war das merkwürdige Verhalten von Java:

#align(center)[#image("images/fibiter.png", width: 70%)]

Die Arbeitstheorie an dieser Stelle ist, dass sich das Verhalten von Java ändert: zunächst interpretiert die JVM, dann - wenn langsam klar wird, dass es sich um eine rechenintensive Methode handelt dreht der Compiler auf. Scheinbar in mehreren Stufen.
#pagebreak()
Um Vergleichswerte aus anderen Sprachen zu haben folgte zuerst eine vergleichbare Implementierung in $C$. Da das Kompilieren von $C$ unter Windows wenig spaßig ist, wurde dazu ein WSL Ubuntu verwendet. Diese Implementierung lieferte die folgenden Ergebnisse:

#align(center)[#image("images/C.png", width: 70%)]

Hier gibt es keine Startschwierigkeiten, allerdings gibt es auch hier ein Interessantes Phänomen von im Wesentlichen zwei Geraden. Dieses Phänomen wird aber schwächer, wenn man den $C-$Compiler optimieren lässt, er wird dann auch deutlich schneller:

#align(center)[#image("images/CO3.png", width: 70%)]

#pagebreak()

Um wieder Vergleichbarkeit herzustellen wurde nun auch noch der Java Code im WSL ausgeführt, das Ergebnis sieht man hier:

#align(center)[#image("images/JavaWSLCO3.png", width: 70%)]

Der $C-$ Compiler und der Java-Compiler sind sich also im Wesentlichen einig, wie dieses Problem zu optimieren ist und liefern dieselbe Performanz bei größeren Werten, bei kleineren Werten ergibt sich weiter die Diskrepanz des erst langsam aufdrehenden Java-Compilers.

#align(center)[#image("images/JavaWSLCO3400.png", width: 70%)]

Um die Hypothese weiter zu überprüfen und Java dazu zu bringen, früher "warmzulaufen" wurde nun die Anzahl der Durchläufe für die Mittelwertbildung erhöht. Und tatsächlich liefert Java hier (im Gegensatz zu oben) vernünftige Werte und zeigt sich früher bereit vernünftig zu optimieren.

#align(center)[#image("images/Java1000.png", width: 70%)]

Und im entscheidenden Intervall:

#align(center)[#image("images/Java1000smol.png", width: 70%)]

Zum Abschluss noch etwas Amüsantes, aus Neugierde die Ergebnisse eines äquivalenten Codes in Python (zuerst nicht im WSL):

#align(center)[#image("images/paisn.png", width: 70%)]

Scheinbar hat das Zeitmessungsmodul von Python unter Windows Probleme bei der Messung im Nanosekundenbereich.

Auffällig ist in jedem Fall die Langsamkeit (nicht unbedingt überraschend) an sich und der scheinbar nicht lineare Zusammenhang.

#pagebreak()

Um wieder Vergleichbarkeit herzustellen ein letzer Durchlauf im WSL und siehe da:

#align(center)[#image("images/paisnWSL.png", width: 70%)]

Vernünftige Werte! Das Verhalten von Python sieht eher quadratisch als linear aus - und ist einige Größenordnungen größer weiterhin.

Eine mögliche Erklärung für die nahezu quadratische Laufzeit ist möglicherweise das Speichern der Ergebnisse in einem String und das Zusammenkleben dieser Strings zu einem Ausgabestring, der in die Datei gespeichert wird.

Der String wächst ebenfalls mit $n$ und dadurch ergibt sich näherungsweise eine quadratische Laufzeit - Java und C gehen damit intern besser um und bilden den String scheinbar nicht explizit.