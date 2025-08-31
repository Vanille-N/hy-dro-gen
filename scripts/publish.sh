#! /usr/bin/env bash

mkdir -p release
rm -rf release/*

cp lib.typ release/
cp typst.toml release/
cp README.md release/
cp LICENSE release/

cp -r assets release/

