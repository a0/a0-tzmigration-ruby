#!/usr/bin/env bash

set -e

cd $(dirname $0)/..

if [ ! -d data ]; then
  rake generate-data
fi

mkdir -p dist
rm -fr dist/*
cp -r docs/* dist
mkdir -p dist/data
cp -r data/timezones data/versions data/index.md dist/data
cd dist
git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:a0/a0-tzmigration-ruby.git master:gh-pages
