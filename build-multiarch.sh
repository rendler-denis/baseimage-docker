#!/bin/bash
set -e
set -x

if [[ $TRAVIS_PULL_REQUEST == 'false' ]]; then 

for arch in $ARCHS; do
    echo ${arch}
    docker pull $NAME:$VERSION-${arch}

    if [[ $TAG_LATEST != 'true' ]]; then 
        docker manifest create --amend $NAME:$VERSION $NAME:$VERSION-${arch}
        docker manifest annotate $NAME:$VERSION $NAME:$VERSION-${arch} --arch ${arch}
    else
        docker manifest create --amend $NAME:latest $NAME:$VERSION-${arch}
        docker manifest annotate $NAME:latest $NAME:$VERSION-${arch} --arch ${arch}
    fi
done

echo "Push manifests"
if [[ $TAG_LATEST != 'true' ]]; then 
    docker manifest push $NAME:$VERSION
else
    docker manifest push $NAME:latest
fi

fi