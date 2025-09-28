typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. --font-path=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/docs.typ")

test T: (typstc "watch" "tests/"+T+"/test.typ")

scrybe:
  scrybe README.md typst.toml docs/docs.typ --version=0.1.2

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.1.2

publish:
  mkdir -p release
  rm -rf release/*
  cp README.md typst.toml lib.typ release/
  cp -r assets release/

