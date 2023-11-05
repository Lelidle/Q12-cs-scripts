#import "template.typ": *
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#show: setup
#set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
#set heading (
    numbering: "1."
)



#let hm = h(1mm)

#v(1fr)
#align(center)[#text(32pt)[Netzwerkkommunikation \  #align(center)[#image("images/art.png", width: 80%)] ] \ Stable Diffusion Art "Networks"]
#v(1fr)

#pagebreak()
#outline(title: "Inhaltsverzeichnis", indent: auto)

#pagebreak()

#set page(
    header: align(right)[
        Kommunikation und Synchronisation Skript 2inf1 \
  ],
  numbering: "1"
)


= Historisches

Das *Internet* entstand primär aus dem 1969 entwickelten ARPANET (Advanced Research Project Agency Networkt) Projekt an dem vier US-Amerikanische Universitäten beteiligt waren, deren Ziel die weitläufige Vernetzung von Rechnern zur gemeinsamen Nutzung von Ressourcen war. Die Idee größere Netzwerke aufzubauen stammte dabei schon aus den Anfängen der 1960er Jahre und viele Gruppen forschten und arbeiteten daran (z.B. auch das US Militär). Dieses Projekt war auch eines der ersten, die das *TCP/IP* Protokoll implementiert haben (#link("https://www.ietf.org/rfc/rfc9293.html")[RFC 9293] - der aktuelle Standard).

In der Folge wurden vor allem weitere Universitäten in Europa und den USA in Netzwerken miteinander verknüpft bis die Technologie so weit ausgereift war, dass es zu einer regelrechten Explosion kam, die dazu führte, dass die meisten technischen Geräte heute miteinander *physikalisch* verbunden sind.

Das *World Wide Web* ist in den 80er Jahren am CERN (Conseil européen pour la recherche nucléaire) entwickelt werden und _nicht_ synonym zum Internet zu verstehen. Spricht man vom Internet, dann ist primär die physikalische Verbindung, d.h. die Hardware der Netzwerke gemeint. Das WWW ist jedoch ein Dienst, d.h. eine Software. Die Grundlage bilden dabei aufeinander verweisende Hypertext-Dokumente, die auf verschiedensten Rechnern abgespeichert sind. Das WWW benutzt also das Internet als Medium, ist jedoch nur einer von vielen Diensten, die das tun. Weitere Beispiele für Dienste sind *E-Mails*, *FTP* (File Transfer Protocol), *HTTP* (Hyper-Text-Transfer-Protocol) oder das *XMPP* (Extensible Messaging and Presence Protocol - für Chat-Anwendungen).

Im Abitur spielt die Netzwerktechnik nur eine sehr untergeordnete Rolle. Dieses Skript ist deswegen deutlich ausführlicher, als es sein müsste, um dennoch einen groben Überblick über die Zusammenhänge zu geben. Im Anhang finden sich einige Abituraufgaben der letzten Jahre.

#pagebreak()

= Wiederholung Bits, Bytes und Hex

In der Informatik werden andere *Stellenwertsysteme* als in der schulüblichen Mathematik verwendet. Während dort das Zehnersystem Einzug gehalten hat ist für Computer das Zweiersystem geeignet (Strom an, Strom aus!).

Das bedeutet konkret: Statt in Zehnerpotenzen zu denken und daraus die Zahlen "zusammenzubauen" wie in der fünften Klasse (z.B. $12985 = 10000 + 2000 + 900 + 80 + 5$) werden *Binärzahlen* aus *Zweierpotenzen* zusammengebaut.

Das erscheint uns auf den ersten Blick merkwürdig - das liegt letztendlich aber nur an der Gewöhnung an das Zehnersystem.
#align(center)[
#tablex(columns: 10, rows: 2, align: center,
colspanx(10)[*Zweierpotenzen für die Umrechnung*],[512],[256],[128],[64],[32],[16],[8],[4],[2],[1]
)]

Wollen wir eine Zahl im Binärsystem darstellen, so sucht man immer die größte Zweierpotenz, die gerade noch in den zu füllenden "Rest" der Zahl hineinpasst und markiert in der Stellenwerttafel dort eine $1$.

Wollen wir beispielsweise $147$ in Binärdarstellung beginnen wir bei $128 = 2^7$. Damit wissen wir auch, dass die Binärzahl $8$ Zeichen lang ist (wir beginnen bei $2^0=1$!):
$ 1000#hm 0000 $
(Das wäre jetzt nur 128!). Als nächstes betrachten wir den Rest, also $147 - 128 = 19$ Die größte Zweierpotenz, die noch passt ist $16 = 2^4$. Es folgt also eine 1 an fünfter Stelle:
$ 1001#hm 0000 $
Es bleiben $3$, also $2 = 2^1$:
$ 1001#hm 0010 $
Und zuletzt bleibt eine $1 = 2^0$
$ 1001#hm 0011 $
Oder im Zehnersystem ausgeschrieben:
$ 1 dot 128 + 0 dot 64 + 0 dot 32 + 1 dot 16 + 0 dot 8 + 0 dot 4 + 1 dot 2 + 1 dot 1 = 147 $
#hinweis[Die Abstände nach den Viererblöcken wurde nur der besseren Lesbarkeit wegen eingefügt!]
* Weitere Beispiele*
- Binär: $0111#hm 1010$ lässt sich dezimal schreiben als: $ 0 dot 128 + 1 dot 64 + 1 dot 32 + 1 dot 16 + 1 dot 8 + 0 dot 4 + 1 dot 2 +0 dot 1 = 122 $

- Dezimal: $195$ lässt sich umwandeln zu: $ 195 =  1 dot 128 + 1 dot 64 + 0 dot 32 + 0 dot 16 + 0 dot 8 + 0 dot 4 + 1 dot 2 + 1 dot 1 $ und entspricht somit in Binärdarstellung als $1100#hm 0011$

Beschränkt man sich auf Zahlen, die durch 8 Bit (also 1 Byte!) dargestellt werden, dann ist der Zahlenraum also auf die Zahlen von 0 bis 255 beschränkt, da 255 binär $1111#hm 1111$ entspricht.

#hinweis[Ist eine Zahl binär codiert wird häufig die Zeichenkette $0b$ vorangestellt, um zu zeigen, dass es sich um eine Binärzahl handelt, $0\b1011$ ist somit gleichbedeutend mit der Binärzahl $1011$]

<AufgabeBinär>
#task[Wandeln Sie jeweils in Binär bzw. Dezimaldarstellung um.
- $253$
- $1110#h(1mm)0111$
- $187$
- $1011$
- $11#h(1mm)0101#h(1mm)1011$
#link(<LösungBinär>)[Zur Lösung]
]
#v(1cm)

*Hexadezimale Darstellung von Zahlen*

Große 0-1 Folgen sind für Menschen schwer zu lesen. Zum Test - welcher Dezimalzahl entspricht die folgende Binärzahl? $ 01010001101011110000110011101000 $

Es ist natürlich $1370426600$! Um solche $0-1$-Folgen lesbarer zu machen wird häufig die *hexadezimale* Darstellung von Zahlen verwendet, diese verwendet nicht das Zweiersystem, sondern das "Sechzehnersystem". Da wir mit vier Stelle einer Binärzahl gerade 16 Zahlen darstellen können, teilen wir also die obige Zahl in Viererblöcke ein:
$ 0101 #hm 0001 #hm 1010 #hm 1111 #hm 0000 #hm 1100  #hm 1110 hm 1000 $
Jeder dieser Viererblöcke entspricht jetzt einer "Ziffer" im Sechzehnersystem. Da es zu Uneindeutigkeiten kommen würde, wenn man "10" als Ziffer verwendet (Dieses Problem hatte man beim Zweiersystem natürlich nicht) müssen andere Zeichen als "Ziffern" verwendet werden. Man hat sich hier auf die Zeichen a bis f geeinigt, es gilt also:

#table(rows:(auto, auto, auto, auto), columns:(1fr, )*4, inset: 8pt,align: center,
[$(0000)_2 = (0)_16$], [$(0001)_2 = (1)_16$], [$(0010)_2 = (2)_16$], [$(0011)_2 = (3)_16$],[$(0100)_2 = (4)_16$],[$(0101)_2 = (5)_16$],[$(0110)_2 = (6)_16$],[$(0111)_2 = (7)_16$],[$(1000)_2 = (8)_16$],[$(1001)_2 = (9)_16$],[$(1010)_2 = (a)_16$],[$(1011)_2 = (b)_16$],[$(1100)_2 = (c)_16$],[$(1101)_2 = (d)_16$],[$(1110)_2 = (e)_16$],[$(1111)_2 = (f)_16$]
)

Die Klammern zeigen dabei an, wie die Zeichen innerhalb interpretiert werden sollen (das hätte man auch schon bei der Umwandlung vom Binär- ins Dezimalsystem machen können, dort ist die Mehrdeutigkeit aber nicht so dramatisch.)

Die obige Binärzahl enspricht also der folgenden Hex-Zahl:
$ 5 #hm 1 #hm a #hm f #hm 0 #hm c #hm e #hm 8 $

Häufig gruppiert man diese noch zu Zweierpaketen, dann entspricht eine dieser Hex-Gruppen genau einem Byte ($2 dot 4$ Bit!)
$ 51 #hm \af #hm 0c #hm \e8 $

Nochmal veranschaulicht:

$ #text(red)[5]#text(yellow)[1] #hm #text(green)[a]#text(blue)[f] #hm #text(purple)[0]#text(orange)[c] #hm #text(olive)[e]#text(fuchsia)[8] $

$ #text(red)[0101]#hm #text(yellow)[0001] #hm #text(green)[1010]#hm #text(blue)[1111] #hm #text(purple)[0000]#hm #text(orange)[1100] #hm #text(olive)[1110]#hm #text(fuchsia)[1000] $

#hinweis[Ähnlich wie bei der Binärdarstellung wird bei der Hexadezimalen Darstellung häufig die Zeichenkette $0x$ vornangestellt. $0x\f\f11$ ist also die Hexadezimalzahl $\f\f11$]

<AufgabeHexa>
#task[Wandeln Sie jeweils von Binär- in Hexadezimaldarstellung oder umgekehrt um:
- $0110 #hm 0111$
- $\ff #hm \af$
- $1010 #hm 1100 #hm 0001 #hm 1001$
- $0e #hm \c1 #hm 10$
#link(<LösungHexa>)[Zur Lösung]
]
#pagebreak()

== Protokolle

Damit Kommunikation sinnvoll ablaufen kann müssen die "Spielregeln" der Kommunikation eindeutig festgelegt werden, sei es die Wahl der Sprache, das gewählte Kommunikationsmedium oder auch nur die beteiligten Personen bzw. Entitäten. Die Vereinbarungen für die technische Kommunikation sind in *Protokollen* festgehalten.

#hinweis[Dieser Protokollbegriff ist nicht nur auf die Informatik begrenzt, es gibt beispielsweise auch *diplomatische Protokolle*, die den Ablauf von Staatsbesuchen regeln.]

Wir wollen im Folgenden dies unter einem Protokoll verstehen:

#definition[Ein *Protokoll* ist ein Satz von Regeln und Richtlinien für den Austausch von Daten bzw. Informationen zwischen zwei Parteien.

Ein *Netzwerkprotokoll* ist dann ein Kommunikationsprotokoll für den Austausch von Daten zwischen Computern bzw. Prozessen.
]

Es gibt immens viele Protokolle in der technischen Welt, neben den oben bereits erwähnten ließe sich noch eine viel längere Liste ergänzen: *DHCP, DNS, HTTPS, TCP, UDP, IP, SMTP, POP3, IMAP, etc.*

= Das OSI-Modell

Schlägt man ein beliebiges Buch oder einen Text zur Netwerkprogrammierung auf, so ist die Wahrscheinlichkeit auf das OSI-(open Systems Interconnection) Modell zu stoßen sehr groß. Wir werden es zunächst in seiner vollen Pracht bewundern, dann auf das für die Schule notwendige herunterbrechen und zuletzt einen Schnelldurchlauf durch die verschiedenen Schichten des Modells absolvieren.

#let cell = rect.with(
  inset: 8pt,
  fill: rgb("e4e5ea"),
  width: 100%,
  radius: 6pt
)

#grid(columns:(30%, 70%), rows:(auto,)*7, gutter: 6pt,
cell(fill: rgb(255, 102, 0))[*Anwendungsschicht*], cell(fill: rgb(255, 102, 0))[Alle anwendungsspezifischen Protokolle],
cell(fill: rgb(255, 102, 0))[*Darstellungsschicht*], cell(fill: rgb(255, 102, 0))[Syntax und Semantik der Daten wird geprüft, ggf. Codierung und Datenkompression],
cell(fill: rgb(255, 102, 0))[*Sitzugsschicht*], cell(fill: rgb(255, 102, 0))[Zuständig für Synchronisation, wenn die Benutzer eine gemeinsame Sitzung aufbauen, nur verbindungsorientiert.],
cell(fill: rgb(0, 128, 255))[*Transportschicht*], cell(fill:rgb(0, 128, 255))[Zuständig für die Port-Adressierung, hier kommunizieren zwei Prozesse. Unterteilt den Bitstrom der Sitzung in größere Pakete, Kanal oder Broadcast.],
cell(fill: rgb(251, 255, 0))[*Vermittlungsschicht*], cell(fill: rgb(251, 255, 0))[Zuständig für die IP-Adressierung, Routenwahl, Steuerung bei Staus, Verknüpfung von Teilnetzen.],
cell(fill: rgb(240, 0, 0))[*Sicherungsschicht*], cell(fill:rgb(240, 0, 0))[Zuständig für die Zugriffskontrolle zum Medium, das Verpacken der Daten in Einheiten.],
cell(fill: rgb(240, 0, 0))[*Bitübertragungsschicht*], cell(fill: rgb(240, 0, 0))[Zuständig für die Definition der physikalischen Signale, Anschlüsse, Steuerung der Leitungsaufteilung]
)

Die Farbgebung in obiger Tabelle soll bereits andeuten, dass einige der Schichten für unsere Zwecke zusammenfassbar sind. Wir beschäftigen uns nur mit der:

1. #text(rgb(240, 0, 0))[*Übertragungssschicht*]: Im OSI-Modell die Sicherungs- und Bitübertragungssschicht - hier geht es um die tatsächliche physikalische Verbindung zwischen den Computern bzw. Netzwerken.
2. #text(rgb(255, 200, 0))[*Vermittlungsschicht*]: s.o.
3. #text(rgb(0, 128, 255))[*Transportschicht*]: s.o.
4. #text(rgb(255, 102, 0))[*Anwendungsschicht*]: Hier unterscheiden wir nicht im Detail wie im OSI-Modell, sondern fassen die entsprechenden anwendungsorientierten Aufgaben in einer Schicht zusammen.

Im Abitur beziehen sich fast alle Aufgaben, die nur Netzwerktechnik gestellt werden auf ein Schichtenmodell. Dabei wird allerdings eher selten ein technisches Modell gewählt, sondern eine Analogie (wie das diplomatische Protokoll oben).

Aus diesem Grund folgt hier ein nicht-technisches Beispiel für ein Schichtenmodell, das den Versand eines Pakets von unserem Schulleiter zum Schulleiter des Albert-Einstein-Gymnasiums in München modelliert:

#align(center)[
#image("images/paketversand.png")
]
Die durchgezogenen Pfeile zeigen dabei den physikalischen Datenfluss (hier rot), d.h. in diesem Beispiel das Paket, das durch die verschiedenen Stationen wandert.

#hinweis[Hier haben wir schon den ersten "Pferdefuß" der Analogie, wir werden sehen, dass im technischen Modell die Daten _nicht_ in diesem Sinne durch alle Schichten wandern.]

Für uns interessant sind aber die weiteren Ebenen. Denn auch hier findet Kommunikation statt, die indirekt in den physischen Daten mit eingebettet sind. Das könnte beispielsweise so aussehen:

#align(center)[
#image("images/paketversand_2.png")
]

1. Der Schulleiter wird in aller Regel ein persönliches Anschreiben beigelegt haben, das von seinem Kollegen gelesen wird.
2. Das Sekretariat des WGG muss das Paket addressieren, damit es einerseits von der Post korrekt zugestellt werden kann, andererseits gehen Pakete an Schulen zunächst im Sekretariat ein, d.h. die Weiterleitung an den Schulleiter geschieht durch das Sekretariat des AEG.
3. Die Postfiliale Neumarkt muss das Paket korrekt ettiketieren, damit die Weiterleitung nach München korrekt funktioniert.

Man kann jetzt eine (gewisse) Analogie zwischen diesem Schichtenmodell beim Postversand und der Kommunikation zwischen zwei Computern ziehen.

#align(center)[
#image("images/paketversand_3.png")
]

#pagebreak()
Noch einmal zusammengefasst:

#let cell50 = rect.with(
  height: 50pt,
  inset: 8pt,
  fill: rgb("e4e5ea"),
  width: 100%,
  radius: 6pt
)

#v(2mm)
#grid(rows: (auto,)*5, columns: (20%, 30%, 50%), gutter: 10pt,  cell[*Schicht*],  cell[*Post*], cell[*Netzwerk*],
cell50[ \ *Anwendung*],cell50[Informationsaustausch Schulleiter],cell50[anwendungsspezifische Interpretation der übertragenen Daten, Syntaxüberprüfung, ggf. Codierung oder Kompression der Daten],
cell50[ \ *Transport*],cell50[Senden und Empfangen, Adressierung],cell50[Zuverlässiges Senden und Empfangen, Überprüfung auf Vollständigkeit, Unterteilung in Datenpakete, Weitergabe an die richtige Anwendung],
cell50[\ *Vermittlung*], cell50[Weitervermittlung und Wegewahl (Routing)], cell50[Routing innerhalb des Netzwerks, Steuerung bei Staus, Verbindung zu anderen Teilnetzen],
cell50[\ *Übertragung* ], cell50[physikalischer Transport (zumindest den Hauptteil des Weges) des Paketes.], cell50[physikalischer Transport der Daten, Definition der physikalischen Signale, Aufteilung der Leitung, Übergabe der Daten an die Leitung],
)

Es stellt sich die Frage, warum man den Aufwand der Betrachtung der Schichten überhaupt betreibt. Einige Vorteile ergeben sich dadurch offensichtlich:

1. Jede Schicht hat ihre spezielle Aufgabe und agiert *unabhängig* von den anderen Schichten. Die Protokolle der einzelnen Schichten bauen zwar aufeinander auf, können aber dennoch unabhängig voneinander weiterentwickelt werden.
2. Die *Komplexität* der einzelnen Module ist durch die Aufteilung reduziert.
3. Höhere *Flexibilität* für Austausch von Modulen.
4. Leichtere *Handhabbarkeit* durch einfache und sauber definierte Schnittstellen zwischen den Schichten.

Merkt man sich die obigen Fakten ohne weitere Details, so kommt man bei Abituraufgaben schon relativ weit, ein Beispiel aus dem Abitur von 2022, in diesem Fall sogar ein technisches Beispiel:

#align(center)[
#image("images/abi2022.png")
]

#pagebreak()

= Übertragungsschicht

Die unterste Schicht beschäftigt sich, wie bereits erwähnt, mit der physikalischen Übertragung der Daten und ist für uns nur von geringem Interesse. Nur ein Aspekt ist von Relevanz:

== Topologie von Rechnernetzen


Geräte können auf verschiedene Arten miteinander verbunden werden, die jeweils verschiedene Vor- und Nachteile haben. Man spricht bei einer "Verbundart" auch von einer *Topologie*.

Im Folgenden werden die einzelnen Topologien jeweils nach den folgenden Kritierien untersucht bzw. bewertet:
1. *Störanfälligkeit*: Wie wirkt sich der Ausfall eines Rechners oder einer Verbindung aus.
2. *Systempflege*: Wie groß ist der Aufwand bei der Fehlersuche oder beim Erweitern.
3. *Kosten*: Wie hoch sind die Kosten für Leitungen oder spezielle Komponenten vergleichsweise.
4. *Übertragungsrate*: hierunter fällt auch die Frage nach möglichen Kollissionen.

*Stern-Topologie*

In der "realen Welt" ist diese Topologie die vorherrschende. Der Name ist im Wesentlichen selbsterklärend, es gibt es einen zentralen Rechner, der in der Mitte sitzt, die anderen werden "sternförmig" darum angeordnet. Das ist natürlich nur eine idealisierte netzwerktechnische Darstellung und stellt nicht notwendigerweise die tatächliche räumliche Positionierung dar.
#align(center)[
#image("images/stern_topologie.png", width:50%)
]
Analyse:
1. Der Ausfall des Zentralrechners ist problematisch, der Ausfall aller anderen Rechner dagegen nicht relevant.
2. Sowohl die Fehlersuche als auch die Erweiterung sind problemlos möglich.
3. Der Zentralrechner muss hochwertig sein.
4. Die Übertragungsrate kann, je nach Zentralrechner und Anzahl der Geräte insgesamt sein. Kollisionen können durch eine Steuerung des Zentralrechners aber vermieden werden.

*Bus-Topologie*

Hier sind alle Geräte mit einer zentral verlaufenden Leitung (Bus) verbunden, es gibt in diesem Sinne keine "zentrale" Stelle.


#grid(rows: auto, columns:(50%, 50%),
[#align(center)[
#image("images/bus_topologie.png", width:80%)
\ Bus - Topologie] ], [#align(center)[
#image("images/token_bus_topologie.png", width: 80%)
\ Token  -Bus Topologie] ])

1. Der Ausfall des Bus ist problematisch, der Ausfall von Rechnern dagegen nicht.
2. Sowohl die Fehlersuche als auch die Erweiterung sind problemlos möglich.
3. Der Bus muss eine hohe Bandbreite besitzen, ansonsten gibt es keine teuren Komponenten.
4. Die Übertragungsrate hängt (quasi) alleine vom Bus ab. Bei hoher Last lassen sich Kollissionen nicht direkt vermeiden. Es kann der Ansatz eines sogenannten *Token Bus* verwendet werden - dann kann nur derjenige, der gerade den Token hat Informationen senden.

*Ring-Topologie*

Auch hier ist der Name wieder selbsterklärend.

#grid(rows: auto, columns:(50%, 50%),
[#align(center)[
#image("images/ring_topologie.png", width:80%)
\ Ring - Topologie] ], [#align(center)[
#image("images/token_ring_topologie.png", width: 80%)
\ Token - Ring Topologie] ])

1. Der Ausfall jedes Geräts unterbricht den Ring, führt aber nicht zu einem Totalausfall des Netzes.
2. Der Aufwand bei einer Fehler ist hoch, die Erweiterung geringfügig umständlicher als bei den vorherigen Topologien.
3. Es gibt keine besonders teuren Komponenten.
4. Die Übertragungsrate hängt von der Anzahl der Rechner ab. Kollisionen können analog zum Bus bei hoher Last auftreten und wiederum durch Verwendung eines Token-Rings vermieden werden.

*Direkte Verbindungen (Peer to Peer)*

Bei dieser Bauart ist jeder Rechner mit jedem anderen verbunden.

#align(center)[
#image("images/direkt_topologie.png", width:50%)
]

1. Der Ausfall jedes Geräts ist unproblematisch.
2. Der Aufwand bei der Fehlersuche ist gering, das erweitern dagegen sehr aufwändig.
3. Keine teuren Komponenten, aber sehr viele Leitungen nötig $(~ n^2)$ mit $n$ der Anzahl der Rechner.
4. Die Übertragungsrate ist sehr hoch, Kollisionen sind dagegen selten.

*Kombinationen*

Natürlich sind auch Kombinationen verschiedener Arten von Rechnernetzen möglich!



== Ethernet-Protokoll

Auf diesem Level spielt bereits das *Ethernet*-Protokoll eine Rolle, dass auch den meisten nicht-technisch versierten Personen ein Begriff ist. Es ist ein Standard für die Kommunikation in kabelgebundenen Netzwerken (LAN).

Bei diesem Verweis soll es an dieser Stelle bleiben, für die Interessierten findet sich als Ausgangspunkt für weitere Recherchen ein Ethernet II frame (d.h. der Aufbau eines Ethernet-Protokoll-Datenpakets):

#align(center)[#image("/images/ethernet_frame.png")]

= Vermittlungsschicht

Es ist natürlich nicht ausreichend, dass physikalische Leitungen vorhanden sind. Datenpakete müssen auch den Weg durch das Netzwerk finden, um zum entsprechenden Ziel zu kommen, hier kommen Begriffe wie die *IP-Adresse*, *Routing* und entsprechende Geräte wie der *Router* ins Spiel.

== IP-Adressen

*IP(v4)* ist die erste Version des Internet Protocols, das weltweit verbreitet und eingesetzt wurde. Eine solche IP-Adresse besteht aus einer 32-stelligen Binärzahl, die jeweils einem Netzwerkadapters im Internet zugeordnet ist und so eine Identifizierung möglich macht, da sie im betreffenden Netwerk eindeutig ist. Netwerken von z.B. Providern wird dann ein ganzer Block an Adressen zugeordnet (siehe unten).

#hinweis[*Für die Experten*: streng genommen erlaubt die Netzwerkadressübersetzung (NAT), dass Ip-Adressbereiche mehrfach verwendet werden, da sie "nach außen" hin nur mit der IP-Adresse des Zugangsgeräts (also des Routers) identifiziert werden. Global gesehen ist also auch ein Netzwerkadapter nicht eindeutig mit einer IP-Adresse verknüpft, sondern mit seiner sogenannten *MAC-Adresse* (Media-Access-Contro-Address, auch *physische Adresse*) - also die Nummer, die diesem Netzwerkadapter als Identifikator dient.]

Zur besseren Lesbarkeit wird die Adresse üblicherweise in vier 8-stellige Blöcke aufgeteilt und (für den Menschen) dann in Dezimalschreibweise abgebildet werden - jeweils durch einen Punkt getrennt.

*Beispiel*

$ 01101100001000010000111100110111 $
$ 01101100#hm 00100001#hm 00001111#hm 00110111 $
$ 108 . 33 . 15 . 55 $

#task(customTitle: "Kurze Denkaufgabe!")[Wie viele solcher IP-Adressen können gebildet werden?]

Es sind natürlich $2^(32)$, also etwa $4,3$ Millarden Adressen.

<AufgabeIP>
#task[Wandeln Sie jeweils von Binär- in Dezimaldarstellung oder umgekehrt um:
- $88.215.213.26$
- $0101#hm 1000 #hm 0110 #hm 0011 #hm 0011 #hm 1111 #hm 1001 #hm 0011 $
#link(<LösungIP>)[Zur Lösung]
]

*IP(v6)* Da die Anzahl der möglichen IPv4-Adressen doch recht klein ist im Vergleich zu der Anzahl an Geräten und Netwerken wurde ein neuer Standard entwickelt. Die Adressen in diesem Standard sind $128$ Bit lang, somit gibt es $2^(128)$ unterschiedliche IPv6-Adressen.

Hier kommt auch die hexadezimale Darstellung ins Spiel, denn die Größe der Zahlen macht es sonst wieder unlesbar. Die Adresse wird also in 8 Blöcke zu je 16 Bit eingeteilt, die wiederum hexadezimal kodiert werden, a.so z.B.:

$ 2600:1\f18:001f:\d\b00:807b:\f1\f4:\d01b:30\b1 $

#hinweis[Ob dieses Format wirklich lesbarer ist oder wirklich sein muss sei einmal dahingestellt..]

Die Tatsache, dass IPv6 Adressen noch nicht "der Standard" ist liegt an zweierlei:
1. Es gab andere technische "Tricks", mit denen die Limitierung von IPv4 abgefedert wurde.
2. Es braucht Zeit, bis sich Dinge durchsetzen, die neu sind. (Es sei nochmal darauf hingewiesen, dass in vielen Betrieben Java 8 der Standard ist z.B.)

== Adressvergabe

IP-Adressblöcke werden an Unternehmen und Organisationen vergegeben, die diese ihrerseits wieder verteilen können.

*Vergebene Adressblöcke*:Findet man z.B. #link("https://ftp.ripe.net/ripe/stats/membership/alloclist.txt")[hier]

Die Einträge sind dabei folgendermaßen zu lesen: *$84.39.64.0\/19$*

Die Zahl 19 bedeutet hier: Für alle Adressen aus dem Adressblock gilt, dass die ersten 19 Bit fest vorgegeben sind (der sogenannte "Netz Anteil") und die restlichen Stellen (also der Anteil des Hosts) verwendet werden kann, d.h. die rot markierten Stellen sind fix:

$ 84.39.64.0 = #text(red)[xxxx #hm xxxx . xxxx #hm xxxx . #hm xxx]"x" #hm "xxxx. xxxx xxxx"  $


#task(customTitle: "Kurze Denkaufgabe")[Wie viele Adressen umfasst damit der Adressblock aus dem Beispiel, d.h. wie viele Adressen kann der Kunde hier nutzen]

Da 13 Bit für den Kunden verfügbar sind, kann er $2^(13)$ Adressen verwenden, also alle Adressen von $94.39.64.0$ bis $84.39.95.255$

#hinweis[*Für die Experten*: Stren genommeng sind nur $2^13 - 2$ Adressen verwendbar, da es zwei "spezielle" Adressen gibt:
1. Sind alle schwarzen x gleich 0, dann spricht man von der *Network Identifier Adress*, die zur Identifizierung des Netzwerks verwendet wird.
2. Sind alle schwarzen x gleich 1, dann spricht man von der *Broadcast Adress* - Datenpakete, die an diese Adresse gehen werden kopiert und zu allen Adressen im Netzwerk weitergeleitet. ]

Bei der Notation mit dem Slash spricht man auch von der *CIDR*-Notation (Classless Inter-Domain Routing), die das Konzept der #link("https://de.wikipedia.org/wiki/Netzklasse")[Netzklassen] abgelöst hat.

In der #link("https://www.rfc-editor.org/rfc/rfc1918")[RFC 1918] werden außerdem bestimmte Adressblöcke für private Netze festgelt.

#hinweis(customTitle: "Zitat")[The Internet Assigned Numbers Authority (IANA) has reserved the following three blocks of the IP address space for private internets:
1. $10.0.0.0 - 10.255.255.255$ (10/8 prefix)
2. $172.16.0.0 - 172.31.255.255$ (172.16/12 prefix)
3. $192.168.0.0 - 192.168.255.255$ (192.167/16 prefix)
We will refer to the first block as "24-bit block", the second as "20-bit block" and to the third as "16-bit block". Note that (in pre-CIDR notation) the first block is nothing but a single class A network number, while the second block is a set of 16 contiguous class B network numbers and third block is a set of 256 contiguous class C network numbers.

An enterpreise that decides to use IP addresses out of the adress space defined in this document can do so without any coordination with IANA or an Internet registry. The address space can thus beused by many enterprises. Adresses within this private address space will only be unique within the enterprise, or the set of enterprises which choose to cooperate over this space so they may communicate with each other in their own private internet.
]

Nochmals kurz zusammengefasst: die oben erwähnten Bereiche werden *nicht für öffentliche Adressen im Internet vergeben*. Zur öffentlichen Kommunikation wird dem *gesamten Teilnetz* vom Internetprovider eine IP-Adresse aus einem seiner Adressblöcke zugeteilt (siehe NAT weiter oben). Jedes Gerät des Teilnetztes ist nach außen hin dann nur unter dieser Adresse sichtbar (Bei IPv6 ist dies nicht mehr notwendig. Es gibt dort so viele Adressen, dass tatsächlich jedes Gerät (auch auf absehbare Zeit) seine eigene Adresse haben könnte).

*Dynamische Adressierung*: In beiden Fällen (lokal/öffentlich) gibt es sowohl die Möglichkeit, dass man immer die gleiche, also eine feste Adresse hat, als auch die Möglichkeit, dass in gewissen Absständen bzw. bei jedem Beitritt zum Netz eine beliebige verfügbare Adresse zugeteilt wird, also *dynamisch*.

DODO Exkurs DHCP

== Routing

Aufgrund der Struktur des Internets verlaufen Wege nicht "direkt", sondern die Kommunikation kann über verschiedenste Geräte verlaufen. Möchte man die *Route* nachverfolgen, kann unter Windows beispielsweise der _tracert_ Befehl verwendet werden. Im folgenden beispiele wurde
```
tracert wgg-neumarkt.de
```
ausgeführt:

#image("images/routing.png")

Der erste "Hop" ist dabei die hauseigene Fritzbox, die die Verbindung nach außen regelt. Es folgen einige Hops über Zwischenstationen, bis offenbar der Adressbereich der WGG-Homepage erreicht wird (85.236.32.138). Von dort aus ist es dann nur noch ein Sprung bis zur eigentlichen Website.

DODO: Einfügen Bild von Routing aus dem Schulnetz -> mehrere Hops im lokalen Netzwerk

Im Allgemeinen sind die Strukturen und technischen Details noch wesentlich komplexer. Für uns reicht aber dieser grobe Überblick.

= Transportschicht

An diesem Punkt können wir zwar einen Weg durch unser Netzwerk finden, allerdings müssen wir noch einige Probleme/Fragen lösen:

1. Wie sollen die zu versendenen Daten *aufgeteilt*, d.h *segmentiert* werden?
2. Wie werden *Staus* vermieden?
3. Ist der Verlust einzelner *Datenpakete* in Ordnung?
4. Wie stellen wir sicher, dass die Übertragung *fehlerfrei* abläuft?

Alle diese Fragen werden in der Transportschicht beantwortet. Die beiden wichtigsten Protokolle in diesem Zusammenhang sind *TCP* und *UDP*.

== TCP-Protokoll

Das *Transmission Control Protocol* verlangt eine Verbindung zwischen zwei festgelegten Endpunkten (sogenannte *Sockets*) - in der Regel greift TCP dabei auf das IP-Protokoll der Vermittlungsschicht darunter zurück.

Möchte man via TCP eine Verbindung zu einem bestimmten Dienst - also z.B. auf einem Server irgendwo im Internet - aufbauen, dann sind vier Informationen notwendig:
1. Die eigene IP-Adresse, also die der Quelle der Anfrage.
2. Der eigene *Port* (siehe unten).
3. Die IP-Adresse des Ziel-Rechners.
4. Der Port, der auf dem Zielrechner angesteuert werden soll.

Ein typischer Verbindungsaufbau sieht dann wie folgt aus:

1. Der Client schickt ein *SYN*-Paket (von engl. synchronize) an den Server.
2. Der Server antwortet - sofern der entsprechende Port geöffnet ist - mit einem *SYN/ACK*-Paket (von engl. acknowledge).
3. Der Client bestätigt den Erhalt dieses Pakets, indem er selbst ein *ACK*-Paket zurücksendet.

Damit ist die Verbindung hergestellt.

*Zum Port-Begriff*

Da auf jedem Rechner *viele Prozesse* ablaufen, die gegebenenfalls aber alle Datenpakete aus dem Netzwerk beziehen wollen, muss ein Unterscheidungsmerkmal getroffen werden. Dieses Merkmal wird *Port* genannt und entsprechend dieser *Portnummer* werden einkommende Datenpakte eindeutig zugeordnet werden. Die Portnummer ist eine Folge aus 16 Bits.

*Beispiele für übliche Portnummern*
- http: hypertext transfer protocol: 80
- https: hypertext transfer protocol secure: 443
- FTP: file transfer protocol: 21
- POP3: post office protocol 3: 110
- SMTP: Simple mail transfer protocol: 25

== UDP-Protokoll

Das *User Datagram Protocol* verwendet ebenfalls Ports, um Daten dem richtigen Programm auf einem Zielrechner zukommen zu lassen. *UDP* hat einige Eigenschaften, die auf TCP nicht zutreffen:

1. Es ist *verbindungslos* - ein etwas missverständlicher Begriff der aussagt, dass Kommunikation in der "Gegenrichtung" nicht möglich ist (Rundfunk wäre also verbindungslos z.B.).
2. Es ist *nicht-zuverlässig*, d.h es ist nicht sichergestellt, dass die ankommenden Daten vollständig und fehlerfrei sind.
3. Es ist *ungesichert* und *ungeschützt*, d.h. es gibt keine eingebauten Sicherheitsmechanismen, die eine Verfälschung verhindern.

Diesen Nachteilen stehen einige dadruch entstehende Vorteile gegenüber:
1. TCP hat die obigen Eigenschaften, dadurch wird die Datenlast aber größer, da z.B. Sicherheitsmechanismen durch zusätzliche Daten wie checksums realisiert werden.
2. Die Übertragungsgeschwindigkeit ist deutlich höher.

#hinweis[UDP und TCP arbeiten voneinander unabhängig, d.h. Ports können von beiden verwendet werden - man kann also eine TCP und eine UDP Anwendung z.B. auf Port 80 lauschen lassen.]


= Anwendungsschicht



= Organisationen


Es gibt mehrere Organisationen, die mit der *"Verwaltung"* des Internets beschätigt sind:
1. #text(red)[*ICANN*]: Internet Corporation for Assigned Names and Numbers \ Diese Organisation koordiniert die Vergabe von einmaligen Namen und Adressen im Internet. Dazu gehören insbesondere die Koordination des Domain Name Systems und die "IANA-Funktion" (Internet Assigned Names and Numbers).
2. #text(red)[*Réseaux IP Européens Network Coordination Centre*] \ Eine ähnliche Organisation, die aber speziell für Europa, den Nahen osten und Teile von Zentralasien zuständing ist.
3. #text(red)[*IETF*]: Internet Engineering Task Force \ Hier wird im Wesentlichen die technische Weiterentwicklung des Internets vorangetrieben.
4. #text(red)[*IEEE*]: Ein Berufsverband von Ingenieuren und Technikern, die sich mit der Standardisierung der Netzwerktechnik beschäftigen.

In diesem Sinne keine Organisation, aber #text(red)[*RFC*] Request for Comments  sind dennoch unerlässlich: \ In diesem Skript bereits mehrfach erwähnt wurden RFC Memos, die gewisse Standards vorgeben. Diese Standards müssen implementiert bzw. berücksichtigt werden, wenn neue Technologie in den Verbund des Internets aufgenommen werden wollen.

#pagebreak()
== Lösungen
Die Klammerschreibweise zeigt jeweils an, zu welcher Basis die Ziffern interpretiert werden sollen.
- $(253)_10 = (1111#hm 1101)_2$
- $(11100#hm 0111)_2 = (231)_10$
- $(187)_10=(1011#hm 1011)_2$
- Uneindeutige Aufgabenstellung (Genau genommen natürlich überall, aber hier ist es besonders uneindeutig:) Entweder $(1011)_10 = (11#hm 1111#hm 0011)$ oder $(1011)_2= 11$
- $(11#hm 0101#hm 1011)_2 = (859)_10$
<LösungBinär>

#link(<AufgabeBinär>)[Zurück zur Aufgabe]

<LösungHexa>
- $(0110#hm 0111)_2 = (67)_16$
- $(\f\f#hm\a\f)_16 = (1111#hm 1111 #hm 1010#hm 1111)$
- $(1010#hm 1100#hm 0001#hm 1001)_2 = (\a\c#hm 19)_16$
- $(0e#hm \c1#hm 10)_16 = (1110#hm 1100#hm 0001#hm 0001#hm 0000)$
#link(<AufgabeHexa>)[Zurück zur Aufgabe]

<LösungIP>

$88.215.213.26$ entspricht $0101#hm 1000 . 1101#hm 01111 . 1101 #hm 0101 . 0001#hm 1010$

$0101#hm 1000$ entspricht $88$, $0110#hm 0011$ entspricht 99, $0011#hm 1111$ entspricht 63 und $1001#hm 0011$ entspricht 147, also gesamt: $88.99.63.147$

#link(<AufgabeIP>)[Zurück zur Aufgabe]