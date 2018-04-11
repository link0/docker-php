#!/bin/sh

VERSION=$1

if [ -z $VERSION ];
then
    echo "usage: deploy.sh <version>"
    exit 1;
fi

docker push link0/php:$VERSION
