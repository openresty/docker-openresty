#!/bin/bash
set -e

# Start GHCR mock
docker run -d -p 5001:5000 --restart=always --name openresty-test-ghcr registry:2
echo "Started openresty-test-ghcr on port 5001"

# Start Docker Hub mock
docker run -d -p 5002:5000 --restart=always --name openresty-test-hub registry:2
echo "Started openresty-test-hub on port 5002"

echo "Registries are running."
