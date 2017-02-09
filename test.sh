#!/usr/bin/env bash

VERSION=$1

if [ -z $VERSION ];
then
    echo "usage: test.sh <version>"
    exit 1;
fi

docker run --rm -t -i link0/php:$VERSION php -v;
docker run --rm -t -i link0/php:$VERSION php -m;
