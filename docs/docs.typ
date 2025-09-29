#import "@preview/mantys:1.0.2": *
#import "@preview/tidy:0.4.3"
#import "@preview/swank-tex:0.1.0": TeX

#import "/lib.typ" as hy

#let repo = "https://github.com/Vanille-N/hy-dro-gen/"
#let hypher-repo = "https://github.com/typst/hypher/"
#let hypher-fork-repo = "https://github.com/Vanille-N/hypher/"
#let typst-repo = "https://github.com/typst/typst/"

#let iso = link("https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes")[ISO 639-1]
#show ref: rr => {
  if rr.target == label("iso") {
    iso
  } else {
    rr
  }
}

#show regex("Introduced in "): "Since "

#let twocols(frac: 50%, l, r) = {
  table(columns: (frac, 100% - frac), stroke: none, l, r)
}

#let show-module(name, module: false, scope: (:), outlined: true) = {
  let path = "../" + name + ".typ"
  import path as mod
  tidy-module(
    name,
    module: if module == true { name } else if module == false { none } else { module },
    read(path),
    scope: scope,
  )
}

#show: mantys(
  ..toml("../typst.toml"),

  /// Uncomment one of the following lines to load the above
  /// package information directly from the typst.toml file
  // ..toml("../typst.toml"),
  // ..toml("typst.toml"),

  title: "HY-DRO-GEN",
  subtitle: "User guide",
  date: datetime.today(),

  show-index: false,
  show-urls-in-footnotes: false,

  abstract: [
    HY-DRO-GEN can split words into syllables in any supported language,
    which enables correct hyphenation. It includes the ability to dynamically
    load hyphenation patterns, enabling hyphenation also for languages or variants
    not natively supported by Typst.

    HY-DRO-GEN is composed of
    1. an internal WASM module that provides bindings to the hyphenation library
       natively used for Typst, #github("typst/hypher"),
    2. a public layer to abstract away the internal details.
    #v(-1.2em)
    This manual is only concerned with the latter.

    *Contributions* \
    If you have ideas for improvements, or if you encounter a bug,
    you are encouraged to contribute to HY-DRO-GEN by submitting a
    #link(repo + "issues")[bug report],
    #link(repo + "issues")[feature request],
    or #link(repo)[pull request].

    // @scrybe(jump releases; grep 'tag/{{version}}')
    // @scrybe(jump releases; grep ':{{version}}')
    *Versions*
    - #link(repo)[`dev`]
    - #link(repo + "releases/tag/0.1.2")[`hy-dro-gen:0.1.2`]
      (#link("https://typst.app/universe/package/hy-dro-gen")[`latest`])
      $->$
      #link(hypher-repo + "releases/tags/0.1.6")[`hypher:0.1.6`]
      forked to #link(hypher-fork-repo + "commit/83aa0d2d562e268caac7a7ad5b3e71530784dcbc")[`83aa0d2`]
    - #link(repo + "releases/tag/0.1.1")[`hy-dro-gen:0.1.1`]
      #hide[(`latest`)]
      $->$ #link(hypher-repo + "releases/tags/0.1.6")[`hypher:0.1.6`]
    - #link(repo + "releases/tag/0.1.0")[`hy-dro-gen:0.1.0`]
      #hide[(`latest`)]
      $->$ #link(hypher-repo + "releases/tags/0.1.5")[`hypher:0.1.5`]

    #colbreak()
    #colbreak()
  ],

  // examples-scope: (
  //   scope: (:),
  //   imports: (:)
  // )

  // theme: themes.modern
)

#custom-type("iso")
#custom-type("trie")

= Quick start

Import the latest version of HY-DRO-GEN with:

// @scrybe(jump preview; grep {{version}})
#sourcecode[```typ
#import "@preview/hy-dro-gen:0.1.2" as hy
```]

The main function provided by HY-DRO-GEN is @cmd:hy:syllables,
which takes as input a word and a language (specified by its #iso code),
and returns the word split by syllables.
By default, the language is ```typc "en"```, i.e. English.

#table(
  columns: (66%, 35%),
  stroke: gray + 0.5pt,
  [```typ #hy.syllables("hydrogen")```],
    [#hy.syllables("hydrogen")],
  [```typ #hy.syllables("hydrogène", lang: "fr")```],
    [#hy.syllables("hydrogène", lang: "fr")],
  [```typ #hy.syllables("υδρογόνο", lang: "el")```],
    [#hy.syllables("υδρογόνο", lang: "el")],
)

= Language validation

If a language is unsupported, the default behavior is a panic.
#table(
  columns: (66%, 35%),
  stroke: gray + 0.5pt,
  [```typ #hy.syllables("hydrogène", lang: "xz")```],
    [#text(fill: red)[*panic: Invalid language*]],
)

In the eventuality that you need to hyphenate for an arbitrary language
that is not guaranteed to be a valid #iso code, it is recommend that you either
validate the language or specify a fallback.

== Existence check

The function @cmd:hy:exists checks if a language is natively supported.
If @cmd:hy:exists returns #typ.v.true, a call of @cmd:hy:syllables is guaranteed
to not panic given this language.
Since all #iso codes have two letters, any string of more than two letters
given to this function will always produce #typ.v.false.
#table(
  columns: (66%, 35%),
  stroke: gray + 0.5pt,
  [```typ #hy.exists("en")```],
    [#hy.exists("en")],
  [```typ #hy.exists("xz")```],
    [#hy.exists("xz")],
  [```typ #hy.exists("foobar")```],
    [#hy.exists("foobar")],
)

Here is the list of all languages supported natively:
#align(center)[
  #table(
    columns: 8,
    inset: (x: 0.3cm),
    stroke: gray + 0.5pt,
    table.header([*Code*], [*Language*], [], [*Code*], [*Language*], [], [*Code*], [*Language*]),
    ..(
      for (i, (code, lang)) in hy.languages.pairs().enumerate() {
        (text(fill: green.darken(50%))[#raw("\"" + code + "\"")], [#lang])
        if calc.rem(i, 3) in (0, 1) {
          ([],)
        }
      }
    )
  )
]
The same list available via the static dictionary #var(module: "hy")[languages].

== Fallback

Alternatively, you can provide a fallback strategy among:
- #typ.v.auto: languages that do not exist will silently be skipped,
- #typ.t.str: a valid #iso code as a fallback will be used in the event
  that #arg[lang] is invalid.

#table(
  columns: (68%, 35%),
  stroke: gray + 0.5pt,
  [```typ #hy.syllables("hydrogène", lang: "xz")```],
    [#text(fill: red)[*panic: Invalid language*]],
  [```typ #hy.syllables("hydrogène", lang: "xz", fallback: auto)```],
    [#hy.syllables("hydrogène", lang: "xz", fallback: auto)],
  [```typ #hy.syllables("hydrogène", lang: "xz", fallback: "fr")```],
    [#hy.syllables("hydrogène", lang: "xz", fallback: "fr")],
)

= Dynamically loaded languages

#warning-alert[
  This feature is experimental and still lacks some validation.
  If you do not follow the instructions below you can end up with
  incomprehensible error messages.
]

== Some background

As explained in #link("https://laurmaedje.github.io/posts/hypher/")[the original blog post for hypher], hyphenation in Typst works by generating an automaton from a #TeX pattern file.
In practice this is implemented by the crate #link("https://crates.io/crates/hypher")[`hypher`].
By default #link("https://crates.io/crates/hypher")[`hypher`], and thus Typst,
embeds the automata for 35 (possibly soon #link(hypher-repo + "pull/27")[36])
languages, but until #link(typst-repo + "issues/5223")[issue \#5223] lands,
it is not currently possible to load custom patterns.

The ability to dynamically load patterns is however implemented
by my own #link(hypher-fork-repo)[fork of hypher],
and HY-DRO-GEN makes use of this capability.

== Obtaining tries

Tries are loaded from #TeX pattern files or precompiled binaries by @cmd:hy:trie.
This section details how to obtain an object of type @type:trie that you
can then pass to @cmd:hy:syllables.

=== Download pattern files

There are a number of hyphenation pattern files available on
#link("https://www.hyphenation.org/")[hyphenation.org],
of which quite a few are not available natively in Typst.

In what follows I assume that you have downloaded your pattern files,
and saved them to `patterns/hyph-${iso}.tex`, replacing `${iso}` with
whatever code the language you want to use has.
Also note on #link("https://www.hyphenation.org/")[hyphenation.org]
the column titled '(left,right)-hyphenmin'. This data will be important.

=== On-the-fly compilation <on-the-fly>

One way to obtain a trie is:
#codesnippet[```typ
#let trie = hy.trie(
  tex: read("patterns/hyph-${iso}.tex"),
  bounds: hyphenmin,
)
```]
For example to load Galician (```typc "gl"``` patterns):
#codesnippet[```typ
#let trie_gl = hy.trie(tex: read("patterns/hyph-gl.tex"), bounds: (2, 2))
```]

This solution incurs a small one-time overhead to compile the trie from the patterns.
You can avoid this overhead by following the instructions in @precompiled
and building a @type:trie from a precompiled binary instead.

=== Precompilation <precompiled>

==== Install `hypher` <install-hypher>

#warning-alert[
  This step is still very rough.
  It'll get better once some of my local changes have been upstreamed to
  #github("typst/hypher").
]

The `.tex` pattern files need to be compiled to automata readable by
#link(hypher-repo)[hypher].
First we need to install #link(hypher-repo)[hypher] locally as a binary.
Currently the simplest way of doing so is:
#codesnippet[```sh
# Download the fork of hypher that can compile tries
$ cd /tmp && git clone https://github.com/Vanille-N/hypher.git
# Install it locally
$ cargo install --path hypher --features bin
# Go back to your workspace and check that it works.
$ cd - && hypher --help
```]

I hope that soon this process can be simplified to:
#codesnippet[```sh
$ cargo install hypher --features bin
```]

==== Compile and load the trie <compile-pats>

With `hypher` now installed, run
#codesnippet[```sh
$ mkdir -p tries
$ hypher build patterns/hyph-${iso}.tex tries/${iso}.bin
```]

The resulting file is a valid input for @cmd:hy:trie in the following form:
#codesnippet[```typ
#let trie = hy.trie(
  bin: read("tries/${iso}.bin", encoding: none),
  bounds: hyphenmin,
)
```]
For example to load Galician (```typc "gl"``` patterns), the entire process is:
#codesnippet[```sh
$ hypher build patterns/hyph-gl.tex tries/gl.bin
```]
#codesnippet[```typ
#let trie_gl = hy.trie(
  bin: read("tries/gl.bin", encoding: none),
  bounds: (2, 2),
)
```]


== Loading patterns

Once you have obtained an object of type @type:trie through either
@on-the-fly or @precompiled, you can use it as a #arg[lang] for @cmd:hy:syllables.
#table(
  columns: (68%, 35%),
  stroke: gray + 0.5pt,
  codesnippet[```typ
  #let trie_gl = hy.trie(
    tex: read("patterns/hyph-gl.tex"),
    bounds: (2, 2),
  )
  #hy.syllables("galego", lang: trie_gl)```],
  [
    #let trie_gl = hy.trie(tex: read("patterns/hyph-gl.tex"), bounds: (2, 2))
    #hy.syllables("galego", lang: trie_gl)
  ]
)

=== Manual <load-manual>

If you want to hyphenate a specific piece of text with a pattern,
you could write for example:
#codesnippet[```typ
#let trie_gl = hy.trie(
  bin: read("tries/gl.bin", encoding: none),
  bounds: (2, 2),
)
#show regex("\w+"): word => {
  syllables(word.text, lang: trie_gl).join([-?])
}
#text(lang: "gl")[#my-text]
```]

=== Automatic

Altertatively, you can use @cmd:hy:load-patterns and @cmd:hy:apply-patterns.
Behind the scenes they will perform almost the same manipulation as in @load-manual.
#codesnippet[```typ
#let trie_gl = hy.trie(
  bin: read("tries/gl.bin", encoding: none),
  bounds: (2, 2),
)
#hy.load-patterns(
  gl: trie_gl,
  // accepts multiple pairs in the format 'iso: trie'
)
#show: hy.apply-patterns("gl")
#text(lang: "gl")[#my-text]
```]

= API

#show-module("lib", module: "hy")

= About

== Useful resources

- #link("https://laurmaedje.github.io/posts/hypher/")[How to put 30 Languages Into 1.1MB]
  is the blog post that introduced #github("typst/hypher"),
- #link("https://www.hyphenation.org/") is a repository of hyphenation patterns.

== Dependencies

HY-DRO-GEN is obviously dependent on #github("typst/hypher") its main dependency.
Currently it actually uses a fork #github("Vanille-N/hypher"),
since dynamically loading tries is not supported by #github("typst/hypher"),
but I am open to upstreaming all the features that the Typst project
finds desirable.

This manual is built with #universe("mantys") and #universe("tidy").

