#!/bin/bash
set -e

# Ensure registries are running
if ! docker ps | grep -q openresty-test-ghcr; then
    echo "Starting registries..."
    ./tests/e2e/start-registries.sh
fi

echo "Running E2E test with act..."
# We use --network host to allow the buildx container to reach localhost registries
# We specify the workflow file explicitly
act workflow_dispatch \
    -W tests/e2e/local-test.yml \
    --container-architecture linux/amd64 \
    --bind \
    --network host

echo "Test complete. Verifying images..."
docker pull localhost:5001/neomantra/openresty:alpine-apk-test-amd64
docker pull localhost:5002/openresty/openresty:alpine-apk-test-amd64

echo "✅ verification successful!"
