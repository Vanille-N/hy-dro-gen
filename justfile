test:
  typst compile test.typ
  rm test.pdf

doc:
  typst watch --root=. docs/main.typ docs/main.pdf

scrybe:
  scrybe README.md typst.toml --version=0.1.1

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.1.1

publish:
  mkdir -p release
  rm -rf release/*
  cp README.md typst.toml lib.typ release/
  cp -r assets release/

