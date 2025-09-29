#import "/lib.typ" as hy

#let sample = [
  #set text(lang: "gl")
  Toda persoa ten os dereitos e liberdades proclamados nesta
  Declaración, sen distinción ningunha de raza, cor, sexo, idioma,
  relixión, opinión política ou de calquera outra índole, orixe nacianal ou
  social, posición económica, nacemento ou calquera outra condición.
  Ademais, non se fará ningunha distinción baseado na condición
  política, xurídica ou internacional do país ou territoiro da xuridicción
  do cal dependa unha persoa, tanto se se trata dun país independente
  coma dun territorio baixo administración fiduciaria, non autónomo ou
  sometido a calquera outra limitación de soberanía.
]

#set par(justify: true)

#table(columns: (5cm, 5cm))[
  #sample
][
  #let trie_gl = hy.trie(bin: read("gl.bin", encoding: none), bounds: (2, 2))
  #hy.load-patterns(gl: trie_gl)
  #show: hy.apply-patterns("gl")
  #sample
]
