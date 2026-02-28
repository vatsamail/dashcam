#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENROAD_DIR="${ROOT_DIR}/tools/OpenROAD-src"

if [ ! -d "${OPENROAD_DIR}" ]; then
  echo "OpenROAD source not found at ${OPENROAD_DIR}" >&2
  exit 2
fi

echo "Updating OpenROAD submodules..."
git -C "${OPENROAD_DIR}" submodule update --init --recursive

echo "Building OpenROAD (native, no GUI/tests)..."
cd "${OPENROAD_DIR}"
./etc/Build.sh -no-gui -no-tests
