#!/bin/bash -x
# Creates and pushes manifests for flavors
#
# ./docker_manifest.sh FLAVOR TAG1 ....
#
# Docker password is in a file /tmp/docker.pass
# because this script uses -x for build transparency
# but we don't want to leak passwords
#
# Requires environment variables:
#   DOCKER_ORG
#   DOCKER_USERNAME
#
# Optional environment variables:
#   DOCKER_MIRROR_REGISTRY
#   DOCKER_MIRROR_ORG
#   DOCKER_MIRROR_USERNAME
#
# Files:
#   /tmp/docker.pass
#   /tmp/docker_mirror.pass

set -e

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

# Push to mirror registry
if [[ "$DOCKER_MIRROR_REGISTRY" == "" ]] ; then
    exit 0 ;
fi

cat /tmp/docker_mirror.pass | docker login -u="$DOCKER_MIRROR_USERNAME" --password-stdin "$DOCKER_MIRROR_REGISTRY"

DOCKER_MIRROR="$DOCKER_MIRROR_REGISTRY/$DOCKER_MIRROR_ORG"

AMENDS=""
for TAG in "$@"; do
    AMENDS="$AMENDS --amend $DOCKER_MIRROR/openresty:$TAG"
done

if [[ "$TRAVIS_BRANCH" == "master" ]] ; then
    docker manifest create $DOCKER_MIRROR/openresty:$FLAVOR $AMENDS &&
        docker manifest push $DOCKER_MIRROR/openresty:$FLAVOR ;
fi

if [[ "$TRAVIS_TAG" ]] ; then
    TRAVIS_TAG_BASE=$(echo -n "$TRAVIS_TAG" | sed 's/-[0-9]$//g') ;
    if [[ ( "$TRAVIS_TAG_BASE" ) && ( "$TRAVIS_TAG_BASE" != "$TRAVIS_TAG" ) ]] ; then
        AMENDS_TAG_BASE=""
        for TAG in "$@"; do
            AMENDS_TAG_BASE="$AMENDS_TAG_BASE --amend $DOCKER_MIRROR/openresty:$TRAVIS_TAG_BASE-$TAG"
        done
        docker manifest create $DOCKER_MIRROR/openresty:$TRAVIS_TAG_BASE-$FLAVOR $AMENDS_TAG_BASE &&
        docker manifest push $DOCKER_MIRROR/openresty:$TRAVIS_TAG_BASE-$FLAVOR ;
    fi ;
    AMENDS_TAG=""
    for TAG in "$@"; do
        AMENDS_TAG="$AMENDS_TAG --amend $DOCKER_MIRROR/openresty:$TRAVIS_TAG-$TAG"
    done
    docker manifest create $DOCKER_MIRROR/openresty:$TRAVIS_TAG-$FLAVOR $AMENDS_TAG &&
    docker manifest push $DOCKER_MIRROR/openresty:$TRAVIS_TAG-$FLAVOR ;
fi
