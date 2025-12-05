#!/bin/bash
# Test script to verify GitHub Actions workflow logic locally
# This tests a single flavor build without pushing to registry

set -e

FLAVOR="${1:-alpine}"
ARCH="${2:-amd64}"

echo "Testing build for flavor: $FLAVOR, arch: $ARCH"

# Set up buildx if not already configured
if ! docker buildx ls | grep -q "multiarch"; then
  docker buildx create --name multiarch --use
fi

# Example configurations for different flavors
case "$FLAVOR" in
  alpine)
    DOCKERFILE="alpine/Dockerfile"
    PLATFORM="linux/$ARCH"
    BUILD_ARGS=""
    ;;
  alpine-slim)
    DOCKERFILE="alpine/Dockerfile"
    PLATFORM="linux/$ARCH"
    BUILD_ARGS="--build-arg RESTY_STRIP_BINARIES=1"
    ;;
  bookworm)
    DOCKERFILE="bookworm/Dockerfile"
    PLATFORM="linux/$ARCH"
    if [[ "$ARCH" == "arm64" ]]; then
      BUILD_ARGS="--build-arg RESTY_APT_REPO=https://openresty.org/package/arm64/debian --build-arg RESTY_APT_ARCH=arm64"
    else
      BUILD_ARGS=""
    fi
    ;;
  centos)
    DOCKERFILE="centos/Dockerfile"
    PLATFORM="linux/$ARCH"
    if [[ "$ARCH" == "arm64" ]]; then
      BUILD_ARGS="--build-arg RESTY_RPM_ARCH=aarch64"
    else
      BUILD_ARGS=""
    fi
    ;;
  *)
    echo "Add configuration for flavor: $FLAVOR"
    exit 1
    ;;
esac

# Build (but don't push)
docker buildx build \
  --platform "$PLATFORM" \
  --file "$DOCKERFILE" \
  --tag "openresty-test:$FLAVOR-$ARCH" \
  $BUILD_ARGS \
  --load \
  .

echo "✅ Build successful! Image: openresty-test:$FLAVOR-$ARCH"
echo "Test it with: docker run --rm openresty-test:$FLAVOR-$ARCH openresty -v"
