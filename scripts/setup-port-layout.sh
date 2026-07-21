#!/bin/bash
# Create empty PortMaster folder layout under port/openswe1r/.
# Does NOT copy game files — the end user installs GOG/Steam assets into game/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="$ROOT/port/openswe1r"

mkdir -p "$PORT/game" "$PORT/conf" "$PORT/licenses" "$PORT/libs.aarch64"

write_placeholder() {
    local dir="$1"
    local text="$2"
    mkdir -p "$dir"
    local file="$dir/README.txt"
    if [[ ! -f "$file" ]]; then
        printf '%s\n' "$text" >"$file"
        echo "  $(realpath --relative-to="$PORT" "$dir")/README.txt"
    fi
}

echo "== Port layout at $PORT =="

write_placeholder "$PORT/game" \
"Star Wars: Episode I Racer game files (GOG or Steam).

Copy your install here. Typical layout from the Windows CD/GOG install:
  Data/         level data, sounds
  install.lid  locale id
  swep1r.exe   not required ( engine uses its own loader )

OpenSWE1R loads the original exe to extract art/race assets via x86 emulation.
Place swep1r.exe alongside the data files."

write_placeholder "$PORT/conf" \
"OpenSWE1R saves and settings (conf/openswe1r/). Created when you play."

touch "$PORT/libs.aarch64/.gitkeep"

echo ""
echo "Done. Game data is NOT included — copy GOG/Steam files to game/ on the device."
echo "Build and package: ./build.sh"