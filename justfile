test:
  typst compile test.typ
  rm test.pdf

doc:
  typst watch --root=. docs/main.typ docs/main.pdf

