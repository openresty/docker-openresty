#!/bin/bash -x
# Builds and pushes flavors
#
# ./docker_build_and_push_flavor.sh FLAVOR [DOCKERFILE_PATH] [BUILD PARAMS]
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
DOCKERFILE_PATH=${1:-$FLAVOR/Dockerfile}
shift
DOCKER_BUILD_PARAMS="$@"

cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin

docker build --pull -t openresty:$FLAVOR -f $DOCKERFILE_PATH $DOCKER_BUILD_PARAMS .

if [[ "$TRAVIS_BRANCH" == "master" ]] ; then
    cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin &&
    docker tag openresty:$FLAVOR $DOCKER_ORG/openresty:$FLAVOR &&
    docker push $DOCKER_ORG/openresty:$FLAVOR ;
fi

if [[ "$TRAVIS_TAG" ]] ; then
    TRAVIS_TAG_BASE=$(echo -n "$TRAVIS_TAG" | sed 's/-[0-9]$//g') ;
    if [[ ( "$TRAVIS_TAG_BASE" ) && ( "$TRAVIS_TAG_BASE" != "$TRAVIS_TAG" ) ]] ; then
        cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin &&
        docker tag openresty:$FLAVOR $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$FLAVOR &&
        docker push $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$FLAVOR ;
    fi ;
    cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin &&
    docker tag openresty:$FLAVOR $DOCKER_ORG/openresty:$TRAVIS_TAG-$FLAVOR &&
    docker push $DOCKER_ORG/openresty:$TRAVIS_TAG-$FLAVOR ;
fi

# Push to mirror registry
if [[ "$DOCKER_MIRROR_REGISTRY" == "" ]] ; then
    exit 0 ;
fi

DOCKER_MIRROR="$DOCKER_MIRROR_REGISTRY/$DOCKER_MIRROR_ORG"

if [[ "$TRAVIS_BRANCH" == "master" ]] ; then
    cat /tmp/docker_mirror.pass | docker login -u="$DOCKER_MIRROR_USERNAME" --password-stdin "$DOCKER_MIRROR_REGISTRY" &&
    docker tag openresty:$FLAVOR $DOCKER_MIRROR/openresty:$FLAVOR &&
    docker push $DOCKER_MIRROR/openresty:$FLAVOR ;
fi

if [[ "$TRAVIS_TAG" ]] ; then
    TRAVIS_TAG_BASE=$(echo -n "$TRAVIS_TAG" | sed 's/-[0-9]$//g') ;
    if [[ ( "$TRAVIS_TAG_BASE" ) && ( "$TRAVIS_TAG_BASE" != "$TRAVIS_TAG" ) ]] ; then
        cat /tmp/docker_mirror.pass | docker login -u="$DOCKER_MIRROR_USERNAME" --password-stdin "$DOCKER_MIRROR_REGISTRY" &&
        docker tag openresty:$FLAVOR $DOCKER_MIRROR/openresty:$TRAVIS_TAG_BASE-$FLAVOR &&
        docker push $DOCKER_MIRROR/openresty:$TRAVIS_TAG_BASE-$FLAVOR ;
    fi ;
    cat /tmp/docker_mirror.pass | docker login -u="$DOCKER_MIRROR_USERNAME" --password-stdin "$DOCKER_MIRROR_REGISTRY" &&
    docker tag openresty:$FLAVOR $DOCKER_MIRROR/openresty:$TRAVIS_TAG-$FLAVOR &&
    docker push $DOCKER_MIRROR/openresty:$TRAVIS_TAG-$FLAVOR ;
fi
