#!/usr/bin/env bash

cd $(dirname $0)/..

date

if [ ! -d data ]; then
  rake generate-data
fi

BASE=$(pwd)
LAST_VERSION=$(pwd)/last.txt
CURR_VERSION=$(pwd)/curr.txt

cd data/repo/tzinfo-data
git pull
git describe > $CURR_VERSION

cd $BASE
diff $LAST_VERSION $CURR_VERSION && echo "Nothing changed" || (echo "Auto updating" && rake generate-data && bin/a0-ghpages-publish.sh && cp $CURR_VERSION $LAST_VERSION && echo "updated to $(cat $CURR_VERSION)" | mail -s hola github@a0.cl)
