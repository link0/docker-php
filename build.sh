#!/bin/sh

VERSION=$1

if [ -z $VERSION ];
then
    echo "usage: build.sh <version>"
    exit 1;
fi

rm -rf build/$VERSION;
mkdir -p build/$VERSION;

cat Dockerfile.template | sed "s/PHPVERSION/$VERSION/g" > build/$VERSION/Dockerfile;
cp install_composer.sh build/$VERSION/install_composer.sh;

docker build -t link0/php:$VERSION build/$VERSION

