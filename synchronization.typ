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

Das *World Wide Web* ist in den 80er Jahren am CERN (Conseil européen pour la recherche nucléaire) entwickelt werden und _nicht_ synonym zum Internet zu verstehen. Spricht man vom Internet, dann ist primär die physikalische Verbindung, d.h. die Hardware der Netzwerke gemeint. Das WWW ist jedoch ein Dienst, d.h. eine Software. Die Grundlage bilden dabei aufeinander verweisende Hypertext-Dokumente, die auf verschiedensten Rechnern abgespeichert sind. Das WWW benutzt also das Internet als Medium, ist jedoch nur einer von vielen Diensten, die das tun. Weitere Beispiele für Dienste sind *E-Mails*, *FTP* (file transfer protocol) oder das *XMPP* (extensible messaging and presence protocol - für Chat-Anwendungen).

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

#kq[Look at the rainbow. LOOK AT IT!]


$ #text(red)[0101]#hm #text(yellow)[0001] #hm #text(green)[1010]#hm #text(blue)[1111] #hm #text(purple)[0000]#hm #text(orange)[1100] #hm #text(olive)[1110]#hm #text(fuchsia)[1000] $

#task[Wandeln Sie jeweils von Binär- in Hexadezimaldarstellung oder umgekehrt um:
- $0110 #hm 0111$
- $\ff #hm \af$
- $1010 #hm 1100 #hm 0001 #hm 1001$
- $0e #hm \c1 #hm 10$
]

== IP-Adressen

*IP(v4)* ist die erste Version des Internet Protocols, das weltweit verbreitet und eingesetzt wurde. Eine solche IP-Adresse besteht aus einer 32-stelligen Binärzahl, die jeweils einer Komponente (einem Gerät oder Netzwerk) im Internet zugeordnet ist und so eine Identifizierung möglich macht. 

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

#kq[As I understood Ipv6 does not play a huge role anyway does it? Why is that so? I want a justification for why this is very short here basically]

== Adressvergabe 

IP-Adressblöcke werden an Unternehmen und Organisationen vergegeben, die diese ihrerseits wieder verteilen können. 

*Vergebene Adressblöcke*: #link("https://ftp.ripe.net/ripe/stats/membership/alloclist.txt")[Findet man z.B. hier]


= Topologie von Rechnernetzen


= Protokolle 


= Das Schichtenmodell


= Nebenläufige Prozesse 


= Das klassische Erzeuger - Verbraucher - Problem


= Verklemmungen

