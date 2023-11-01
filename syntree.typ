#import "@preview/syntree:0.1.0": syntree

#syntree(
  nonterminal: (font: "Linux Biolinum"),
  terminal: (fill: blue),
  child-spacing: 3em, // default 1em
  layer-spacing: 2em, // default 2.3em
  "[S [NP This] [VP [V is] [^NP a wug]]]"
)