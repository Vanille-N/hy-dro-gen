#! /usr/bin/env bash

REPO="typst/hypher"
BRANCH="main"
FILE="src/lang.rs"
URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${FILE}"

curl "$URL" |
  grep '=> Some(Self' |
  sed -E 's/.*"([a-z]{2})".*::([A-Za-z]+).*/\1 \2/' |
  tee languages.txt
