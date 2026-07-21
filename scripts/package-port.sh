#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_A64="$ROOT/openswe1r/build_aarch64"
PORT="$ROOT/port/openswe1r"

if [ ! -f "$BUILD_A64/openswe1r" ]; then
    echo "aarch64 binary missing. Run: ./build.sh" >&2
    exit 1
fi

mkdir -p "$PORT/libs.aarch64"

"$ROOT/scripts/setup-port-layout.sh"

cp "$BUILD_A64/openswe1r" "$PORT/openswe1r.aarch64"
chmod +x "$PORT/openswe1r.aarch64"

copy_lib() {
    local dest="$1"
    local src="$2"
    if [ -f "$src" ]; then
        cp -u "$src" "$dest/"
    fi
}

# Do not bundle SDL/SDL_mixer — PortMaster CFWs ship their own (kmsdrm, audio, etc.).
purge_bundled_sdl_libs() {
    local dest="$1"
    rm -f "$dest"/libSDL2*.so* 2>/dev/null || true
}

purge_bundled_sdl_libs "$PORT/libs.aarch64"

# Bundle openal if the engine build produced a .so (statically linked otherwise)
copy_lib "$PORT/libs.aarch64" "$BUILD_A64/openal/libopenal.so"
copy_lib "$PORT/libs.aarch64" "$BUILD_A64/libopenal.so"
copy_lib "$PORT/libs.aarch64" "$BUILD_A64/lib/libopenal.so"

"$ROOT/scripts/verify-glibc.sh" "$PORT/openswe1r.aarch64" "$PORT/libs.aarch64"

echo "Port staged at: $PORT"
echo "  - openswe1r.aarch64"
echo "  - libs.aarch64/ ($(ls "$PORT/libs.aarch64" 2>/dev/null | wc -l)) entries"
echo ""
echo "Create zip: ./build.sh --package-only   (if engine already built)"
echo "         or: ./scripts/package-release.sh"