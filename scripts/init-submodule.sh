#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENGINE="$ROOT/openswe1r"

if [[ -d "$ROOT/.git" ]]; then
    git -C "$ROOT" submodule update --init --recursive --depth 1
elif [[ ! -f "$ENGINE/CMakeLists.txt" ]]; then
    cat >&2 <<EOF
Engine submodule missing.

  git clone --recurse-submodules <this-repo-url>
  # or, in an existing clone:
  git submodule update --init --recursive

Manual fallback:
  git clone https://github.com/juanvillacortac/openswe1r.git openswe1r
EOF
    exit 1
fi

if [[ ! -f "$ENGINE/CMakeLists.txt" ]]; then
    echo "ERROR: $ENGINE/CMakeLists.txt not found after submodule init." >&2
    exit 1
fi