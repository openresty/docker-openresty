#!/bin/bash -x
# Tags an image FLAVOR as ALIAS
#
# ./docker_tag_alias.sh FLAVOR ALIAS
#
# Docker password is in a file /tmp/docker.pass
# because this script uses -x for build transparency
# but we don't want to leak passwords

FLAVOR="$1"
ALIAS="$2"

cat /tmp/docker.pass | docker login -u="$DOCKER_USERNAME" --password-stdin

if [[ "$TRAVIS_BRANCH" == "master" ]] ; then
    docker tag $DOCKER_ORG/openresty:$FLAVOR $DOCKER_ORG/openresty:$ALIAS &&
    docker push $DOCKER_ORG/openresty:$ALIAS ;
fi

if [[ "$TRAVIS_TAG" ]] ; then
    TRAVIS_TAG_BASE=$(echo -n "$TRAVIS_TAG" | sed 's/-[0-9]$//g') ;
    if [[ ( "$TRAVIS_TAG_BASE" ) && ( "$TRAVIS_TAG_BASE" != "$TRAVIS_TAG" ) ]] ; then
    docker tag $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$FLAVOR $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$ALIAS &&
    docker push $DOCKER_ORG/openresty:$TRAVIS_TAG_BASE-$ALIAS ;
    fi ;
    docker tag $DOCKER_ORG/openresty:$TRAVIS_TAG-$FLAVOR $DOCKER_ORG/openresty:$TRAVIS_TAG-$ALIAS &&
    docker push $DOCKER_ORG/openresty:$TRAVIS_TAG-$ALIAS ;
fi

