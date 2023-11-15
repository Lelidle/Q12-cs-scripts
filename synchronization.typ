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

Leider (?) besitzen Computer keinen gesunden Menschenverstand, d.h. der Umgang mit Nebenläufigkeit und Parallelität muss in irgendeiner Form im Rahmen der Programmierung implementiert werden. Die folgenden Kapitel beschäftigen sich mit weiteren technischen Beispielen und Lösungen für die dabei auftretenden Probleme.

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

#pagebreak()

== Threads

Im Gegensatz zu eigenständigen Prozessen, die voneinander abgeschirmt sind (z.B. sind für jeden Prozess sind ein eigener Adressraum und eigene Betriebsmittel reserviert), teilen sich die einzelnen Threads eines Prozesses ihre Ressourcen (Speicherbereich, Netzwerkverbindung, andere Betriebsmittel) - ein Thread führt also nur einen Teil eines Prozesses aus.

So ergibt sich der Vorteil, dass beim Wechsel von Threads nicht der vollständige Prozesskontext gewechselt werden muss und somit ein schnellerer Wechsel von einzelnen Programmsträngen möglich ist. Das ermöglicht mehr "Gleichzeitigkeit". Außerdem können Threads z.B. durch die Verwendung eines gemeinsamen Speicherbereichs leichter miteinander kommunizieren und Daten austauschen.

In Java können Threads auf zwei Arten realisiert werden:

1. *Threads* als Unterklasse der bereits vordefinierten Klassen _Thread_. Hier muss die _run_- Methode überschrieben werden, die definiert, was ein einzelner Thread tun muss.
2. Alternativ kann die Klasse, die als Thread dienen soll auch das Interface *Runnable* implementieren (dies wird beim Erben von Thread ebenfalls implizit gefordert!).

