#! /usr/bin/env bash

mkdir -p release
rm -rf release/*

cp lib.typ release/
cp typst.toml release/
cp README.md release/

cp languages.txt release/
mkdir release/hypher-bindings
cp hypher-bindings/hypher.wasm release/hypher-bindings/

