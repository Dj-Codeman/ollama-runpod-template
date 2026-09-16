#!/usr/bin/env bash
set -euo pipefail

# Default configuration
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/dj-codeman/ollama-tailnet}"
TAG="${1:-latest}"
PLATFORM="${PLATFORM:-linux/amd64}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo "=========================================="
echo " Building & Publishing Docker Image"
echo " Image:    ${IMAGE_NAME}:${TAG}"
echo " Platform: ${PLATFORM}"
echo "=========================================="

# Check Docker availability
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: 'docker' CLI is not installed or not in PATH." >&2
  exit 1
fi

# Ensure user is authenticated to GHCR if pushing
if [ "${NO_PUSH:-0}" -ne 1 ]; then
  echo "Checking GHCR authentication..."
  if ! docker id >/dev/null 2>&1; then
    echo "Note: If push fails, log into GHCR using: echo \$GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin"
  fi
fi

# Build image
echo "Building image ${IMAGE_NAME}:${TAG}..."
docker build \
  --platform "${PLATFORM}" \
  -t "${IMAGE_NAME}:${TAG}" \
  ${TAG:+"-t" "${IMAGE_NAME}:latest"} \
  -f dockerfile .

echo "Build successful!"

# Push image if not disabled
if [ "${NO_PUSH:-0}" -eq 1 ]; then
  echo "NO_PUSH=1 set; skipping image push."
else
  echo "Pushing image ${IMAGE_NAME}:${TAG} to GHCR..."
  docker push "${IMAGE_NAME}:${TAG}"
  if [ "${TAG}" != "latest" ]; then
    echo "Pushing image ${IMAGE_NAME}:latest to GHCR..."
    docker push "${IMAGE_NAME}:latest"
  fi
  echo "Successfully published ${IMAGE_NAME}:${TAG} and ${IMAGE_NAME}:latest"
fi
