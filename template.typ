#import "@preview/showybox:1.1.0": showybox

#let xAchse = [$x-$Achse]
#let yAchse = [$y-$Achse]


#let setup(doc) = [
    #set par(
        justify: true
    )
    #set text(
    font: "Times New Roman"
    )
    #show link: underline
    #show link: set text(blue)
    #set text(lang: "de")
    #set raw(theme: "halcyon.tmTheme")
    #set enum(numbering: (..args) => strong(numbering("1.", ..args))) // in Aufzählungen Zahlen fett
    #show raw: it => block(
        fill: rgb("#1d2433"),
        inset: 8pt,
        radius: 5pt,
        text(fill: rgb("#a2aabc"), it)
    )

    #doc
]

#let prodRules(content: []) = {
    let i = 0
    let n = content.len() / 2
    let c = []
    while i < n {
        let nr = i + 1
        c = c + [ $ &(#nr) #h(4pt) #content.at(2*i) -> #content.at(2*i + 1) \ $ ]
        i = i + 1
    }
    c = [ $ #c $ ]
    c
}

#let definition(body, customTitle: "Definition", borderColor: rgb("4D4DFF")) = {
    showybox(
        frame: (
            title-color: borderColor,
            body-color: rgb("99BBFF"),
            border-color: borderColor,
            thickness: 2pt, 
        ),
        title-style: (
            color:black
        ),
        title: customTitle,
        [
            #body
        ]        
    )
}

#let satz(body, customTitle: "Satz") = {
    showybox(
        frame:(
            radius: 0pt, 
            title-color: rgb("E69900"),
            border-color: rgb("E69900"),
            body-color: rgb("FFBB33")
        ),
        title-style: (
            color: black
        ),
        shadow: (
            color: black.lighten(25%),
            offset: (x: 2pt, y: 4pt)
        ),
        title: customTitle,
        [
            #body
        ]
    )
}

#let task(body, customTitle: [*_Aufgabe_*]) = {
    showybox(
        frame: (
            title-color: rgb("C9C9C9").lighten(50%),
            border-color: rgb("949494"),
            body-color: rgb("C9C9C9").lighten(50%)
        ),
        title-style: (
            boxed:true,
            color: black,
            boxed-align: center
        ),
        title: customTitle, 

        [
            #body
        ]
    )
}


#let merke(body, path:"images/achtung.png") = {
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

#let hinweis(body, customTitle: [*_Hinweis_*], color: rgb("FFFF99"), border-color: rgb("FFDD33")) = {
    showybox(
        title-style: (
            color:black,
            sep-thickness: 0pt,
        ),
        frame: (
            border-color: border-color ,
            thickness: (left:4pt),
            radius: 0pt,
            title-color:color,
            body-color:color
        ),
        title: customTitle,
        [
            #body
        ]
    )

}
