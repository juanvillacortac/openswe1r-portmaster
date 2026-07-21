#!/bin/bash
# Cross-compile inside Ubuntu 20.04 (glibc 2.31) for ArkOS / older PortMaster CFWs.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="${OPENSWE1R_DOCKER_IMAGE:-openswe1r-aarch64-builder:20.04}"

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: docker not found. Install Docker or build on Ubuntu 20.04 with aarch64 cross tools." >&2
    exit 1
fi

echo "== Docker image: $IMAGE =="
docker build -t "$IMAGE" -f "$ROOT/docker/Dockerfile.aarch64" "$ROOT/docker"

echo "== Cross-compiling in container (glibc 2.31 sysroot) =="
docker run --rm \
    -v "$ROOT:/work" \
    -w /work \
    -e OPENSWE1R_PORTABLE_BUILD=1 \
    -e HOME=/tmp \
    "$IMAGE" \
    bash -c 'git config --global --add safe.directory "*" && ./scripts/build-engine.sh'

if [[ -d "$ROOT/openswe1r/build_aarch64" ]] && [[ ! -w "$ROOT/openswe1r/build_aarch64" ]]; then
    echo "Fixing ownership of build_aarch64 (run: sudo chown -R \$USER openswe1r/build_aarch64)" >&2
fi