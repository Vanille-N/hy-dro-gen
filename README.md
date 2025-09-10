# Hy-dro-gen

Unofficial bindings from [`typst/hypher`](https://github.com/typst/hypher) to native Typst.

<!-- @scrybe(if publish; grep https; grep {{version}}) -->
Full documentation [here](docs/main.pdf).

## Versions

<!-- @scrybe(jump latest; grep {{version}}) -->
| `hy-dro-gen`   | `hypher`                                                        |
|----------------|-----------------------------------------------------------------|
| 0.1.0          | [0.1.5](https://github.com/typst/hypher/releases/tag/v0.1.5)    |
| 0.1.1 (latest) | [0.1.6](https://github.com/typst/hypher/releases/tag/v0.1.6)    |

## Basic usage

<!-- @scrybe(not publish; jump import; grep local; grep {{version}}) -->
<!-- @scrybe(if publish; jump import; grep preview; grep {{version}}) -->
```typ
#import "@local/hy-dro-gen:0.1.1" as hy

// `exists` checks if a language is supported
#assert(hy.exists("fr"))
#assert(not hy.exists("xz"))

// `syllables` splits words according to the language provided (default "en")
#assert.eq(hy.syllables("hydrogen"), ("hy", "dro", "gen"))
#assert.eq(hy.syllables("hydrogène", lang: "fr"), ("hy", "dro", "gène"))
#assert.eq(hy.syllables("υδρογόνο", lang: "el"), ("υ", "δρο", "γό", "νο"))
```
