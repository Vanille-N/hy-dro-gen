#show link: set text(fill: blue.darken(20%))

#align(center)[
  #text(size: 30pt)[_*Hy-dro-gen*_] \
  #v(1mm)
  Hyphenation patterns from #link("https://github.com/typst/hypher")[`github:typst/hypher`]
  #v(1cm)
]


#import "/lib.typ" as hy


```typ
#import "@preview/hy-dro-gen:0.1.5" as hy
```
#table(
  columns: (66%, 35%),
  stroke: gray + 0.5pt,
  [```typ #hy.exists("en")```],
    [#hy.exists("en")],
  [```typ #hy.exists("xz")```],
    [#hy.exists("xz")],
  [```typ #hy.syllables("hydrogen")```],
    [#hy.syllables("hydrogen")],
  [```typ #hy.syllables("hydrogène")```],
    [#hy.syllables("hydrogène")],
  [```typ #hy.syllables("hydrogène", lang: "fr")```],
    [#hy.syllables("hydrogène", lang: "fr")],
  [```typ #hy.syllables("υδρογόνο", lang: "el")```],
    [#hy.syllables("υδρογόνο", lang: "el")],
  [```typ #hy.syllables("hydrogène", lang: "xz")```],
    [#text(fill: red)[*panic: Invalid language*]],
  [```typ #hy.syllables("hydrogène", lang: "xz", fallback: auto)```],
    [#hy.syllables("hydrogène", lang: "xz", fallback: auto)],
  [```typ #hy.syllables("hydrogène", lang: "xz", fallback: "fr")```],
    [#hy.syllables("hydrogène", lang: "xz", fallback: "fr")],
)

The following languages are supported:
#align(center)[
  #table(
    columns: 5,
    inset: (x: 1cm),
    stroke: gray + 0.5pt,
    table.header([*Code*], [*Language*], [], [*Code*], [*Language*]),
    ..(
      for (i, (code, lang)) in hy.languages.pairs().enumerate() {
        (text(fill: green.darken(50%))[#raw("\"" + code + "\"")], [#lang])
        if calc.rem(i, 2) == 0 {
          ([],)
        }
      }
    )
  )
]
The above mapping is available via the static dictionary ```typ #hy.languages```.


#pagebreak()

#import "@preview/tidy:0.4.3"

#let parse-and-show(path, header) = {
  let path = "/" + path
  header
  import path as mod
  let docs = tidy.parse-module(
    read(path),
    scope: (mod: mod),
    preamble: "#import mod: *;",
  )
  tidy.show-module(
    docs,
    style: tidy.styles.default,
    sort-functions: none,
  )
}

#parse-and-show("lib.typ")[]
