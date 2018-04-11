#!/bin/sh

set -e

for version in 7.0 7.1 7.2;
do
  ./build.sh $version;
  ./test.sh $version;
  ./deploy.sh $version;
done

docker tag link0/php:7.2 link0/php:latest;
docker push link0/php:latest;


