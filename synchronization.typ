#import "template.typ": *
#import "@preview/tablex:0.0.6": tablex, cellx, rowspanx, colspanx
#show: setup
#set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
#set heading (
    numbering: "1."
)

#let kq(body, path:"images/kitten.jpg") = {
    showybox(
        frame:(
            border-color: rgb("FF0000"),
            body-color: rgb("FFB3B3"),
            inset: 15pt,
            thickness: 3pt
        ), 
        [
           #grid(
            columns: (10%, 90%),
            rows: (auto),
            gutter: 10pt, 
            [#image(path)], [#align(left)[#body]]
           )

        ]
    )
}


#let hm = h(1mm)

#v(1fr)
#align(center)[#text(32pt)[Netzwerk \  #align(center)[#image("images/art.png", width: 80%)] ] \ Stable Diffusion Art "Networks"]
#v(1fr)

#pagebreak()
#outline(title: "Inhaltsverzeichnis", indent: auto)

#kq[For now I 1:1 copied the structure of the pptx I have here. I will also mostly adapt the content, if you have Bedenken right away, here we go]
#pagebreak()




= Internet und Adressierung
== Historisches

Das *Internet* entstand primär aus dem 1969 entwickelten ARPANET (Advanced Research Project Agency Networkt) Projekt an dem vier US-Amerikanische Universitäten beteiligt waren, deren Ziel die weitläufige Vernetzung von Rechnern zur gemeinsamen Nutzung von Ressourcen war. Die Idee größere Netzwerke aufzubauen stammte dabei schon aus den Anfängen der 1960er Jahre und viele Gruppen forschten und arbeiteten daran (z.B. auch das US Militär). Dieses Projekt war auch eines der ersten, die das *TCP/IP* Protokoll implementiert haben (#link("https://www.ietf.org/rfc/rfc9293.html")[RFC 9293] - der aktuelle Standard). 

In der Folge wurden vor allem weitere Universitäten in Europa und den USA in Netzwerken miteinander verknüpft bis die Technologie so weit ausgereift war, dass es zu einer regelrechten Explosion kam, die dazu führte, dass die meisten technischen Geräte heute miteinander *physikalisch* verbunden sind. 

#kq[Please feel free to add information you deem important at any point, but please be aware that we do only have so much time to discuss things]

Das *World Wide Web* ist in den 80er Jahren am CERN (Conseil européen pour la recherche nucléaire) entwickelt werden und _nicht_ synonym zum Internet zu verstehen. Spricht man vom Internet, dann ist primär die physikalische Verbindung, d.h. die Hardware der Netzwerke gemeint. Das WWW ist jedoch ein Dienst, d.h. eine Software. Die Grundlage bilden dabei aufeinander verweisende Hypertext-Dokumente, die auf verschiedensten Rechnern abgespeichert sind. Das WWW benutzt also das Internet als Medium, ist jedoch nur einer von vielen Diensten, die das tun. Weitere Beispiele für Dienste sind *E-Mails*, *FTP* (file transfer protocol), *HTTP* (Hyper-Text-Transfer-Protocol) oder das *XMPP* (extensible messaging and presence protocol - für Chat-Anwendungen).

== Wiederholung Bits, Bytes und Hex 

In der Informatik werden andere *Stellenwertsysteme* als in der schulüblichen Mathematik verwendet. Während dort das Zehnersystem Einzug gehalten hat ist für Computer das Zweiersystem geeignet (Strom an, Strom aus!). 

Das bedeutet konkret: Statt in Zehnerpotenzen zu denken und daraus die Zahlen "zusammenzubauen" wie in der fünften Klasse (z.B. $12985 = 10000 + 2000 + 900 + 80 + 5$) werden *Binärzahlen* aus *Zweierpotenzen* zusammengebaut.

Das erscheint uns auf den ersten Blick merkwürdig - das liegt letztendlich aber nur an der Gewöhnung an das Zehnersystem. 
#align(center)[
#tablex(columns: 10, rows: 2, align: center, 
colspanx(10)[*Zweierpotenzen für die Umrechnung*],[512],[256],[128],[64],[32],[16],[8],[4],[2],[1]
)]

*Beispiele*
- Binär: $0111#hm 1010$ lässt sich dezimal schreiben als: $ 0 dot 128 + 1 dot 64 + 1 dot 32 + 1 dot 16 + 1 dot 8 + 0 dot 4 + 1 dot 2 +0 dot 1 = 122 $

- Dezimal: $195$ lässt sich umwandeln zu: $ 195 =  1 dot 128 + 1 dot 64 + 0 dot 32 + 0 dot 16 + 0 dot 8 + 0 dot 4 + 1 dot 2 + 1 dot 1 $ und entspricht somit in Binärdarstellung als $1100#hm 0011$

DODO Expliziten Algo angeben, 0b und 0x Notation ansprechen

Beschränkt man sich auf Zahlen, die durch 8 Bit (also 1 Byte!) dargestellt werden, dann ist der Zahlenraum also auf die Zahlen von 0 bis 255 beschränkt, da 255 binär $1111#hm 1111$ entspricht. 

#task[Wandeln Sie jeweils in Binär bzw. Dezimaldarstellung um. 
- $253$
- $1110#h(1mm)0111$
- $187$
- $1011$
- $11#h(1mm)0101#h(1mm)1011$
]

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

#task[Wandeln Sie jeweils von Binär- in Hexadezimaldarstellung oder umgekehrt um:
- $0110 #hm 0111$
- $\ff #hm \af$
- $1010 #hm 1100 #hm 0001 #hm 1001$
- $0e #hm \c1 #hm 10$
]

== IP-Adressen

*IP(v4)* ist die erste Version des Internet Protocols, das weltweit verbreitet und eingesetzt wurde. Eine solche IP-Adresse besteht aus einer 32-stelligen Binärzahl, die jeweils einem Netzwerk-Interface im Internet zugeordnet ist und so eine Identifizierung möglich macht. Netwerken voin z.B. Providern wird dann ein ganzer Block an Adressen zugeordnet (siehe unten). 

Zur besseren Lesbarkeit wird die Adresse üblicherweise in vier 8-stellige Böclke aufgeteilt und (für den Menschen) dann in Dezimalschreibweise abgebildet werden - jeweils durch einen Punkt getrennt.

*Beispiel*

$ 01101100001000010000111100110111 $
$ 01101100#hm 00100001#hm 00001111#hm 00110111 $
$ 108 . 33 . 15 . 55 $

#task(customTitle: "Kurze Denkaufgabe!")[Wie viele solcher IP-Adressen können gebildet werden?]

Es sind natürlich $2^(32)$, also etwa $4,3$ Millarden Adressen.

#task[Wandeln Sie jeweils von Binär- in Dezimaldarstellung oder umgekehrt um: 
- $88.215.213.26$
- $0101#hm 1000 #hm 0110 #hm 0011 #hm 0011 #hm 1111 #hm 1001 #hm 0011 $
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

*Vergebene Adressblöcke*: #link("https://ftp.ripe.net/ripe/stats/membership/alloclist.txt")[Findet man z.B. hier]

Die Einträge sind dabei folgendermaßen zu lesen: *$84.39.64.0/19$* 

Die Zahl 19 bedeutet hier: Für alle Adressen aus dem Adressblock gilt, dass die ersten 19 Bit fest vorgegeben sind und die restlichen Stellen beliebig verwendet werden können, d.h. die rot markierten Stellen sind fix:

$ 84.39.64.0 = #text(red)[xxxx #hm xxxx . xxxx #hm xxxx . #hm xxx]"x" #hm "xxxx. xxxx xxxx"  $

#task(customTitle: "Kurze Denkaufgabe")[Wie viele Adressen umfasst damit der Adressblock aus dem Beispiel, d.h. wie viele Adressen kann der Kunde hier nutzen]

Da 13 Bit für den Kunden verfügbar sind, kann er $2^(13)$ Adressen verwenden, also alle Adressen von $94.39.64.0$ bis $84.39.95.255$

In der #link("https://www.rfc-editor.org/rfc/rfc1918")[RFC 1918] werden bestimmte Adressblöcke für private Netze festgelt. 

#hinweis(customTitle: "Zitat")[The Internet Assigned Numbers Authority (IANA) has reserved the following three blocks of the IP address space for private internets: 
1. $10.0.0.0 - 10.255.255.255$ (10/8 prefix)
2. $172.16.0.0 - 172.31.255.255$ (172.16/12 prefix)
3. $192.168.0.0 - 192.168.255.255$ (192.167/16 prefix)
We will refer to the first block as "24-bit block", the second as "20-bit block" and to the third as "16-bit block". Note that (in pre-CIDR notation) the first block is nothing but a single class A network number, while the second block is a set of 16 contiguous class B network numbers and third block is a set of 256 contiguous class C network numbers.

An enterpreise that decides to use IP addresses out of the adress space defined in this document can do so without any coordination with IANA or an Internet registry. The address space can thus beused by many enterprises. Adresses within this private address space will only be unique within the enterprise, or the set of enterprises which choose to cooperate over this space so they may communicate with each other in their own private internet. 
]

Kurz zusammengefasst: die oben erwähnten Bereiche werden *nicht für öffentliche Adressen im Internet vergeben*. Zur öffentlichen Kommunikation wird dem *gesamten Teilnetz* vom Internetprovider eine IP-Adresse aus einem seiner Adressblöcke zugeteilt. Jedes Gerät des Teilnetztes ist nach außen hin dann nur unter dieser Adresse sichtbar. 

*Dynamische Adressierung*: In beiden Fällen (lokal/öffentlich) gibt es sowohl die Möglichkeit, dass man immer die gleiche, also eine feste Adresse hat, als auch die Möglichkeit, dass in gewissen Absständen bzw. bei jedem Beitritt zum Netz eine beliebige verfügbare Adresse zugeteilt wird, also *dynamisch*. 

== URL und DNS

Eine *URL* (uniform resource locator) ist eine anwenderfreulichere Benennung von Internetressourcen. In der Regel werden Websiten bzw. deren Ordnerstruktur so benannt. 

*Beispiel*: https://#text(red)[www.wgg-neumarkt.de]

*DNS (domain name system)*: 

Das oben rot gedruckte ist die Domain der Website. Ein DNS-Server übersetzt jede Domain, die beispielsweise ein Anweder in die Adresszeile seines Browsers eingibt, in die dazu gehörige IP-Adresse, damit anschließend die Verbindung zu dem Rechner, der diese Domain hostet, aufgebaut werden kann. 

#task[Finden Sie die zugehörige IP-Adresse zu www.wgg-neumarkt.de und zu www.google.de. Recherchieren Sie dazu geeignete tools im Internet.]

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

#kq[So.. there is surely a lot more to talk about, you mentioned CIDR notation, that I stuff in above at IPv4 yus? So you really want me to torment them with subnetting and such as well? What else shall be added?]

== Organisationen

Es gibt mehrere Organisationen, die mit der *"Verwaltuing"* des Internets beschätigt sind:
1. #text(red)[ICANN]: Internet Corporation for Assigned Names and Numbers \ Diese Organisation koordiniert die Vergabe von einmaligen Namen und Adressen im Internet. Dazu gehören insbesondere die Koordination des Domain Name Systems und die "IANA-Funktion" (Internet Assigned Names and Numbers). 
2. #text(red)[Réseaux IP Européens Network Coordination Centre] \ Eine ähnliche Organisation, die aber speziell für Europa, den Nahen osten und Teile von Zentralasien zuständing ist. 
3. #text(red)[IETF]: Internet Engineering Task Force \ Hier wird im Wesentlichen die technische Weiterentwicklung des Internets vorangetrieben. 
4. #text(red)[RFC] Request for Comments \ In diesem Skript bereits mehrfach erwähnt wurden RFC Memos, die gewisse Standards vorgeben. Diese Standards müssen implementiert bzw. berücksichtigt werden, wenn neue Technologie in den Verbund des Internets aufgenommen werden wollen. 

= Topologie von Rechnernetzen

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
4. Die Übertragungsrate hängt (quasi) alleine vom Bus ab. Bei hoher Last lassen sich Kollissionen nicht direkt vermeiden. Es kann der Ansatz eines sogenannten *Token Bus* verwendet werden. 

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

*Direkte Verbindungen*

Bei dieser Bauart ist jeder Rechner mit jedem anderen verbunden.

#align(center)[
#image("images/direkt_topologie.png", width:50%)
]

1. Der Ausfall jedes Geräts ist unproblematisch. 
2. Der Aufwand bei der Fehlersuche ist gering, das erweitern dagegen sehr aufwändig. 
3. Keine teuren Komponenten, aber sehr viele Leitungen nötig $(~ n^2)$ mit $n$ der Anzahl der Rechner. 
4. Die Übertragungsrate ist sehr hoch, Kollisionen sind dagegen selten. 

*Kombinationen*

Natürlich sind auch Kombinationen verschiedener Arten von Rechnernetzen möglich:

DODO Bild

= Protokolle 

Damit Kommunikation sinnvoll ablaufen kann müssen die "Spielregeln" der Kommunikation eindeutig festgelegt werden. Die Vereinbarungen für die technische Kommunikation sind in *Protokollen* festgehalten, die wiederum in den RFCs (siehe oben) spezifiziert werden. 

Bevor wir uns detaillierter mit einzelnen Protokollen beschäftigen hier ein exemplarischer Ablauf einer Client-Server-Sitzung: 

*Server*:
- Server starten (Port festlegen)
- Anmeldeversuch eines Clients: Akzeptanz oder Ablehnung
- Botschaft des Clients empfangen und entsprechend eines Algorithmus antworten. 
- Ist eine Abschlussbedingung erreicht: Verbindung trennen
- ggf. Server beenden

*Client*:
- Anmeldung beim Server (IP-Adresse und Port notwendig)
- Antworten des Servers lesen und entsprechende Eingaben tätigen. 
- ggf. Abschluss auslösen

#kq[The colleague had this example before he dives deeper, do you tink it is wise to do some simple Java Client Server Impl here? Me kinda wants to do da Polly, but me is unsure if that really is halpful cause you just use a bunch of Java intern stuff but then again.. you can start the server and the client and make them communicate.. hm]

*Port*

Da auf jedem Rechner *viele Prozesse* ablaufen, die gegebenenfalls aber alle Datenpakete aus dem Netzwerk beziehen wollen, muss ein Unterscheidungsmerkmal getroffen werden. Dieses Merkmal wird *Port* genannt und entsprechend dieser *Portnummer* werden einkommende Datenpakte eindeutig zugeordnet werden. Die Portnummer ist eine Folge aus 16 Bits. 

*Beispiele für pbliche Portnummern*
- http: hypertext transfer protocol: 80
- https: hypertext transfer protocol secure: 443
- FTP: file transfer protocol: 21
- POP3: post office protocol 3: 11ß
- SMTP

*Zu Datenpaketen*

Die Daten, die während eines Kommunikationsprozesses übermittelt werden sollen, bzw. die Daten eines stetigen Datenstroms (Streaming) werden in viele kleine Portionen aufgeteilt, die individuell verschickt werden. (Daraus können sich natürlich Probleme ergeben, z.B.: was passiert, wenn einzelne Pakete verloren gehen?). 

Neben den eigentlichen Daten, die Übertragen werden sollen, werden in der Regel Zusatzinformationen mit übertragen, z.B.:
- IP-Adressen von Sender und Empfänger
- MAC-Adresse von Sender und Empfänger: DODO: wo Mac-Adress-Erklärung einpflegen?
- ggf. fortlaufende Nummern der einzelnen Teil-Datenpakete einer Sendung
- Checksummen
- Timestamps
- Infos über die Größe des Pakets oder die Größe des Headers. 


= Das Schichtenmodell


= Nebenläufige Prozesse 


= Das klassische Erzeuger - Verbraucher - Problem


= Verklemmungen

