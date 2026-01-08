#!/bin/bash
# Creates and pushes manifests for flavors
#
# Usage: ./create-manifest.sh <flavor> <registry_image> <mirror_image> <mirror_enable_bool>
# Example: ./create-manifest.sh alpine ghcr.io/owner/repo docker.io/owner/repo true

set -e


FLAVOR="$1"
REGISTRY_IMAGE="$2"
MIRROR_IMAGE="$3"
ENABLE_MIRROR="$4"

# Validate inputs
if [[ -z "$FLAVOR" ]]; then
  echo "Error: Flavor argument is missing."
  exit 1
fi

if [[ -z "$REGISTRY_IMAGE" ]]; then
  echo "Error: Registry image argument is missing."
  exit 1
fi

# Define architectures for each flavor
# Default to amd64 and arm64
ARCHS="amd64 arm64"

# Add s390x for Ubuntu flavors
UBUNTU_FLAVORS=("bionic" "focal" "jammy" "noble")
for ub_flavor in "${UBUNTU_FLAVORS[@]}"; do
    if [[ "$FLAVOR" == "$ub_flavor" ]]; then
        ARCHS="$ARCHS s390x"
        break
    fi
done

# Fedora only supports amd64 in this setup
if [[ "$FLAVOR" == "fedora" ]]; then
  ARCHS="amd64"
fi

echo "Creating manifest for flavor: $FLAVOR (Architectures: $ARCHS)"

# Construct tag prefixes (handling git tags and aliases)
declare -a PREFIXES=()
if [[ "$GITHUB_REF_TYPE" == "tag" ]]; then
    TAG_NAME="$GITHUB_REF_NAME"
    PREFIXES+=("${TAG_NAME}-")
    
    # Aliasing logic: Matches tags ending in single digit revision (e.g. 1.2.1-1 -> 1.2.1)
    # If the tag matches the pattern (.*)-[0-9]$, we creates an alias for the base (group 1)
    if [[ "$TAG_NAME" =~ ^(.*)-[0-9]$ ]]; then
        TAG_BASE="${BASH_REMATCH[1]}"
        if [[ "$TAG_BASE" != "$TAG_NAME" ]]; then
           PREFIXES+=("${TAG_BASE}-")
        fi
    fi
else
    # For master branch or other non-tags, we use an empty prefix to just tag as "flavor"
    PREFIXES+=("")
fi

# Loop through each calculated tag prefix and create manifests
for TAG_PREFIX in "${PREFIXES[@]}"; do
    SOURCES=""
    MIRROR_SOURCES=""
    
    # Collect source images for all architectures
    for ARCH in $ARCHS; do
        SOURCES="$SOURCES ${REGISTRY_IMAGE}:${TAG_PREFIX}${FLAVOR}-${ARCH}"
        if [[ "$ENABLE_MIRROR" == "true" ]]; then
            MIRROR_SOURCES="$MIRROR_SOURCES ${MIRROR_IMAGE}:${TAG_PREFIX}${FLAVOR}-${ARCH}"
        fi
    done
  
    # Target Manifest Tag
    TARGET_TAG="${TAG_PREFIX}${FLAVOR}"
    
    # 1. Create GHCR Manifest
    echo "Creating manifest ${REGISTRY_IMAGE}:$TARGET_TAG"
    # Note: docker buildx imagetools create automatically pushes the manifest to the registry.
    docker buildx imagetools create -t "${REGISTRY_IMAGE}:$TARGET_TAG" $SOURCES
    
    # 2. Create Mirror Manifest (if enabled)
    if [[ "$ENABLE_MIRROR" == "true" ]]; then
       echo "Creating mirror manifest ${MIRROR_IMAGE}:$TARGET_TAG"
       if [[ "$DRY_RUN" != "true" ]]; then
           docker buildx imagetools create -t "${MIRROR_IMAGE}:$TARGET_TAG" $MIRROR_SOURCES
       else
           echo "DRY RUN: docker buildx imagetools create -t \"${MIRROR_IMAGE}:$TARGET_TAG\" $MIRROR_SOURCES"
       fi
    fi
    
    # 3. Handle specific "latest" tag logic for bookworm on master
    if [[ "$FLAVOR" == "bookworm" && "$GITHUB_REF" == "refs/heads/master" && "$TAG_PREFIX" == "" ]]; then
       echo "Tagging bookworm as latest"
       if [[ "$DRY_RUN" != "true" ]]; then
           docker buildx imagetools create -t "${REGISTRY_IMAGE}:latest" "${REGISTRY_IMAGE}:bookworm"
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              docker buildx imagetools create -t "${MIRROR_IMAGE}:latest" "${MIRROR_IMAGE}:bookworm"
           fi
       else 
           echo "DRY RUN: docker buildx imagetools create -t \"${REGISTRY_IMAGE}:latest\" \"${REGISTRY_IMAGE}:bookworm\""
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              echo "DRY RUN: docker buildx imagetools create -t \"${MIRROR_IMAGE}:latest\" \"${MIRROR_IMAGE}:bookworm\""
           fi
       fi
    fi
    
    # 4. Create compatibility aliases (centos-rpm -> centos, etc.)
    # Note: Logic slightly adjusted from YAML to be generic if needed, 
    # but sticking to specific requested aliases for now.
    
    if [[ "$FLAVOR" == "centos" ]]; then
       ALIAS_TAG="${TAG_PREFIX}centos-rpm"
       echo "Creating alias $ALIAS_TAG -> $TARGET_TAG"
       if [[ "$DRY_RUN" != "true" ]]; then
           docker buildx imagetools create -t "${REGISTRY_IMAGE}:$ALIAS_TAG" "${REGISTRY_IMAGE}:$TARGET_TAG"
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              docker buildx imagetools create -t "${MIRROR_IMAGE}:$ALIAS_TAG" "${MIRROR_IMAGE}:$TARGET_TAG"
           fi
       else
           echo "DRY RUN: docker buildx imagetools create -t \"${REGISTRY_IMAGE}:$ALIAS_TAG\" \"${REGISTRY_IMAGE}:$TARGET_TAG\""
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              echo "DRY RUN: docker buildx imagetools create -t \"${MIRROR_IMAGE}:$ALIAS_TAG\" \"${MIRROR_IMAGE}:$TARGET_TAG\""
           fi
        fi
    fi

    if [[ "$FLAVOR" == "fedora" ]]; then
       ALIAS_TAG="${TAG_PREFIX}fedora-rpm"
       echo "Creating alias $ALIAS_TAG -> $TARGET_TAG"
       if [[ "$DRY_RUN" != "true" ]]; then
           docker buildx imagetools create -t "${REGISTRY_IMAGE}:$ALIAS_TAG" "${REGISTRY_IMAGE}:$TARGET_TAG"
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              docker buildx imagetools create -t "${MIRROR_IMAGE}:$ALIAS_TAG" "${MIRROR_IMAGE}:$TARGET_TAG"
           fi
       else
           echo "DRY RUN: docker buildx imagetools create -t \"${REGISTRY_IMAGE}:$ALIAS_TAG\" \"${REGISTRY_IMAGE}:$TARGET_TAG\""
           if [[ "$ENABLE_MIRROR" == "true" ]]; then
              echo "DRY RUN: docker buildx imagetools create -t \"${MIRROR_IMAGE}:$ALIAS_TAG\" \"${MIRROR_IMAGE}:$TARGET_TAG\""
           fi
       fi
    fi
done

echo "Manifest creation complete for $FLAVOR"
