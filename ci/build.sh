#!/bin/sh

VERSION=$1

if [ -z $VERSION ];
then
    echo "usage: build.sh <version>"
    exit 1;
fi

docker build -t link0/php:$VERSION build/$VERSION

