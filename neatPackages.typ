#import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx, gridx, vlinex, hlinex
#import "@preview/acrostiche:0.3.0": *
#import "@preview/chic-hdr:0.2.0": *
#import "@preview/colorful-boxes:1.1.0"
#import "@preview/diverential:0.2.0": *
#import "@preview/gloss-awe:0.0.4": *
#import "@preview/plotst:0.1.0": *
#import "@preview/syntree:0.1.0": *
#import "@preview/showybox:1.1.0": *
#import "@preview/cetz:0.1.0"
#import "@preview/finite:0.3.0": automaton


#automaton((
  q0: (q1:0, q0:"0,1"),
  q1: (q0:(0,1), q2:"0"),
  q2: (),
))



//#set page(paper: "a7")

#show: chic.with(
  chic-footer(
    left-side: strong(
        link("mailto:admin@chic.hdr", "admin@chic.hdr")
    ),
    right-side: chic-page-number()
  ),
  chic-header(
    left-side: emph(chic-heading-name()),
    right-side: smallcaps("Example")
  ),
  chic-separator(1pt),
  chic-offset(7pt),
  chic-height(1.5cm)
)

= Introduction
#lorem(30)

== Details
#lorem(70)

#init-acronyms((
  "NN": ("Neural Network",),
  "OS": ("Operating System",),
  "BIOS": ("Basic Input/Output System", "Basic Input/Output Systems"), 
)) 

Das ist ein #acr("NN")

#tablex(
  columns: 4,
  align: center + horizon,
  auto-vlines: false,

  // indicate the first two rows are the header
  // (in case we need to eventually
  // enable repeating the header across pages)
  header-rows: 2,

  // color the last column's cells
  // based on the written number
  map-cells: cell => {
    if cell.x == 3 and cell.y > 1 {
      cell.content = {
        let value = int(cell.content.text)
        let text-color = if value < 10 {
          red.lighten(30%)
        } else if value < 15 {
          yellow.darken(13%)
        } else {
          green
        }
        set text(text-color)
        strong(cell.content)
      }
    }
    cell
  },

  /* --- header --- */
  rowspanx(2)[*Username*], colspanx(2)[*Data*], (), rowspanx(2)[*Score*],
  (),                 [*Location*], [*Height*], (),
  /* -------------- */

  [John], [Second St.], [180 cm], [5],
  [Wally], [Third Av.], [160 cm], [10],
  [Jason], [Some St.], [150 cm], [15],
  [Robert], [123 Av.], [190 cm], [20],
  [Other], [Unknown St.], [170 cm], [25],
)


#tablex(
  columns: (auto, 1em, 1fr, 1fr),  // 4 columns
  rows: auto,  // at least 1 row of auto size
  fill: red,
  align: center + horizon,
  stroke: green,
  [a], [b], [c], [d],
  [e], [f], [g], [h],
  [i], [j], [k], [l]
)


#tablex(
  columns: 3,
  colspanx(2)[a], (),  [b],
  [c], rowspanx(2)[d], [ed],
  [f], (),             [g]
)

#tablex(
  columns: 4,
  auto-lines: false,

  // skip a column here         vv
  vlinex(), vlinex(), vlinex(), (), vlinex(),
  colspanx(2)[a], (),  [b], [J],
  [c], rowspanx(2)[d], [e], [K],
  [f], (),             [g], [L],
  //   ^^ '()' after the first cell are 100% ignored
)

#tablex(
  columns: 4,
  auto-vlines: false,
  colspanx(2)[a], (),  [b], [J],
  [c], rowspanx(2)[d], [e], [K],
  [f], (),             [g], [L],
)

#gridx(
  columns: 4,
  (), (), vlinex(end: 2),
  hlinex(stroke: yellow + 2pt),
  colspanx(2)[a], (),  [b], [J],
  hlinex(start: 0, end: 1, stroke: yellow + 2pt),
  hlinex(start: 1, end: 2, stroke: green + 2pt),
  hlinex(start: 2, end: 3, stroke: red + 2pt),
  hlinex(start: 3, end: 4, stroke: blue.lighten(50%) + 2pt),
  [c], rowspanx(2)[d], [e], [K],
  hlinex(start: 2),
  [f], (),             [g], [L],
)