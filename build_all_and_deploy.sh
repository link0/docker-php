#!/bin/sh

set -e

for version in 5.6 7.0 7.1;
do
  ./build.sh $version;
  ./test.sh $version;
  ./deploy.sh $version;
done

docker tag link0/php:7.1 link0/php:latest;

docker push link0/php:latest;


