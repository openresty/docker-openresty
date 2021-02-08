#!/bin/bash -x
# Creates and pushes and pushes manifests flavors
#
# ./docker_manifest.sh FLAVOR TAG1 ....
#
# Docker password is in a file /tmp/docker.pass
# because this script uses -x for build transparency
# but we don't want to leak passwords

FLAVOR="$1"
shift

AMENDS=""
for TAG in "$@"; do
    AMENDS="$AMENDS --amend $DOCKER_ORG/openresty:$TAG"
done

export DOCKER_CLI_EXPERIMENTAL=enabled

cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin

if [[ "$TRAVIS_BRANCH" == "master" ]] ; then
    docker manifest create $DOCKER_ORG/openresty:$FLAVOR $AMENDS &&
        docker manifest push $DOCKER_ORG/openresty:$FLAVOR ;
fi

if [[ "$TRAVIS_TAG" ]] ; then
    TRAVIS_TAG_BASE=$(echo -n "$TRAVIS_TAG" | sed 's/-[0-9]$//g') ;
    if [[ ( "$TRAVIS_TAG_BASE" ) && ( "$TRAVIS_TAG_BASE" != "$TRAVIS_TAG" ) ]] ; then
        AMENDS_TAG_BASE=""
        for TAG in "$@"; do
            AMENDS_TAG_BASE="$AMENDS_TAG_BASE --amend $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$TAG"
        done
        docker manifest create $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$FLAVOR $AMENDS_TAG_BASE &&
        docker manifest push $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$FLAVOR ;
    fi ;
    AMENDS_TAG=""
    for TAG in "$@"; do
        AMENDS_TAG="$AMENDS_TAG --amend $DOCKER_ORG/openresty:$TRAVIS_TAG-$TAG"
    done
    docker manifest create $DOCKER_ORG/openresty:$TRAVIS_TAG-$FLAVOR $AMENDS_TAG &&
    docker manifest push $DOCKER_ORG/openresty:$TRAVIS_TAG-$FLAVOR ;
fi
