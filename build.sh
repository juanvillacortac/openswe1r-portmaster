#!/bin/bash
# Build OpenSWE1R (submodule) and package a PortMaster-ready zip.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

# Keep launcher/scripts LF-only (CRLF breaks execution on device)
for _sh in "$ROOT/build.sh" "$ROOT"/scripts/*.sh "$ROOT"/port/*.sh; do
  [[ -f "$_sh" ]] && grep -q $'\r' "$_sh" 2>/dev/null && sed -i 's/\r$//' "$_sh"
done

PACKAGE_ONLY=0
SKIP_ZIP=0
CHECK_ONLY=0
USE_DOCKER=1

usage() {
    cat <<'EOF'
Usage: ./build.sh [options]

  (no options)     Init submodule, build aarch64 in Docker, stage port, create zip
  --native         Cross-compile aarch64 on host (needs aarch64-linux-gnu toolchain)
  --package-only   Skip engine build; reuse existing build tree
  --no-zip         Build and stage port/ but do not create dist/openswe1r.zip
  --check          Validate port metadata only (no compile, no zip)
  -h, --help       Show this

Output:
  port/openswe1r/openswe1r.aarch64   (gitignored)
  port/openswe1r/libs.aarch64/       (gitignored; openal optional)
  dist/openswe1r.zip                 (gitignored)

Game files are NOT included. End users copy GOG/Steam assets to openswe1r/game/.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --package-only) PACKAGE_ONLY=1 ;;
    --native) USE_DOCKER=0 ;;
    --no-zip) SKIP_ZIP=1 ;;
    --check) CHECK_ONLY=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 1 ;;
  esac
done

"$ROOT/scripts/init-submodule.sh"

if [[ $CHECK_ONLY -eq 1 ]]; then
    "$ROOT/scripts/package-release.sh" --check
    exit 0
fi

if [[ $PACKAGE_ONLY -eq 0 ]]; then
  if [[ $USE_DOCKER -eq 1 ]]; then
    "$ROOT/scripts/build-engine-docker.sh"
  else
    "$ROOT/scripts/build-engine.sh"
  fi
fi

"$ROOT/scripts/setup-port-layout.sh"
"$ROOT/scripts/package-port.sh"

if [[ $SKIP_ZIP -eq 0 ]]; then
  "$ROOT/scripts/package-release.sh"
fi