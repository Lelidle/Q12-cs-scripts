#import "template.typ": *
#show: setup
#set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
#set heading (
    numbering: "1."
)




#v(1fr)
#align(center)[#text(32pt)[Formale Sprachen \  #align(center)[#image("images/chomsky.png", width: 80%)]]]
#v(1fr)

#pagebreak()

#set page(
    header: align(right)[
        Formale Sprachen Skript 2inf1 \
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

= Sprachen
== Einleitung 


Auf den ersten Blick erscheint es etwas rätselhaft, warum sich die Informatik mit der Sprachlehre beschäftigen sollte. Auf den zweiten Blick wird dies aber schon klarer, da es nicht umsonst um *Programmiersprachen* genannt wird.

Jede Sprache hat ihre eigene *Syntax* und es steckt eine gewisse *Semantik* hinter den Begriffen, beide Begriffe werden im Folgenden noch ausführlich besprochen. 

Die formalen Sprachen sind ein wichtiges Teilgebiet der *theoretischen Informatik*, d.h. in diesem Schuljahr stehen weniger die praktischen Dinge im Vordergrund, sondern der theoretische Unterbau.

Die Sprachentheorie kommt in vielen Bereichen der Informatik zum Einsatz, insbesondere aber in einem der zentralsten Bereiche, dem *Compilerbau*. Einer Programmiersprache liegt eine sogenannte *Grammatik* zugrunde, die letztendlich festlegt was ein "gültiges Programm" (d.h. syntaktisch korrekt!) darstellt. Der Compiler muss also einerseits diese Struktur überprüfen, andererseits dann eine Übersetzung in Maschinensprache oder eine andere Programmiersprache vornehmen. 

Ein (sehr grober) Überblick über die Funktionsweise eines Compilers wäre also:

1. *Syntaxanalyse*: Der Compiler nutzt die formalen Regeln der Sprache, um den Quellcode syntaktisch zu analysieren, d.h. es wird geklärt: "Handelt es sich um ein korrektes Programm".
2. *Semantische Analyse*: Es existieren in der Regel auch weitere formale Regeln, die die *Bedeutung* (Semantik) des Programms überprüfen sollen. Das geht natürlich nicht vollständig, aber beispielsweise können die zulässigen Bereiche von Variablen oder die korrekte Verwendung von Typen ("starke Typisierung von Java" z.B.!) überprüft werden. 
3. *Übersetzung und Optimierung*: Viele Compiler optimieren den geschriebenen Code und erstellen eine _Zwischendarstellung_, um die Performance zu steigern. 
4. *Codegenerierung*: Zuletzt muss die optimierte Darstellung noch in den tatsächlich von der Maschine ausführbaren Code überführt werden. (oder alternativ in die Darstellung der Ziel-Programmiersprache)

#hinweis[
Da es sich bei diesem Thema um ein sehr schwieriges handelt - es gibt mehrere Vorlesungen, die sich ausschließlich damit im Studium beschäftigen - können wir in der Schule nur eine sehr abgespeckte Variante dieser Theorien behandeln, die sich in der Regel nicht auf Programmiersprachen, sondern auf andere Ausdrücke bezieht, die nach bestimmten Regeln aufgebaut werden, z.B. Email-Adressen, ISBN-Nummern, Autokennzeichen, etc.]

Das folgende Unterkapitel klärt zunächst grundlegende Begriffe etwas genauer.

#pagebreak()

== Grundlagen

Zunächst muss definiert werden, was eine formale Sprache eigentlich sein soll:

#definition[Eine formale Sprache $L$ besteht aus einer Menge von *Zeichenketten (Wörtern)* eines *Alphabets $Sigma$*, das alle benutzbaren *Zeichen (Token)* beinhaltet. 

Kurz: $L subset.eq Sigma^*$]

Der Ausdruck *$Sigma^*$* ist eine Kurzschreibweise für alle möglichen Wörter, die aus einem Alphabet gebildet werden können. Besteht das Alphabet z.B. nur aus einem einzigen Buchstaben $Sigma = {a}$, so könnten die folgenden Wörter damit gebildet werden: 

$ Sigma^* = {epsilon, a, a\a, a\a\a, dots.down} $

Dabei steht *$epsilon$* für das "leere Wort" (kein Leerzeichen, sondern einfach "kein Wort", so wie in Java "" einem leeren String entspricht - es ist offiziell zwar eine Zeichenkette, enthält aber kein Zeichen!). in $Sigma^*$ stecken also *alle* möglichen Wörter. Unsere formale Sprache muss aber nicht alle enthalten. Wir könnten z.B. die Sprache definieren, die nur eine geradzahlige Anzahl an $a$'s enthält, also:
$ L = {epsilon, a\a, a\a\a\a, dots.down} $

Und offensichtlich gilt $L subset.eq Sigma^*$

*Weitere Beispiele*: 

1. *Natürliche Sprachen*: Am Beispiel Deutsch. Unser Alphabet besteht aus den folgenden Zeichen: $ Sigma = {"a"; dots.down; "z"; "A"; dots.down; "Z"; "ä";"Ä";"ö";"Ö";"ü";"Ü";"ß";"!";"\";\"";",";".";":";"Leerzeichen"} $ $Sigma^*$ ist dann die Menge aller möglichen Zeichenketten, allerdings gehören nicht alle zu unserer Sprache! #grid(columns:(50%, 50%), 
rows:(auto), 
gutter: 5pt, 
[#align(center)[#text(green)[*Gehören zur Sprache*]

Informatik

Pizza

Das ist ein deutscher Satz!]], 
[#align(center)[#text(red)[*Gehören nicht zur Sprache*]

Infom

Pazzizo

sjg aksjdfkajs aksjkkii!]]
) Die Analyse natürlicher Sprachen beschäftigt Linguisten schon lange, bisher entziehen sich diese aber einer strengen formalen Klassifikation - d.h. die Regeln für die Bildung deutscher, englischer, französischer und anderer Sprachen sind nicht eindeutig bzw. nicht vollständig bekannt (wenig überraschend!). Wir werden uns mit schöneren (d.h. eindeutigeren) *künstlichen* Sprachen beschäftigen. 
2. *ISBN-Nummern*: Buchnummern bestehen aus fünf-Zahlengruppen, z.B.: $ 978-3-86680-192-9 $ Dabei gibt es natürlich auch gewisse Regeln, die dritte fünfstellige Nummer bezeichnet den Verlag, d.h. nicht jede fünfstellige Zahl existiert als Verlagsnummer. 
#merke[An diesem Beispiel lässt sich der Unterschied zwischen *syntaktisch* und *semantisch* gut herausarbeiten:
1. Das "Wort" $999$ ist nicht Teil der Sprache, weil es *syntaktisch* falsch ist, es ist keine dreizehnstellige Zahl.
2. Das Wort $978-3-99999-192-9$ ist nicht Teil der Sprache, weil es die entsprechende Verlagsnummer nicht gibt. Es erfüllt *semantisch* nicht die Voraussetzungen, d.h. aufgrund der *Bedeutung*.]
3. *Autokennzeichen*: z.B.: NM-AB 34. Offensichtlich ist nicht jede Zeichenkette auch ein existierendes (oder mögliches) Autokennzeichen.#hinweis[Ersteres ist natürlich wieder nichts, was man einfach formalisieren kann. Die Behandlung von syntaktischen Fehlern ist natürlich wesentlich einfacher als die Behandlung von semantischen Fehlern - anders gesagt: es ist vergleichsweise einfach zu entscheiden, ob ein Programm korrekt geschrieben ist (Syntax), aber weniger leicht zu entscheiden, ob es tut was es soll (Semantik). 

*Für Profis*: Streng genommen können beide Probleme natürlich nicht entscheidbar sein, siehe letztes Kapitel dieses Schuljahr und #link("https://de.wikipedia.org/wiki/Satz_von_Rice")[Satz von Rice].]
4. *Mathematische Terme*: Selbsterklärend, Terme werden in der 7. Klasse im Wesentlichen sogar als "sinnvolle Aneinanderreihung von Zahlen, Variablen und Operationen" definiert. D.h. $ 2x + 3 +7$ gehört zur Sprache, 2+++5 dagegen nicht. 
5. *Viele weitere Beispiele*: Chemische Reaktionsgleichungen, Adressen, Nuklidschreibweise, Notation von Schachbewegungen, Geografische Koordinaten, Chat-Ausdrücke/Smileys, Barcodes, Steno, Raumnummern, Musiknoten, Telefonnummern, IP-Adressen, Morsecode, Militärische Handzeichen, Programmiersprachen etc. 

Im Folgenden beschäftigen wir uns mit der Systematik, wie die *Regeln* für Sprachen beschrieben werden können, d.h.: wie können wir beschreiben, welche Wörter zu einer Sprache gehören und welche nicht -  und das führt direkt zum Begriff der *Grammatik*. 

#pagebreak()

= Grammatiken 
== Grundlagen

Auch bei natürlichen Sprachen werden die Regeln zur Bildung von Sätzen durch Grammatiken festgelegt. Bei "künstlichen" Sprachen ist dies ähnlich, jedoch etwas systematischer als die "gewachsenen" natürlichen Sprachen.

Ein offensichtliches Problem der Beschreibung von allgemeinen Sprachen ist, dass eine Sprache unendlich viele korrekte Zeichenketten haben kann, trotz eines endlichen Alphabets (z.B. die Sprache aller Zeichenketten, die nur eine geradzahlige Anzahl an a's haben!).

Die Lösung sind *(endlich) viele Produktionsregeln*, die die Bildung dieser möglichen Worte beschrieben. Die Produktionsregeln zusammen mit dem Alphabet bilden dann die *Grammatik* einer Sprache. 

*Das zu einfache Beispiel*:

Wir wollen die Sprache aller einstelligen Zahlen, sprich die Sprache der Ziffern definieren. Das zugrunde liegende Alphabet ist also $Sigma = {0, 1, dots.down, 9}$. Die zugehörige Produktionsregel wird wie folgt notiert: 

#let ziffer = [#text(red)[Ziffer]]
#let ersteZiffer = [#text(blue)[ErsteZiffer]]
#let ziffern = [$"'1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' "$]
#let ziffern0 = [$"'0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' "$]
#let E = [#text(orange)[E]]
#let Z = [#text(red)[Z]]
#let N = [#text(blue)[N]]


#prodRules(
    content: (
        [#ziffer], [#ziffern0]
    )
) 

Diese Regel besteht aus: 
1. einer *linken Seite*, hier steht ein *Nichtterminalsymbol*, d.h. ein Symbol, das nicht zum Alphabet gehört, sondern nur eine "Beschreibung" darstellt (das wird beim nächsten Beispiel deutlicher).
2. Zeichen des Alphabets (sogenannte *Terminalsymbole*) in Apostrophen - das sind die Zeichen des Alphabets, die wir mit dieser Regel "*produzieren*" können. 
3. senkrechten Strichen $|$, die ein "oder" darstellen.

Die obige Regel kann also so interpretiert werden: 

Das Nichtterminal "#ziffer" kann mit irgendeiner Ziffer von 0 bis 9 ersetzt werden. 

Das sieht bisher noch nicht besonders nützlich aus, deswegen:

*Ein etwas komplexeres Beispiel*:


Als nächstes sollen alle dreistelligen Zahlen gebildet werden können. Man kann also eine ähnliche Regel wie oben benutzen, muss aber sicherstellen, dass die erste Ziffer keine $0$ ist, da es sonst keine dreistellige Zahl wäre:


#prodRules(
    content:(
        [#text(green)[Zahl]], [#text(blue)[ErsteZiffer] #ziffer #ziffer ],
        [#ersteZiffer], [#ziffern], 
        [#ziffer], [#ersteZiffer | '0' ]
    )
)

Die erste Zeile besteht dieses Mal nur aus Nichtterminalsymbolen und beschreibt die Struktur der Zahlen komplett, die übrigen Zeilen legen dann fest, welche Terminale, sprich welche Ziffern, in den einzelnen Schritten ersetzt werden dürfen. 
In der dritten Regel greifen wir dabei wieder auf die zweite Regel zurück, um Schreibarbeit zu sparen. 
#hinweis[Insbesondere in schriftlichen Prüfungen muss eindeutig sein, ob eine Zeichenkette *ein* oder *zwei* Nichtterminale darstellt. Im späteren Verlauf ist es üblich die Nichtterminalsymbole abzukürzen, man würde hier z.B. *E* für die ErsteZiffer nehmen und *Z* für die Ziffer. Der Ausdruck *EZ* und *E Z* kann dann aber durchaus unterschiedliche Bedeutung haben, wenn es noch eine weitere Regel mit *$\E\Z -> dots.c$* gibt.

*Quintessenz*: leserlich und eindeutig schreiben, deutliche Leerzeichen einbauen!
]

*Das noch komplexere Beispiel*:
#let zahl = [#text(green)[Zahl]]
#let gerade = [#text(purple)[gerade]]
#let ungerade = [#text(orange)[ungerade]]



Als letztes soll die Sprache aller dreistelligen Zahlen gebildet werden, die mit einer geraden Zahl starten und mit einer ungeraden Zahl enden, das zugehörige Alphabet sind wieder die Ziffern. Das können wir beispielsweise mit folgenden Regeln darstellen:

#prodRules(
    content: (
        [#zahl], [#gerade #ziffer #ungerade],
        [#gerade], [$"'2' | '4' | '6' | '8'" $],
        [#ungerade], [$"''1 | '3' | '5' | '7' | '9'" $],
        [#ziffer], [#gerade | #ungerade]
    )
)

Für ein bestimmtes Wort der Sprache können wir eine *Ableitung* (hat nichts mit der mathematischen Funktion zu tun!) angeben, d.h. eine Folge an Produktionsregeln, die aus dem Startsymbol (hier #zahl) das gesuchte Wort durch Ersetzungen bildet, z.B. wird die Zahl 211 wie folgt gebildet: 


$ #zahl &->^((1)) #gerade #ziffer #ungerade ->^((2)) 2 #ziffer #ungerade\  &->^((4))  2 #ungerade #ungerade 
->^((3)) 2 1 #ungerade ->^((3)) 2 1 1 $

Ist eine Zeichenfolge, bzw. hier Zahl nicht in der Sprache, so können wir keine entsprechende Reihenfolge finden.

Eine alternative Darstellung ist der sogenannte *Ableitungsbaum* (oder auch *Syntaxbaum*, für das obige Beispiel: 

#align(center)[
    #figure(
        image("images/syntaxbaum.png", width: 60%),
        caption: [Erstellt mit #link("https://flaci.com/")[Flaci]]
    )
]



Die Wurzel des Baums ist das *Startsymbol*. Die jeweiligen Kinder des Knotens ergeben sich durch Anwendung einer Regel.

Es gilt außerdem:
- jedes Blatt muss ein *Terminalsymbol* sein.
- jeder innere Knoten muss ein *Nichtterminalsymbol* sein. 

Zusammengefasst:

#definition[Eine *Grammatik* einer formalen Sprache wird definiert durch vier verschiende Eigenschaften bzw. Objekte:

1. *Vokabular V*: endliche Menge von Nichtterminalsymbolen.
2. *Alphabet $Sigma$*: eine Menge von Zeichen/Terminalsymbolen. 
3. *Startsymbol S*: das Startsymbol der Ableitung.
4. *Produktionsregeln P*: Regeln der Form: $ "<Nr.>: " <"Nichtterminal"> -> <"wird ersetzt durch"> $


Kurz: G = (V, $Sigma$, P, S)]

#hinweis(customTitle: "Hinweise")[1. Unsere Notation der Produktionsregeln orientiert sich an dem, was oft in Schulbüchern angegeben ist. Eine alternative ist die sogenannte erweiterte Backus-Naur-Form, kurz *EBNF*, siehe z.B. #link("https://de.wikipedia.org/wiki/Erweiterte_Backus-Naur-Form")[hier]. Dazu später mehr.
2. Streng genommen können mit der angegebenen Form an Produktionsregeln nicht alle formalen Sprachen angegeben werden, dazu mehr im Exkurs zu #link(<ChomskyHierarchie>)[Chomsky].]

Das noch komplexere Beispiel von oben würde also vollständig so angegeben werden: 

$ G &=( {#zahl, #text(green)[gerade], #text(blue)[Ziffer], #text(orange)[ungerade]} \ 
&{0,1,2,3,4,5,6,7,8,9}, \
#prodRules(
    content: (
        [#zahl], [#gerade #ziffer #ungerade],
        [#gerade], [$"'0' | '2' | '4' | '6' | '8'" $],
        [#ungerade], [$"''1 | '3' | '5' | '7' | '9'" $],
        [#ziffer], [#gerade | #ungerade]
    )
)
\
& #zahl)
$
In aller Regel werden bei Aufgaben zu Grammatiken nur die Produktionsregeln verlangt, da die übrigen Mengen bzw. das Startsymbol aus diesen oder dem Kontext ersichtlich werden. Ist eine *vollständige* Beschreibung der Grammatik explizit gefragt, so muss dennoch die obige Form angegeben werden, siehe Aufgabe 3 auf der nächsten Seite. 

<AufgabeGrammatik1>
#task(customTitle: [_Aufgaben_])[
    #set enum(numbering: (..args) => strong(numbering("1.", ..args)))
    1. Definieren Sie die Produktionsregeln einer Grammatik, die die folgenden umgangssprachlichen Ausdrücke erzeugt. Geben Sie außerdem jeweils einen Ableitungsbaum für die Worte in Klammern an:
        - Alle zweistelligen natürlichen Zahlen. (57)
        - Alle zweistelligen ganzen Zahlen. (-17)
        - Alle höchstens zweistelligen ganzen Zahlen. (-3)
        - Alle natürlichen Zahlen. (1111)
        - Alle Wörter mit 4 Buchstaben, die mit "e" beginnen und mit "a" enden (enta) #hinweis[Als Alphabet sind nur die Kleinbuchstaben zugelassen, es müssen keine "sinnvollen" Wörter im Sinne einer natürlichen Sprache sein.]
    #link(<LösungGrammatik1>)[Zur Lösung]
    2. Beschreiben Sie die Wörter der Sprache, die durch folgende Produktionsregeln erzeugt werden, umgangssprachlich: $ &(1) "Zahl" -> "'5'" "Ziffer" "Ende" | #h(2pt)epsilon \ 
    &(2) "Ziffer" -> "'"0"'"|"'"1"'"|"'"2"'"|"'"3"'"|"'"4"'"|"'"5"'"|"'"6"'"|"'"7"'"|"'"8"'"|"'"9"'" \
    &(3) "Ende" -> "'12' | '22'" $
    #link(<LösungGrammatik2>)[Zur Lösung]
    3. Geben Sie eine *vollständige* Grammatik für die folgenden Sprachen an: #hinweis[Sie können #link("https://flaci.com")[Flaci] zur Überprüfung nutzen]
        - Symmetrische a-b-Ketten nach folgendem Muster: #align(center)[aba, aabaa, aaabaaa, aaaabaaaa, $dots.c$]
        - Geradzahlige Zahlen in Binärdarstellung: $ 0, 10, 100, 110, 1000, 1010, 1100, 1110, dots.c$
        - Natürliche Zahlen mit Tausenderpunkten: $ 1, 50, 375, 1.451, 100.105, 205.111.305 dots.c $
    #link(<LösungGrammatik3>)[Zur Lösung]
    ]

#pagebreak()

*Lösungen*:
<LösungGrammatik1>

*Zweistellige natürliche Zahlen*: 


#prodRules(
    content:(
        [#text(yellow.darken(17%))[NatZwei]], [#ersteZiffer #ziffer], 
        [#ersteZiffer], [#ziffern], 
        [#ziffer], [$"'0' | "$ #ersteZiffer]
    )
)
*Zweistellige ganze Zahlen*:

#prodRules(
    content: (
        [#text(yellow.darken(17%))[GanzZwei]], [#ersteZiffer #ziffer  | $"'"-"'"$ #ersteZiffer #ziffer],
        [#ersteZiffer], [#ziffern], 
        [#ziffer], [$"'0' | "$ #ersteZiffer]
    )
)


*Höchstens zweistellige natürliche Zahlen*:

#prodRules(
    content: (
        [#text(yellow.darken(17%))[NatHöchstensZwei]], [#ersteZiffer |  #ersteZiffer #ziffer],
        [#ersteZiffer], [#ziffern],
        [#ziffer], [$"'0' | "$ #ersteZiffer]
    )
)

oder auch: 

#prodRules(
    content: (
        [#text(yellow.darken(17%))[NatHöchstensZwei]], [#ersteZiffer #ziffer], 
        [#ersteZiffer], [#ziffern], 
        [#ziffer], [$"'0'" " | " #ersteZiffer " | " epsilon $]
    )
)

*Natürliche Zahlen*:

1. Variante (Aufbau der Zeichenkette von vorne)

#let kette = [#text(green.darken(20%))[kette]]

#prodRules(
    content: (
        [#text(yellow.darken(17%))[Nat]], [#ersteZiffer | #ersteZiffer #kette], 
        [#kette], [#ziffer #kette | #ziffer (Selbstreferenz!)],
        [#ersteZiffer], [#ziffern],
        [#ziffer], [$"'0' |"  #ersteZiffer
 $]
    )
)


2. Variante (Aufbau der Zeichenkette von hinten)

#prodRules(
    content: (
        [#text(yellow.darken(17%))[Nat]], [#ersteZiffer | #text(yellow.darken(17%))[Nat] #ziffer (Selbstreferenz!)],
        [#ersteZiffer], [#ziffern],
        [#ziffer], [$"'0' |"  #ersteZiffer $]
    )
)

Die sich selbst referenzierenden Regeln machen es möglich, dass unendlich viele Zeichen entstehen können. (Natürlich wäre es z.B. auch möglich, dass sich zwei Regeln gegenseitig referenzieren und so unendlich viele Zeichen ermöglichen)


*Alle Wörter mit 4 Buchstaben, die mit "e" beginnen und mit "a" enden*: 

#let buchstabe = [#text(blue)[Buchstabe]]

#prodRules(
     content: ( 
        [#text(red)[Wort]],[$"'e'" #buchstabe #buchstabe "'a'"$],
        [#buchstabe], [$"'a' | 'b' | " dots.down " | 'z'"$]	
)
)

#link(<AufgabeGrammatik1>)[Zurück zur Aufgabe]
<LösungGrammatik2>

*Beschreibungeder Sprache*:
Alle vierstelligen Zahlen, die mit 5 beginnen und auf 12 oder 22 enden *oder* keine Zahl, also das leere Wort!
#link(<AufgabeGrammatik1>)[Zurück zur Aufgabe]

<LösungGrammatik3>

*Symmetrische a-b-Ketten*:
$ G_1 = { 
    {#text(red)[Anzahl]}, 
    {a,b},\
    {(1) #text(red)[Anzahl] -> "'a' 'b' 'a' | 'a' " #zahl "'a'"}, \
    #text(red)[Anzahl] 
} $

#merke[Wir müssen hier in einer Regel symmetrisch vor und hinter unserem Vervielfacher arbeiten, da ansonsten eine ungleiche Anzahl an a's möglich wäre! Also eine Regel der Form $ "Wort" -> "X 'b' X" $ (X bildet beliebig viele a's) ist nicht möglich ]

*Geradzahlige Zahlen in Binärdarstellung*

Zuerst muss man die Regelmäßigkeit erkennen: 

Es handelt sich um alle Ketten von Nullen und Einsen, die auf eine 0 enden und mit einer 1 beginnen. Einzige Ausnahme hier ist die 0, da diese ebenfalls schon geradzahlig ist. 

#let X = [#text(blue)[X]]

#prodRules(
     content: ( 
        [#zahl],[$ "'0' | '1' " #X "'0'"$],
        [#X], [$#X #X " | '1' | '0' | " epsilon$]	
)
)

*Natürliche Zahlen mit Tausenderpunkten*

Wir müssen sicherstellen, dass am Anfang keine Null steht und das alle drei Zahlen ein Punkt folgt. 

$ &(1) #zahl -> #text(red)[Präfix] " | " #zahl \ 
&(2) #text(red)[Präfix] -> #E " | " #E #Z " | " #E #Z #Z \ 
&(3) #text(red)[Dreier] -> "'.'"  #Z #Z #Z \ 
&(4) #h(2pt)#E ->  #ziffern \
&(5) #h(2pt)#Z -> #E " | '0'" 
$
Die erste Regel stellt dabei sicher, dass zu einer bestimmten Anzahl an Dreierpaketen an Zahlen (die dann mit Punkten versehen werden) genau ein Präfix hinzukommt, dass aus einer bis drei Zahlen bestehen kann (insbesondere auch notwendig, um ein- bis dreistellige Zahlen zu basteln!)

#link(<AufgabeGrammatik1>)[Zurück zur Aufgabe]

#pagebreak()
== Grammatik einer Programmiersprache 

Ziel dieses kurzen Kapitels ist es, die Grammatik der einfachen Programmiersprache von "Robot Karol" aufzustellen. (Falls sich jemand an dieser Stelle fragt, warum wir keine andere Sprache nehmen, der sei z.B. auf die #link("https://docs.python.org/3/reference/grammar.html")[Python-Dokumentation] hingewiesen :)

Es gab in Robot Karol (Ursprungsversion, verkürzter Befehlssatz) die folgenden Möglichkeiten:

1. *Befehle*: Schritt, LinksDrehen, RechtsDrehen, Hinlegen, Aufheben
2. *Bedingungen*: IstWand, NichtIstWand, IstZiegel, NichtIstZiegel
3. *Kontrollstrukturen*: 
    - wiederhole n mal <code> \*wiederhole 
    - wiederhole solange <Bedingung><code> \*wiederhole
    - wenn <Bedingung> dann <code> \*wenn 
    - wenn <Bedingung> dann <code> \*wenn

#task[Entwickeln Sie die Produktionsregeln einer Grammatik für die obenstehend beschriebene Programmiersprache. Testen Sie Ihre Grammatik mit #link("https://flaci.com")[Flaci] und lassen Sie sich den entsprechenden Ableitungsbaum anzeigen. ]

Die Lösung folgt direkt auf der nächsten Seite!

#pagebreak()

Die Produktionsregeln der Grammatik von Robot Karol

#let programm = [#text(red)[Programm]]
#let bedingung = [#text(red)[Bedingung]]


$ &(1) #programm -> #text(red)[A] | #text(red)[A] #programm \
&(2) #h(2pt)#text(red)[A] -> #text(red)[Befehl] " | " #text(red)[Wiederholung] " | " #text(red)[Entscheidung] \
&(3) #text(red)[Befehl] -> "'Schritt' | 'LinksDrehen' | 'Rechtsdrehen' | 'Hinlegen' | 'Aufheben' " \ 
&(4) #text(red)[Entscheidung] -> "'wenn' " #bedingung " 'dann' " #programm "'"^*"wenn' | " \
&#h(100pt)"'wenn' " #bedingung " 'dann' " #programm " 'sonst' " #programm  "'"^*"wenn'" \
&(5) #text(red)[Wiederholung] -> "'wiederhole" #N " 'mal' " #programm " '"^*"wiederhole' |" \ 
&#h(102pt)"'wiederhole solange" #bedingung #programm " '"^*"wiederhole'" \
&(6) #bedingung -> "'IstWand' | 'NichtIstWand' | 'IstZiegel' | 'NichtIstZiegel' "  \
&(7) #h(2pt) #N -> #E " | " #E #text(red)[Rest] \
&(8) #text(red)[Rest] -> #Z " | " #Z #text(red)[Rest] \
&(9) #h(2pt)#E -> #ziffern \
&(10) #h(2pt) #Z -> #E " | '0'"
$

An dieser Stelle empfiehlt sich wirklich die Eingabe der Grammatik in Flaci und die Überprüfung eines klassischen Programms:
#align(center)[
```
wiederhole 4 mal  
    Schritt
*wiederhole
wenn IstZiegel 
    dann Aufheben 
    wiederhole 4 mal 
        RechtsDrehen 
    *wiederhole 
*wenn
```
]

Es ergibt sich der folgende Ableitungsbaum (reinzoomen nötig!):

#align(center)[
    #image("images/AbleitungKarol.png")
]

#pagebreak()

== Grammatik von E-Mail-Adressen

Für Emails gelten bei uns die folgenden (vereinfachten) Regeln: 

1. Eine *Email-Adresse* besteht aus einer Benutzerkennung, dem \@-Zeichen und dem Namen einer Domäne.
2. Für die *Benutzerkennung* dürfen Kleinbuchstaben und Ziffern verwendet werden. Sie darf beliebig, mindestens jedoch ein zeichen lang sein.
3. Die *Domäne* setzt sich zusammen aus einer oder mehrerer Unterdomänen, gefolgt von einer Hauptdomäne (Top-Level-Domain). Die Bestandteile der Domäne sind jeweils durch einen Punkt getrennt. 
4. Die *Top-Level-Domain* darf nur aus Kleinbuchstaben zusammengesetzt sein und ist entweder zwei oder drei Zeichen lang.
5. Jede *Unterdomäne* darf Kleinbuchstaben und Zahlen enthalten. Sie darf beliebig, mindestens jedoch zwei Zeichen lang sein.

#task[Entwickeln Sie die Produktionsregeln einer Grammatik für die oben beschriebenen Regeln für Email-Adressen. Testen Sie Ihre Grammatik mit #link("https://flaci.com")[Flaci] und lassen Sie sich den entsprechenden Ableitungsbaum anzeigen.]

Die Lösung findet sich auf der nächsten Seite!

#pagebreak()

In der folgenden Lösung steht #N für die Nutzerkennung (auch verwendet als beliebig lange Zeichenkette, aber mindestens ein Zeichen lang), #text(red)[U] für eine Unterdomäne und #text(red)[T] für eine Top-Level-Domain:

$ &(1) #text(red)[Email] -> #N " '@' " #text(red)[U] #text(red)[T]\ 
&(2) #h(2pt) #N -> #text(red)[B] " | " #Z " | " #N #N \ 
&(3) #h(2pt) #text(red)[B] -> "'a' | " dots.c " | 'z'" \ 
&(4) #h(2pt) #Z -> "'0' | " dots.c " | '9'" \
&(5) #h(2pt) #text(red)[U] ->  #N #N "'.' | " #text(red)[U] #text(red)[U] \
&(6) #h(2pt) #text(red)[T] -> #text(red)[B] #text(red)[B] " | " #text(red)[B] #text(red)[B] #text(red)[B]
$

Damit Flaci nicht allzuviel zu tun hat verwenden wir zum Testen nur die Emailadresse "t1\@un.do.com". Es ergibt sich der folgende Ableitungsbaum (wieder reinzoomen nötig!):

#align(center)[
    #image("images/AbleitungEmail.png")
]



#pagebreak()

== EBNF

Wie bereits in einem Hinweis erwähnt gibt es eine weitere übliche Notationsform, die *erweiterte Backus-Naur-Form*. Es gelten die folgenden Regeln (Auszug der für uns Wichtigsten):

1. Alle Regeln haben die Form #text(red)[*$<$Nichtterminal$> = dots.down$ ;*]
2. Aneinanderreihungen mit #text(red)[,] (kann weggelassen werden)
3. Oder-Symbol #text(red)[$|$]
4. Terminalsymbole werden in Anführungszeichen oder Apostrophe gesetzt. 
5. *Optionen* werden in eckige Klammern gesetzt #text(red)[$[dots.down]$]
6. *Gruppierung von Elementen*: #text(red)[(dots.down)]
7. *Wiederholung* (auch Null mal): #text(red)[${dots.down}$]
8. *Mehrfachausführung*: #text(red)[$3^*X$]
9. *Ausschluss*: #text(red)[$dots.down - X$]

Die Apostrophe bei Zeichen sind insbesondere deswegen wichtig, um Zeichen der EBNF-Notation von der Verwendung innerhalb der Zeichenkette zu unterscheiden, so hat das "="-Zeichen untenstehend zwei verschiedene Bedeutungen - der Beginn der Regel und die Verwendung als tatsächliches Zeichen

#text(red)[Beispiel] = #text(red)[Anfang] '+' #text(red)[Mitte] '=' #text(red)[Ende] ;

#hinweis[Nimmt man die EBNF-Regeln ernst, müstte z.B. nach Anfang ein , stehen. Diese Kommata dürfen aber weggelassen werden (siehe oben)]

Im Folgenden finden sich einige Beispiele, um die EBNF-Regeln zu veranschaulichen:
#v(0.25cm)
#let var = [#text(red)[Var]]
#grid(
    columns: (50%, 50%),
    rows: (auto, auto, auto, auto, auto, auto),
    gutter: 10pt, 
    [*Regel*], [*Möglicher Output*], 
    [#text(red)[Anfang] $ = [$'A' $|$ 'B'$]$ 'C';], [*AC* oder *BC* oder *C*],
    [#text(red)[Mitte] $=$ 'A' $($ 'X' $|$ 'Y' | #var$)$;], [*AX* oder *AY* oder *A#var*],
    [#text(red)[Ende]= $3^*$ #text(red)[Baum] 'Z';], [*#text(red)[Baum Baum Baum] Z*], 
    [#var $=$ 'A'${$'B' 'C' $}$ 'D';], [*AD* oder *ABCD* oder *ABCBCD* oder dots.down], 
    [#text(red)[Text] $=$ 'X' ${$#var$} -$ #var ;], [*X* oder *X #var #var* oder *X #var #var #var*]
)
#v(0.25cm)
#task(customTitle: [_Aufgaben_])[Schreiben Sie die Produktionsregeln in EBNF- Form für die folgenden umgangssprachlich beschriebenen Zeichenketten (jeweils ggf. mit den bisher gemachten Vereinfachungen)
1. Natürliche Zahlen 
2. alle Vielfachen von 5 (also 5,10,15, $dots.down$)
3. Ganze Zahlen
4. Dezimalzahlen
5. geradzahlige Binärzahlen
6. Die Sprache, die nur die Wörter *x*, *xz* und *xyz* enthält (ohne "Oder"-Zeichen)
7. Natürliche Zahlen mit Tausenderpunkten
8. Emails
9. "Korrekte" Summen und Differenzen, also z.B.: $(15+(-3))-500+((33+11)-(-5))$]


Die Lösungen finden sich ab der nächsten Seite.
#pagebreak()


*Natürliche Zahlen*:

$ &(1) #text(red)[Nat] = #Z { #Z " | '0'"};\
&(2) #h(2pt)#Z = "'1'| " dots.down " |'9'";
  $

*Alle Vielfachen von 5*:

$ &(1) #zahl = "'5'" | #Z " "{#Z "| '0'"} " "("'0'|'5'");\
&(2) #h(2pt)#Z = "'1'| " dots.down " |'9'";
 $

*Ganze Zahlen*:

$ &(1) #text(red)[Ganz]= "'0' | ['-']" #Z " "{#Z" | '0'"};\
&(2) #h(2pt)#Z = "'1'| " dots.down " |'9'";
 $

*Dezimalzahlen*:

$ &(1) #text(red)[Dezi]= "['-'] ('0'|" #Z{ #Z"|'0'"})"','"{#Z"|'0'"} #Z ";" \
&(2) #h(2pt)#Z = "'1'| " dots.down " |'9'";
 $


*Geradzahlige Binärzahlen*:

$ &(1) #zahl= "'0'|'1' {'0'|'1'} '0';" $
oder
$ &(1) #zahl =" [ '1' {'0'|'1'}] '0';" $

*Die Sprache, die nur die Wörter x, xz und xyz enthält*

$ &(1) #text(red)[Wort]= " 'x'[['y']'z'];" $

*Natürliche Zahlen mit Tausenderpunkten*

$ &(1) #zahl = #E [#Z] [#Z] {"'.'"3^* #Z}";" \
&(2) #h(2pt)#E = "'1'| " dots.down " |'9';" \
&(3) #h(2pt)#Z = #Z "|'0';"
 $

*Email-Adressen*:

$ &(1) #text(red)[Adresse] = #text(red)[Benutzer] "'@'" #text(red)[Domäne] ; \
&(2) #text(red)[Benutzer] = ( #Z "|" #text(red)[B] )" " { #Z "|" #text(red)[B]}; \
&(3) #text(red)[Domäne] = #text(red)[Unterdomäne] { #text(red)[Unterdomäne]} #text(red)[TLD] ; \
&(4) #text(red)[TLD] = #text(red)[B] #text(red)[B] [#text(red)[B]]; \
&(5) #text(red)[Unterdomäne]= 2^* ( #Z | #text(red)[B]) " " {#Z | #text(red)[B]}"'.'"; \
&(6) #h(2pt)#Z "'0'| " dots.down " |'9';" \
&(7) #h(2pt)#text(red)[B] "'a'| " dots.down " | 'z';"
 $
#pagebreak()
*Terme*

$ &(1) #text(red)[Term] = #text(red)[Summand] ("'+'|'-'") #text(red)[Summand]{("'+'|'-'") #text(red)[Summand]}";"\
&(2) #text(red)[Summand]= #zahl "| '('" #text(red)[Term] "')';" \
&(3) #zahl = #text(red)[Nat] "| '0' | '(' '-'" #text(red)[Nat]"')';" \
&(4) #text(red)[Nat] = #ziffer -"'0'" {#ziffer}";" \
&(5) #ziffer = "'0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9';"
 $

#v(0.5cm)
== Syntaxdiagramme für EBNF

Statt eine Grammatik anzugeben, kann die EBNF-Notation auch in Diagrammform in sogenannten *Syntaxdiagrammen* dargestellt werden. Dabei gibt es für jede Produktionsregel ein eigenes Syntaxdiagramm. 

#align(center)[
    #image("images/syntaxEinführung.png")
]

#task[Zeichnen Sie für die folgenden Regeln jeweils Syntaxdiagramme: 
1. #text(red)[Nat] = #Z {#Z | '0'};
2. #text(red)[Ganz] = ['-'] #text(red)[Nat] | '0';
3. #text(red)[Dez] = ['-'] ('0' | #text(red)[Nat]) ',' {#Z|'0'} #Z ; 
4. #text(red)[Wort] = 'X' {'x' | #text(red)[B A]} ;
5. #text(red)[Wort2] = [#text(red)[B] [#text(red)[C]] ('x' | 'y' | 'z')] ;
6. #text(red)[Zahl] = '5' | #Z { #Z | '0' } ( '0' | '5');
7. #text(red)[ZahlT] = #E [ #Z ] [ #Z ] { '.' $3^*$ #Z };
]
Die Lösungen finden sich wieder ab der nächsten Seite:

#pagebreak() 



#grid(columns: (50%, 50%), rows: (auto), [*Natürliche Zahlen*:
#align(center)[#image("images/syntaxA1.png")]
], [*Ganze zahlen*

#align(center)[#image("images/syntaxA2.png")]
])

*Dezimalzahlen*:
#align(center)[#image("images/syntaxA3.png")]

#grid(columns: (50%, 50%), rows: (auto), [*Wort*:
#align(center)[#image("images/syntaxA4.png")]
], [*Wort 2*

#align(center)[#image("images/syntaxA5.png")]
])

*Vielfache von 5*:
#align(center)[#image("images/syntaxA6.png", width: 90%)]

#pagebreak(

)
*Natürliche Zahlen mit Tausenderpunkten*:
#align(center)[#image("images/syntaxA7.png")]

#v(0.5cm)
#task[Geben Sie die Produktionsregeln in EBNF-Form an, die zu den folgenden Syntaxdiagrammen gehören:
#align(center)[#image("images/syntaxA8.png")]
]

#pagebreak()

== Exkurs: Sprachklassen nach Chomsky
<ChomskyHierarchie>
Bisher haben wir nur an der Oberfläche der Sprachlehre gekratzt. Die bereits eingeführten künstlichen Sprachen können sich noch in *Klassen* einteilen lassen. Die Produktionsregeln der einzelnen Klassen unterliegen dabei verschiedenen Einschränkungen, d.h. manche Sprachen sind "*spezieller*".

Dabei gibt es einen direkten Zusammenhang zwischen den Eigenschaften der Produktionsregeln der *Grammatik* und den Eigenschaften der von ihr erzeugten Sprache *L(G)*. 

Der amerikanische Sprachwissenschaftler Noam Chomsky hat ein Klassifikationssystem entwickelt, das vier Arten von formalen Grammatiken und damit von formalen Sprachen definiert (#cite(<hoffmann>) S. 169).

#align(center)[#image("images/chomsky.png", width: 70%)]

Um die Unterschiede der Sprachen besser beleuchten zu können, ist eine allgemeinere Definition einer Grammatik notwendig, als die, die wir bisher verwendet haben.

#definition[Eine *Grammatik* einer formalen Sprache ist ein Viertupel $(V, Sigma, P, S)$ und besteht aus

1. der endlichen _Variablenmenge V (Nonterminale)_,
2. dem endlichen _Terminalalphabet_ $Sigma$ mit $V sect Sigma = emptyset $
3. der endlichen Menge _P_ von _Produktionen (Regeln)_ und 
4. der _Startvariablen S_ mit $ S in V$.

Jede Produktion aus _P_ hat die Form $l -> r$ mit $l in (V union Sigma)^+$ und $r in (V union Sigma)^*$ (#cite(<hoffmann>), S. 164).
]

Der Wesentliche Unterschied liegt - neben der noch mathematischeren Notation - in den erlaubten Produktionsregeln. Die linke Seite einer Regel kann im Allgemeinen nicht nur ein Nichtterminalsymbol enthalten, sondern mindestens ein Terminal oder Nichtterminalsymbol. Das erweitert unsere Möglichkeiten beträchtlich!

#pagebreak()

Damit lässt sich die Klassifikation mit Leben füllen (#cite(<hoffmann>), S. 169):

1. *Phrasenstrukturgrammatiken (Typ-0-Grammatiken)* \ Jede Grammatik, die die obere Definition erfüllt ist automatisch eine Typ-0-Grammatik. Es gibt insbesondere keine weiteren Einschränkungen für die Produktionsregeln.
2. *Kontextsensitive Grammatiken (Typ-1-Grammatiken)* \ Bei kontextsensitiven Grammatiken muss $|r| >= |l|$ gelten, d.h. die rechte Seite muss mindestens so lang sein, wie die linke Seite der Produktionsregel (einzige Ausnahme: $S -> epsilon$, dann darf $S$ aber in keiner rechten Seite vorkommen!)
3. *Kontextfreie Grammatiken (Typ-2-Grammatiken)* \ Zusätzlich zu der vorherigen Einschränkung darf jetzt auf der linken Seite nur noch ein einziges Nonterminal stehen (d.h. unsere Grammatikdefinition entspricht kontextfreien Sprachen).
4. *Reguläre Grammatiken (Typ-3-Grammatiken)* \ Die speziellsten Grammatiken, sie sind kontextfrei und besitzen zusätzlich die Eigenschaft, dass die rechte Seite einer Regel entweder $epsilon$ ist oder ein Terminalsymbol gefolgt von einem Nichtterminalsymbol. 

*Beispiele* (#cite(<hoffmann>), S. 169ff.)

1. $L_3 := {(\a\b)^n | n in NN^+}$ ist eine *reguläre Sprache*. #hinweis[Der Exponent steht hier für eine Wiederholung, d.h. hier betrachten wir Wörter wie $\a\b, \a\b\a\b, dots.down$] Mögliche Produktionsregeln sind: $ &(1) #h(2pt) S -> \a\B \ &(2)#h(2pt) B -> \b \ &(3) #h(2pt) B -> \bC \ &(4) #h(2pt)C -> \a\B $ \ Ableitung von $\a\b\a\b$: $ S ->^((1)) \aB ->^((3)) \a\b\C ->^((4)) \a\b\a\B ->^((2)) \a\b\a\b $ Das Wort wird also von links nach rechts "aufgebaut". Man spricht deswegen auch von einer "*rechts-linearen Grammatik*".
2. $L_2 := {a^n b^n | n in NN^+}$ ist eine *kontextfreie Sprache*, aber nicht regulär. Die Sprache ist nicht mehr regulär, da wir in irgendeiner Form "zählen" müssten, wie viele a's es gibt, bevor die b's beginnen. Das ist mit den Regeln für reguläre Grammatiken nicht möglich. \ Eine mögliche Produktionsregel ist: $ &(1) #h(2pt) S -> \a\S\b | \a\b $ 
3. $L_1 := {a^n b^n c^n | n in NN^+}$ ist eine *kontextsensitive Sprache*, aber nicht kontextfrei. Der Unterschied liegt darin, dass wir auch Terminalsymbole auf die linke Seite der Produktionsregeln packen können. Dadurch können wir die Regel abhängig von der *Umgebung* (also dem Kontext) des Nichtterminalsymbols machen, die Grammatik wird etwas länglich: $ &(1) #h(2pt) S -> \S\A\BC | \a\b\c \ &(2) #h(2pt) \C\A -> \AC \ &(3) #h(2pt) \C\B -> \B\C  \ &(4) #h(2pt) \BA -> \AB \ &(5) #h(2pt) \cA -> \Ac \ &(6) \cB -> \Bc \ &(7) #h(2pt) \bA -> \Ab \ &(8) #h(2pt) \aA -> \aa \ &(9) #h(2pt) \bB -> \bb \ &(10)#h(2pt) \cC -> \cc $ Eine Ableitung des Wortes $\a\a\a\b\b\b\c\c\c$ ist dem geneigten Lesy zur Übung überlassen :).
4. $L_0 := {omega | omega " codiert eine terminierende Turing-Maschine"}$ ist eine *Typ-0-Sprache*, aber keine *kontextsensitive Sprache*. Eine explizite Grammatik für diese Sprache anzugeben ist schwer, deswegen wird an dieser Stelle darauf verzichtet. 

#pagebreak()


= Endliche Automaten

== Deterministische endliche Automaten 
Die Überprüfung, ob ein bestimmtes Wort in einer Sprache liegt haben wir bisher über die direkte Anwendung der Regeln selbst händisch ausprobiert, bzw. anhand der Struktur der Wörter direkt erkannt.

Dieses Vorgehen ist im Allgemeinen - insbesondere bei komplexen Grammatiken bzw. Sprachen - natürlich fehleranfällig und sehr zeitintensiv. Es braucht also eine Möglichkeit das Ganze zu automatisieren. Das Werkzeug der Wahl ist dabei ein sogenannter *deterministischer endlicher Automat (DEA)*. Er prüft, ob eine eingegebene Zeichenkette ein Wort der entsprechenden Sprache ist. 

Ein DEA wird häufig über ein sogenanntes *Zustandsdiagramm* visualisiert:

#align(center)[#image("images/ab.png", width: 50%)]

Dieser Automat akzeptiert alle Wörter der Sprache $L_3 := {(\a\b)^n | n in NN^+}$, der Zustand *$q_0$* ist der *Startzustand*, der Zustand *$q_2$* ein Endzustand. Der Zustand *$q_3$* wird häufig auch *Fallenzsutand* genannt, da der Automat von dort nicht wieder wegkommt, dazu später mehr. 

Formal definiert sich ein Automat wie folgt:

#definition[Ein deterministischer endlicher Automat wird durch die folgenden Angaben festgelegt: 

1. *Q*: eine endliche Menge von *Zuständen* 
2. *$Sigma$*: eine endliche Menge von Eingabesymbolen (unser *Alphabet*!)
3. *$delta$* eine *Zustandsübergangsfunktion*, die angibt, in welchen Folgezustand $q' in Q$ der Automat übergeht, wenn im aktuellen zustand $q in Q$ das Symbol x aus $Sigma$ eingelesen wird, also $delta(q,x) = q'.$
4. *$q_0$*: ein *Anfangszustand*.
5. *F*: eine Menge von *Endzuständen* (final states)

Kurz: DEA = (Q, $Sigma$, $delta$, $q_0$, F)]
#pagebreak(

)
*Beispiel $L_3 := {(\a\b)^n | n in NN^+}$*: 
*Q* $ = {q_0; q_1; q_2; q_3}$
*$Sigma$* $ = {a;b}$
*$delta$*: siehe unten 
*$q_0$* 
*F* $= {q_2}$

Die Zustandsübergangsfunktion wird entweder als Diagramm (wie oben) dargestellt, oder in einer Tabelle, in der für jedes Paar aus Zustand $q$ und Alphabetzeichen $x$ der neue Zustand steht.
#align(center)[
    #table(
        columns:(25pt, 25pt, 25pt), 
        rows: (25pt,25pt,25pt,25pt,25pt), 
        [*$delta$*], [*$a$*], [*$b$*], 
        [*$q_0$*], [$q_1$], [$q_3$], 
        [*$q_1$*], [$q_3$], [$q_2$], 
        [*$q_2$*], [$q_1$], [$q_3$], 
        [*$q_3$*], [$q_3$], [$q_3$]
    )
]


*Überprüfung einer Zeichenkette*:

Möchte man nun überprüfen, ob eine bestimmte Zeichenkette ein Wort der Sprache ist, so beginnt man im Startzustand. Danach werden alle Symbole der Zeichenkette nacheinander eingelesen. Nach jedem Symbol $x$ geht der Automat gemäß der Übergangstabelle vom aktuellen $q$ in den neuen Zustand $q'$ über $delta(q,x) = q'$.

Für das Wort $\a\b\ab$ ergibt sich die folgende Reihenfolge an Zuständen:
$ q_0 ->^(a) q_1 ->^(b)  q_2 ->^(a) q_1 ->^(b) q_2 $


#hinweis[Mit #link("https://flaci.com") kann diese Überprüfung auch automatisiert erfolgen!]
Nach Abarbeitung der Zeichenkette gibt es drei Möglichkeiten:
1. Der Automat stoppt in einem Endzustand - daraus folgt, dass die Zeichenkette #text(green)[zur Sprache]gehört. 
2. Der Automat stoppt in einem Nicht-Endzustand - daraus folgt, dass die Zeichenkette #text(red)[nicht zur Sprache] gehört. 
3. Der Automat stoppt, da die Zeichenkette nicht komplett abgearbeitet werden kann, da es zu einer Kombination aus Zustand $q$ und Symbol $x$ keinen Folgezustand gibt - daraus folgt, dass die Zeichenkette #text(red)[nicht zur Sprache] gehört. 

Der dritte Fall kann nur auftreten, wenn der Automat *nicht vollständig* ist. Den obigen Automaten könnte man alternativ auch so darstellen:

#grid(columns:(50%, 50%), rows:(auto), [#align(center)[#image("images/ab_2.png")]], [#align(center)[
    #table(
        columns:(25pt, 25pt, 25pt), 
        rows: (25pt,25pt,25pt,25pt), 
        [*$delta$*], [*$a$*], [*$b$*], 
        [*$q_0$*], [$q_1$], [], 
        [*$q_1$*], [], [$q_2$], 
        [*$q_2$*], [$q_1$], [], 
    )
]
])
In der ersten Variante diente der Zustand $q_3$ nur dazu, die "losen Enden" aufzusammeln, d.h. alle Eingaben, die zu einer garantiert ungültigen Kombination führen (wenn beispielsweise zwi $a$ direkt nacheinander kommen). Wird so ein *Fallenzustand* benutzt und damit jede mögliche Kombination $(q,x)$ kodiert, so spricht man von einem *vollständigen* Automaten. 

Jeder nicht vollständige Automat kann also leicht zu einem vollständigen Automaten gemacht werden. Der Übersichtlichkeit halber ist aber häufig eine nicht vollständige Angabe zu bevorzugen. 

#hinweis[Ein DEA, der die Worte einer bestimmten Sprache akzeptiert, kann nur gefunden werden, wenn es sich um eine reguläre Sprache handelt!]



#v(0.5cm)
== Exkurs: Nichtdeterministische endliche Automaten 

Der obige Automatentyp war unter Anderen dadurch gekennzeichnet, dass es für jeden Zustand und eine Eingabe immer genau einen Folgezustand gibt. Das muss nicht notwendigerweise so sein. Lässt man mehrere ausgehende Kanten für eine Eingabe aus einem Zustand zu, so spricht man von einem *nichtdeterministischen endlichen Automaten* (NEA), da es nicht mehr exakt festgelegt (determiniert) ist, welcher Zustand als nächstes kommt. In der Übergangstabelle kann es also auch *Mehrfacheinträge* geben. 

Ein Wort wird dann akzeptiert, wenn es *einen möglichen Weg*  gibt, der zu einem Endzustand führt. 

Überraschenderweise ist dieser Ansatz nicht "*mächtiger*" als die deterministischen Automaten, d.h. auch mit NEA's können nur reguläre Sprachen erkannt werden. 

*Beispiel*: die Sprache, die mindestens ein $a$, dann mindestens ein $b$ und am Ende beliebig viele $c$'s enthält, kann mit folgenden Automaten beschrieben werden. 

#align(center)[#image("images/nea.png", width: 75%)]

#pagebreak()

== Übungen und Beispiele 

#task[Geben Sie jeweils einen endlichen (nicht notwendigerweise vollständigen) Automaten an (Zustandsübergangsdiagramm), der die Wörter der Sprache erkennt:
1. Natürliche Zahlen
2. Ganze Zahlen
3. Natürliche, durch 10 teilbare Zahlen (als NEA und als DEA!)
4. a-b-Ketten, die
    - mit mindestens zwei "b" enden.
    - mit genau zwei "b" enden.
    - mindestens einmal "aaa" oder "bbb" enthalten.
    #hinweis[Eine a-b-Kette kann auch 0 a's oder 0 b's enthalten!]
5. Natürliche Zahlen mit Tausenderpunkten
]

Wie immer beginnen die Lösungen auf der nächsten Seite

#pagebreak()

#grid(
    columns: (50%, 50%),
    rows: (auto, auto, auto),
    gutter:5pt,
    [*4b)* #image("images/automatA4_b.png")], [*2)* #image("images/automatA2.png")], [*3-DEA*#image("images/automatA3_1.png")], [*3-NEA* #image("images/automatA3_2.png")], 
    [*4a)* #image("images/automatA4_a.png")], [*1)* #image("images/automatA1.png")], 
)
*5)*
#align(center)[#image("images/automatA5.png")]
#pagebreak()
*4c)*
#align(center)[#image("images/automatA4_c.png", width: 90%)]

#task[Beschreiben Sie umgangssprachlich, welche Zeichenketten der folgende Automat erkennt: #align(center)[#image("images/automatA6.png")]]

#pagebreak()

*Lösung*: Der Automat akzeptiert alle durch drei teilbaren natürlichen Zahlen!

#task[Geben Sie jeweils einen (nicht notwendigerweise vollständigen) endlichen Automaten an, der die folgende Form hat:

#align(center)[\<kette\>\#\<prüf\>] 

wobei:
1. \< kette\> eine beliebig lange, aber nicht leere a-b-Kette ist und \<prüf\> eine 1, falls zuvor ungeradzahlig viele a's enthalten waren. Andernfalls eine $0$.
2. \< kette\> eine beliebig lange, aber nicht leere a-b-Kette ist und \<prüf\> das Format $00, 01, 10$ oder $11$ hat, wobei das zweite Zeichen von der Anzahl der b's abhängt (wiederum 1, falls ungeradzahlig).
]

Die Lösung wie immer auf der nächsten Seite!

#pagebreak()


#align(center)[#image("images/automatA7.png")]
#align(center)[#image("images/automatA8.png")]

*Abschlussaufgabe*

#task[Zeichnen Sie das Zustandsdiagramm eines Automaten, der Datumsangaben der Form TT.MM.JJJJ erkennt, mit folgenden Einschränkungen:

1. Es sollen nur die *Jahreszahlen voon 1900 bis 2099* gültig sein und zudem sollen *alle Monate 31 Tage* haben.
2. Zusätzlich sollen jetzt die Tage den *Monaten angepasst* werden, jedoch hat der Februar immer *29 Tage*.
3. Zusätzlich soll der Februar jetzt *nur* 29 Tage in allen Jahren haben, die Vielfach von 4 sind.
4. Zusätzlich soll nun beachtet werden, dass *1900 kein Schaltjahr* ist!]

#pagebreak()

== Implementierung eines DEA 

Ein Automat kann natürlich nicht nur gezeichnet werden, sondern auch implementiert werden. Wie auch in der 11. Jahrgangsstufe beginnen wir die Implementierung eher "naiv" und arbeiten uns dann voran.

#hinweis[Da der Anteil der Programmierung im 11.-Klassteil des Abiturs bereits recht hoch ist, sind konkrete Fragen zur Implementierung eines DEA nicht häufig, aber dennoch möglich. ]

=== Eine erste Implementierung

Grundsätzlich muss die Repräsentation des Automaten seinen aktuellen *Zustand speichern* und in irgendeiner Form die *Zustandsübergangstabelle* kennen und seinen *Zustand ändern* können, wenn ein Wort überprüft wird. Neben dem Konstruktor bieten sich also folgende Methoden an:


#align(center)[```Java 
boolean testWord(String input)
void switchState(char c)
```]

Um an einem konkreten Beispiel zu arbeiten verwenden wir den Automaten *4b)*, der *a-b-Ketten* erkennt, die mit genau $2$ *b* enden. Zur Erinnerung:

#align(center)[#image("images/automatA4_b.png", width: 60%)]

Wir beginnen mit dem Grundgerüst:

#align(center)[```Java 
public class DEA {
    //Der Zustand kann der Einfachheit halber als Integer codiert werden:
    private int state; 

    //In unserem Fall ist der Startzustand 0 
    public DEA() {
        state = 0;
    }
}
```]


#pagebreak() 

Für die testWord()-Methode können wir die forEach-Struktur in Java verwenden: 


#align(center)[```Java
public boolean testWord(String input) {
    // Der String muss zunächst in ein Array aus Charactern umgewandelt werden
    for(char c : input.toCharArray()) {
        //Diese Methode muss noch implementiert werden!
        switchState(c);
        //Eine Ausgabe-Methode - nicht zwingend nötig, aber nützlich!
        System.out.println("Zeichen " + c + " führt zu: " + state);
    }
    // Nach Abschluss wird überprüft, ob der Automat im Endzustand steht.
    if(state == 2) {
        //Falls ja wird er in den Anfangszustand versetzt...
        state = 0;
        //und zurückgegeben, dass das Wort in der Sprache enthalten ist
        return true;
    }  else {
        //andernfalls wird zurückgegeben, dass dem nicht so it.
        state = 0;
        return false;
    } 
}
```]

Die switchState()-Methode sorgt jetzt dafür, dass der Automat beim Lesen einer bestimmten Eingabe den Zustand (also das Attribut state) entsprechend des obigen Zustandsübergangsdiagramms wechselt. Die *Schwierigkeit* besteht dabei darin, dass die Änderung von zwei verschiedenen Parametern abhängt. Es gibt mehrere Ansätze, diesem Problem zu begegnen.
1. *Geschachtelte if-(else)-Bedingungen*: Beispielsweise kann zuerst abgefragt werden, in welchem Zustand sich der Automat befindet. Anschließend wird in jedem Zweig des if seperat ein weiteres if-else zur Abarbeitung des Zeichens.
2. *Geschachtelte switch-case-Strukturen*: Analog zu 1. kann statt einer if-else-Struktur auch die eingebaute switch-case-Syntax verwendet werden - insbesondere wenn es viele Zustände oder Zeichen gibt ist dies die bessere Variante.
3. *Mischung aus 1. und 2.*: Um beides zu veranschaulichen wird in der folgenden Methode für die Auswahl des Zustands switch-case verwendet und für die Entscheidung über das Zeichen if-else.

#align(center)[```Java
public void switchState(char c) {
    //Die Variable nach der unterschieden werden soll wird ausgewählt - hier state
    switch (state) {
        //Die einzelnen "Fälle" (cases) werden nacheinander abgearbeitet.
        case 0:
            /*Hier genügt ein if-else, da nur zwischen a und b als Eingabe
             unterschieden wird. Der Zustand verändert sich entsprechend.*/ 
            if(c == 'a') {
                state = 0;
            } else {
                state = 1;
            }
            /*break beendet die Ausführung - wird dies vergessen, so werden die 
            übrigen Fälle auch betrachtet - häufiger Fehler!*/
            break;
        //Die restlichen Zustände verlaufen analog

        case 1:
            if(c == 'b') {
                state = 2;
            } else {
                state = 0;
            }
            break;
        case 2:
            if(c == 'a') {
                state = 0;
            } else {
                state = 3;
            }
            break;
        case 3:
            if(c == 'a') {
                state = 0;
            } else {
                state = 3;
            }
            break;
        /*Sollte ein Zustand nicht definiert sein, wird dieser default-case 
        betreten. Hier kann beispielsweise eine Fehlerbehandlung erfolgen.*/
        default:
            break;
    }
```]

Diese Implementierung reicht bereits aus! Ein kurzer Test zeigt, dass der Automat korrekte Ausgaben macht: 

#align(center)[```Java
public static void main(String[] args) {
    DEA dea = new DEA();
    System.out.println( dea.testWord("aabb"));
    System.out.println(dea.testWord("abba"));
    System.out.println(dea.testWord("aaaabbbbcaa"));
}
```]

liefert "true, false, false" (mit den weiteren Ausgaben von oben dazwischen).

Diese Implementierung hat allerdings offensichtliche Schwächen, z.B.:

1. Wenn in einem Wort "unerlaubte Zeichen" auftreten (das c im dritten Test), so wird dieses einfach übergangen.
2. Es wird nur ein einziger Automat definiert. Um eine andere Sprache erkennen zu können, müsste alles noch einmal neu geschrieben werden.

Die Zustände und die Übergänge sollten idealerweise also "von außen" definiert werden können. Dazu ist die switch-case Struktur nicht geeignet, deswegen verwenden wir stattdessen eine *HashMap*.

#pagebreak()

=== Exkurs - Implementierung mit Hilfe einer HashMap

Das Folgende geht wieder weit über den Schulstoff hinaus und ist nur als Anregung zu verstehen. 

Um die obigen Probleme lösen zu können, darf der Zustand nicht direkt über den Code geändert werden - die Informationen über den Zustandswechsel und der Quellcode müssen separiert werden. 

Es gibt selbstverständlich viele Ansätze, wie dies gelingen kann, eine (bzw. zwei) bieten sich aber besonders an und orientieren sich an der mathematischen Definition der *Zustandsübergangsfunktion $delta$*, zur Erinnerung:

$ delta(q,c)  = q' $
wobei $q$ und $q'$ Zustände sind und $c$ ein bestimmtes Zeichen (bei uns jetzt: char in Java!)

Es wird also eine Funktion genutzt, die *zwei* Eingabeparametern genau *ein* Ergebnis zuordnen. Es handelt sich hier allerdings um eine sogenannte *diskrete* Funktion (im Gegensatz zu den kontinuierlichen Funktionen, die üblicherweise in der Mathematik betrachtet werden, also z.B. $f: x |-> x^2$ mit $x in RR$, die keine "Lücken" haben).

Wir kennen bereits zwei Datenstrukturen, die eine solche Zuordnung möglich machen würden, beide sind vernünftig einsetzbar:

1. Ein *2D-Array*: besonders effizient, wenn es ein vollständiger Automat ist.
2. Eine *HashMap*: die bessere Wahl, wenn der Automat nicht vollständig ist. Wenn es vorher nicht bekannt ist also im Schnitt also besser. 

In beiden Fällen haben wir noch ein Problem: Java erlaubt es nicht, dass ein Tupel von Objekten einen Schlüssel für z.B. die HashMap oder einen Eintrag für ein Array bilden (Python z.B. erlaubt das!).

Um die Zuordnung also nutzen zu können, müssen wir noch eine "Dummy-Klasse" schreiben, die die beiden Informationen verknüpft (und nicht vergessen equals() und die hashCode()-Methode zu überschreiben, um Vergleiche und das Hashen für die HashMap möglich zu machen.)

Um sicherzustellen, dass bei den Zuständen keine falschen Zeichenketten auftauchen, kann wieder ein Enum verwendet werden, z.B.:

#align(center)[```Java
public enum State {
    Q0, Q1, Q2, Q3, Q4,
    Q5, Q6, Q7, Q8, Q9,
    Q10, Q11, Q12, Q13, Q14,
    Q15, Q16, Q17, Q18, Q19
}
```]

Damit wird natürlich der Zustandsvorrat auf 20 Zustände limitiert, aber das ist aktuell eine nebensächliche Einschränkung. Zurück zur zweiten Hilfsklasse, Pair:

#align(center)[```Java
public class Pair {
    public State state;
    public char c;

    //Sowohl die Information zum Zustand als auch zum Character werden gespeichert
    public Pair(State state, Character c) {
        this.state = state;
        this.c = c;
    }

    //Die überschriebene equals-Methode wurde schon im Listenskript behandelt
    @Override
    public boolean equals(Object o) {
        if(this == o) {
            return true;
        }
        if(!(o instanceof Pair)) {
            return false;
        }
        Pair p = (Pair) o;
        if(p.state == this.state && p.c == this.c) {
            return true;
        }
        return false;
    }
    /*Die hashCode-Funktion muss überschrieben werden, um unser Pair als 
    Schlüssel in der HashMap verwenden zu können. Wir verwenden einfach
    die Java-interne Hash-Funktion dafür.*/
    @Override
    public int hashCode() {
        return Objects.hash(state, c);
    }
}
```]

Der Rohbau hat jetzt mehr Zustände, da sowohl der Startzustand, der aktuelle Zustand, die HashMap als auch die Endzustände gespeichert und gesetzt werden müssen:

#align(center)[```Java
public class DEA {
    private State state;
    private State[] finalStates;
    private HashMap<Pair, State> stateMap = new HashMap<Pair, State>();
    private State startState;

    public void reset(State startState, HashMap<Pair, State> map, State[] finalStates) {
        this.startState = startState;
        state = startState;
        stateMap = map;
        this.finalStates = finalStates;
    }
}
```]

Die _testWord()_-Methode sieht vom Grundaufbau her ähnlich aus, die _switchState()_-Methode entfällt jedoch, da dafür direkt die HashMap verwendet werden kann. Wir entnehmen mit der aktuellen Kombination aus Zustand und zu verarbeitendem Character den nächsten Zustand aus der HashMap und setzen damit den aktuellen Zustand neu.

Das Entnehmen liefert allerdings standardmäßig null zurück, sollte der Eintrag nicht in der HashMap sein, deswegen wird bei einem "falschen" Zeichen, das nicht im Alphabet enthalten ist, der aktuelle Zustand auf null gesetzt. 

#pagebreak()

#align(center)[```Java
public boolean testWord(String input) {
    //Hilfs-Ausgabemethode
    System.out.println("Start bei Zustand " + state);
    //Analog zur ersten Implementierung 
    for(char c : input.toCharArray()) {
        /*Der Zustand wird neu gesetzt, mit "get" erhält man 
        den Eintrag in der HashMap*/
        state = stateMap.get(new Pair(state, c));
        //Falls das aktuelle Paar nicht bekannt ist, wird null zurückgegeben
        if(state == null) {
            return false;
        }
        System.out.println("Zeichen " + c + " führt zu: " + state);
    }
    if(Arrays.asList(finalStates).contains(state)) {
        state = startState;
        return true;
    } else {
        state = startState;
        return false;
    }
}
```]

Damit ist die Implementierung schon abgeschlossen! Der Nachteil ist natürlich, dass damit die "Arbeit" des Automaten-Erstellens auf den Nutzer abgeschoben wird, die Testmethode ist dementsprechend länger:

#align(center)[```Java
public static void main(String[] args) {
    State startState = State.Q0;
    State[] finalStates = {State.Q2};
    HashMap<Pair,State> testMap = new HashMap<Pair, State>();
    //Es müssen alle Einträge der Zustandsübergangstabelle  angegeben werden!
    testMap.put(new Pair(State.Q0, 'a'), State.Q0);
    testMap.put(new Pair(State.Q0, 'b'), State.Q1);
    testMap.put(new Pair(State.Q1, 'a'), State.Q0);
    testMap.put(new Pair(State.Q1, 'b'), State.Q2);
    testMap.put(new Pair(State.Q2, 'a'), State.Q0);
    testMap.put(new Pair(State.Q2, 'b'), State.Q3);
    testMap.put(new Pair(State.Q3, 'a'), State.Q0);
    testMap.put(new Pair(State.Q3, 'b'), State.Q3);
    System.out.println(testMap.get(new Pair(State.Q0, 'b')));
    DEA dea = new DEA();
    dea.reset(startState, testMap, finalStates);
    System.out.println(dea.testWord("aabb"));
    System.out.println(dea.testWord("aabba"));
    System.out.println(dea.testWord("aabbcc"));
}

```]

Der logische nächste Schritt wäre nun also, ein Format zu finden, in dem der Automat schneller angegeben werden kann und dann einen Konverter zu schreiben, der diesen Prozess oben automatisiert - das überlasse ich aber dem geneigten Lesy zur Übung. Flaci z.B. kann in ein JSON-Format exportieren.

#pagebreak()



#bibliography("bib.yml")

