test:
  typst compile test.typ
  rm test.pdf

doc:
  typst watch doc.typ

