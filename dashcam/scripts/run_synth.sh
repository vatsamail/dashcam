#!/usr/bin/env bash
set -euo pipefail
if ! command -v yosys >/dev/null 2>&1; then
  echo "yosys not found. Install yosys for synthesis." >&2
  exit 2
fi

if [ -z "${PDK_ROOT:-}" ]; then
  CIEL_ROOT="${HOME}/.ciel/ciel/sky130/versions"
  if [ -d "${CIEL_ROOT}" ]; then
    FOUND="$(find "${CIEL_ROOT}" -maxdepth 2 -type d -name sky130A 2>/dev/null | head -n 1 || true)"
    if [ -n "${FOUND}" ]; then
      export PDK_ROOT="$(dirname "${FOUND}")"
      echo "PDK_ROOT not set. Using detected PDK_ROOT=${PDK_ROOT}"
    fi
  fi
fi

SRAM_V="${PDK_ROOT}/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_1kbyte_1rw1r_32x256_8.v"
if [ ! -f "${SRAM_V}" ]; then
  echo "SRAM macro verilog not found at ${SRAM_V}." >&2
  echo "Install Sky130 PDK first (make -C tools/OpenLane pdk)." >&2
  exit 2
fi

mkdir -p build/synth

FILES=(
  top/dashcam_top/rtl/dashcam_soc_top.sv
  ips/camera_capture/camera_capture.v
  ips/simple_dma/simple_dma.v
  ips/simple_sram/simple_sram.v
  ips/irq_ctrl/irq_ctrl.v
  ips/iomux/iomux.v
  ips/sdspi_stub/sdspi_stub_bb.v
  ips/reset_sync/reset_sync.v
  fips/wb_intercon/rtl/wb_mux.v
  third_party/picorv32/picorv32.v
  ips/csr_regs/rtl/dashcam_csr_regs.sv
  "${SRAM_V}"
)

YOSYS_CMD="read_verilog -sv -D USE_SRAM_MACRO -I ips/csr_regs/rtl"
for f in "${FILES[@]}"; do
  YOSYS_CMD+=" ${f}"
done
YOSYS_CMD+="; synth -top dashcam_soc_top; write_verilog build/synth/dashcam_soc_top_synth.v"

yosys -p "${YOSYS_CMD}"

echo "Synthesis complete: build/synth/dashcam_soc_top_synth.v"
