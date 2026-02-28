# Dataset Manifest (Sky130 Flow)

## In-Repo (Provided)
- RTL/IPs: `ips/`, `fips/`, `top/dashcam_top/rtl/`
- CSR SystemRDL: `ips/csr_regs/dashcam_csr.rdl`
- Generated CSR collateral: `ips/csr_regs/rtl/`, `sw/include/`, `ips/csr_regs/ipxact/`, `docs/specs/`
- Smoke sim: `dv/sim/verilator_smoke/`
- Constraints: `constraints/sky130/dashcam_soc_top.sdc`
- Power intent: `power/sky130/dashcam_soc_top.upf`
- OpenLane config: `flows/openlane/dashcam_soc_top/config.tcl` (docker path)
- OpenROAD native flow: `flows/openroad/dashcam_soc_top/flow.tcl`

## External (Must be installed)
- Sky130A PDK (open source)
- OpenROAD toolchain (native, non-docker)
- DRC/LVS decks (Sky130)
- Standard cell libs (.lib/.lef)
- SRAM macros (if using compiled memories)

## Tool Targets
- `make regs`: CSR generation
- `make sw`: firmware stub
- `make sim`: smoke sim
- `make synth`: synthesis (requires toolchain)
- `make openroad`: build native OpenROAD from `tools/OpenROAD-src` (non-docker)
- `make pnr`: place & route via OpenROAD (requires toolchain)
- `make signoff`: signoff checks (requires PDK + decks)

## Local Placeholders
- `pdk/sky130/` : PDK install instructions
- `libs/sky130/` : stdcell/tech LEF + LIB drop location
- `dft/` : DFT artifacts
- `pnr/` : DEF/GDS and routing artifacts
- `sdf/` : SDF outputs
- `signoff/` : signoff reports
- `mem/` : memory macros and models

## OpenROAD Notes
- Native PnR uses `scripts/run_openroad_native.sh` and expects an OpenROAD binary in `PATH` or `tools/OpenROAD-src/build/src/openroad`.
- If building OpenROAD from source, fetch submodules first: `git submodule update --init --recursive`.
- Local Lemon install (if brew formula fails): `tools/lemon-graph/.install`.

## Synthesis Notes
- `ips/simple_sram/simple_sram_bb.v` and `ips/sdspi_stub/sdspi_stub_bb.v` are used for synthesis/PnR.
- Full behavioral models are used only for simulation.

## Memory Macro
- Using Sky130 SRAM macro: sky130_sram_1kbyte_1rw1r_32x256_8
