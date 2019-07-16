#!/bin/sh

BASEDIR="$(dirname $0)/../"

for VERSION in $(cat $BASEDIR/versions.txt);
do
    mkdir -p $BASEDIR/build/$VERSION

    cat $BASEDIR/Dockerfile.template | awk -vPHP_VERSION="$VERSION" -f $BASEDIR/ci/template.awk > build/$VERSION/Dockerfile;

    cp -r $BASEDIR/scripts $BASEDIR/build/$VERSION/
done
