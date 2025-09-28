test:
  typst compile test.typ
  rm test.pdf

doc:
  typst watch --root=. --font-path=docs/fonts docs/docs.typ docs/docs.pdf

scrybe:
  scrybe README.md typst.toml docs/docs.typ --version=0.1.2

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.1.2

publish:
  mkdir -p release
  rm -rf release/*
  cp README.md typst.toml lib.typ release/
  cp -r assets release/

