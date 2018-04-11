#!/bin/sh

set -e

./ci/prepare.sh

for version in $(cat versions.txt);
do
  ./ci/build.sh $version;
  ./ci/test.sh $version;
  ./ci/deploy.sh $version;
done

docker tag link0/php:$(cat versions.txt | tail -1) link0/php:latest;
docker push link0/php:latest;


