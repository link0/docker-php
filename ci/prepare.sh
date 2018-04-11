#!/bin/sh

BASEDIR="$(dirname $0)/../"

for VERSION in $(cat $BASEDIR/versions.txt);
do
    mkdir -p $BASEDIR/build/$VERSION

    cat $BASEDIR/Dockerfile.template | sed "s/PHPVERSION/$VERSION/g" > build/$VERSION/Dockerfile;

    cp -r $BASEDIR/scripts $BASEDIR/build/$VERSION/
done
