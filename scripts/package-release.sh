#!/bin/bash
# Create dist/openswe1r.zip with PortMaster metadata (no game files).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="$ROOT/port"
OUT="$ROOT/dist"
ZIP_NAME="openswe1r.zip"
CHECK_ONLY=0
STRICT=0

for arg in "$@"; do
    case "$arg" in
        --check) CHECK_ONLY=1 ;;
        --strict) STRICT=1 ;;
        -h|--help)
            echo "Usage: $0 [--check] [--strict]"
            echo "  --check   Validate metadata only"
            echo "  --strict  Require binary and screenshot before zipping"
            exit 0
            ;;
    esac
done

LAUNCHER="$PORT/Star Wars Episode I Racer.sh"
if [[ -f "$LAUNCHER" ]] && grep -q $'\r' "$LAUNCHER" 2>/dev/null; then
    sed -i 's/\r$//' "$LAUNCHER"
    echo "Normalized launcher line endings (CRLF -> LF)"
fi

section() { echo ""; echo "== $* =="; }
ok()   { echo "  [OK]   $*"; }
warn() { echo "  [WARN] $*"; }
bad()  { echo "  [FAIL] $*"; exit 1; }

section "PortMaster metadata"
[[ -f "$PORT/port.json" ]] && ok "port.json" || bad "Missing $PORT/port.json"
[[ -f "$PORT/gameinfo.xml" ]] && ok "gameinfo.xml" || bad "Missing $PORT/gameinfo.xml"
[[ -f "$PORT/README.md" ]] && ok "README.md" || bad "Missing $PORT/README.md"
[[ -f "$LAUNCHER" ]] && ok "launcher .sh" || bad "Missing launcher"
[[ -f "$PORT/screenshot.png" || -f "$PORT/screenshot.jpg" ]] \
    && ok "screenshot present" \
    || warn "Missing screenshot.png (required for PortMaster catalogue)"
[[ -f "$PORT/cover.png" || -f "$PORT/cover.jpg" ]] \
    && ok "cover present" \
    || warn "Missing cover.png (optional; gameinfo.xml references ./cover.png)"

BINARY="$PORT/openswe1r/openswe1r.aarch64"
if [[ -f "$BINARY" ]]; then
    ok "openswe1r.aarch64 staged"
else
    warn "openswe1r.aarch64 missing — run ./build.sh before releasing"
    [[ $STRICT -eq 1 ]] && bad "Strict mode: binary required"
fi

if [[ $CHECK_ONLY -eq 1 ]]; then
    echo ""
    echo "Metadata check done."
    exit 0
fi

[[ -f "$BINARY" ]] || bad "Cannot create zip without openswe1r.aarch64 (run ./build.sh)"

for asset in screenshot.jpg screenshot.png cover.jpg cover.png; do
    if [[ ! -f "$PORT/$asset" && -f "$PORT/openswe1r/$asset" ]]; then
        cp "$PORT/openswe1r/$asset" "$PORT/$asset"
        echo "Copied openswe1r/$asset → port/$asset (PortMaster layout)"
    fi
done

section "Create release zip"
mkdir -p "$OUT"
ZIP_PATH="$OUT/$ZIP_NAME"
rm -f "$ZIP_PATH"

(
    cd "$PORT"
    FILES=(
        "Star Wars Episode I Racer.sh"
        "openswe1r"
        "port.json"
        "README.md"
        "gameinfo.xml"
    )
    [[ -f screenshot.png ]] && FILES+=("screenshot.png")
    [[ -f screenshot.jpg ]] && FILES+=("screenshot.jpg")
    [[ -f cover.png ]] && FILES+=("cover.png")
    [[ -f cover.jpg ]] && FILES+=("cover.jpg")

    zip -r "$ZIP_PATH" "${FILES[@]}"
)

ok "Created $ZIP_PATH ($(du -h "$ZIP_PATH" | cut -f1))"
echo ""
echo "Install on device:"
echo "  unzip $ZIP_PATH -d /userdata/roms/ports/"
echo "  Copy Racer game files to .../ports/openswe1r/game/"