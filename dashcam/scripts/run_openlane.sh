#!/usr/bin/env bash
set -euo pipefail
OPENLANE_ROOT="tools/OpenLane"
if [ ! -x "${OPENLANE_ROOT}/flow.tcl" ]; then
  echo "OpenLane not found at ${OPENLANE_ROOT}. Please install it under tools/OpenLane." >&2
  exit 2
fi
./scripts/check_pdk.sh

DESIGN_NAME="dashcam_soc_top"
DESIGN_DIR="flows/openlane/${DESIGN_NAME}"
TARGET_DIR="${OPENLANE_ROOT}/designs/${DESIGN_NAME}"

mkdir -p "${TARGET_DIR}"
cp "${DESIGN_DIR}/config.tcl" "${TARGET_DIR}/config.tcl"

echo "Running OpenLane for ${DESIGN_NAME}"
if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found. OpenLane classic requires Docker for full PnR flow." >&2
  echo "Install Docker Desktop and rerun: make pnr" >&2
  exit 2
fi
export PDK=sky130A
make -C "${OPENLANE_ROOT}" test TEST_DESIGN="${DESIGN_NAME}" PDK_ROOT="${PDK_ROOT}"
