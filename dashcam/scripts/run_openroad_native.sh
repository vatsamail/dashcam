#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESIGN_NAME="dashcam_soc_top"
OPENROAD_BIN="${OPENROAD_BIN:-}"

"${ROOT_DIR}/scripts/check_pdk.sh"

if [ -z "${OPENROAD_BIN}" ]; then
  if command -v openroad >/dev/null 2>&1; then
    OPENROAD_BIN="$(command -v openroad)"
  elif [ -x "${ROOT_DIR}/tools/OpenROAD-src/build/src/openroad" ]; then
    OPENROAD_BIN="${ROOT_DIR}/tools/OpenROAD-src/build/src/openroad"
  fi
fi

if [ -z "${OPENROAD_BIN}" ]; then
  echo "OpenROAD binary not found." >&2
  echo "Install OpenROAD or build it under tools/OpenROAD-src (non-docker)." >&2
  echo "If building from source, ensure submodules are fetched:" >&2
  echo "  cd tools/OpenROAD-src && git submodule update --init --recursive" >&2
  echo "  ./etc/Build.sh -no-gui -no-tests" >&2
  exit 2
fi

NETLIST="${ROOT_DIR}/build/synth/dashcam_soc_top_synth.v"
if [ ! -f "${NETLIST}" ]; then
  echo "Synthesis netlist not found: ${NETLIST}" >&2
  echo "Run: make synth" >&2
  exit 2
fi

OUT_DIR="${ROOT_DIR}/pnr/openroad_native"
RPT_DIR="${OUT_DIR}/reports"
LOG_DIR="${OUT_DIR}/logs"
mkdir -p "${OUT_DIR}" "${RPT_DIR}" "${LOG_DIR}"

export DESIGN_NAME
export ROOT_DIR
export OUT_DIR
export RPT_DIR

echo "Running OpenROAD (native) for ${DESIGN_NAME}"
"${OPENROAD_BIN}" -no_init -exit -file "${ROOT_DIR}/flows/openroad/${DESIGN_NAME}/flow.tcl" \
  | tee "${LOG_DIR}/openroad.log"
