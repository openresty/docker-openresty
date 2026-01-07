# AGENTS.md

## Repository Overview
This repository contains the Docker tooling and Dockerfiles for OpenResty. It supports multiple Linux distributions (Alpine, Ubuntu, Debian, CentOS, Fedora, etc.) and architectures (amd64, arm64, s390x).

## CI/CD Architecture
The project has migrated from Travis CI to **GitHub Actions**.

### Workflow
The primary workflow is defined in `.github/workflows/docker-publish.yml`.
- **Primary Registry**: GitHub Container Registry (GHCR). All images are built and pushed here first.
- **Mirror Registry**: Docker Hub (`openresty/openresty`). This is configured as a mirror. Pushing to Docker Hub is optional and controlled by the `ENABLE_DOCKERHUB_MIRROR` variable/secret.
- **Fat Images**: "Fat" images (containing additional build tools like OPM) are built in a second stage (`build-fat` job), using the base images newly published to GHCR.

### Workflows
- `docker-publish.yml`: Handles building, testing (implicit in build), and publishing images. Uses a matrix strategy for different flavors and architectures.

## Verification
A test script `test-build-actions.sh` is provided to verify the build process locally or in CI.

## Key Files
- `.github/workflows/docker-publish.yml`: Main CI definition.
- `README.md`: User-facing documentation.
- `test-build-actions.sh`: Build verification script.

## Historical Context
- Previously used Travis CI (`.travis.yml` - removed).
- Windows builds are/were handled by AppVeyor (`appveyor.yml` - still present).
