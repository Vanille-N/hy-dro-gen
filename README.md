# Hy-dro-gen

Unofficial bindings from [`typst/hypher`](https://github.com/typst/hypher) to native Typst.

Documentation [here](https://github.com/Vanille-N/hy-dro-gen/blob/master/doc.pdf).

## Basic usage

```typ
#import "@preview/hy-dro-gen:0.1.5" as hy

// `exists` checks if a language is supported
#assert(hy.exists("fr"))
#assert(not hy.exists("xz"))

// `syllables` splits words according to the language provided (default "en")
#assert.eq(hy.syllables("hydrogen"), ("hy", "dro", "gen"))
#assert.eq(hy.syllables("hydrogène", lang: "fr"), ("hy", "dro", "gène"))
#assert.eq(hy.syllables("υδρογόνο", lang: "el"), ("υ", "δρο", "γό", "νο"))
```
