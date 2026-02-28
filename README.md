# Dashcam SoC (Mock, Pre-Silicon)

Dashcam SoC is a compact, Wishbone-based RISC-V SoC intended for flow development, integration bring-up, and methodology validation. It is deliberately small and deterministic so you can iterate quickly while still exercising realistic SoC integration patterns.

This repository is a sandbox for internal experimentation. It is not production-ready and should not be used for real products.

**Goal**
- Provide a small but representative SoC for fast compile/sim/synth/PnR iterations.
- Exercise CSR generation, IP integration, and end-to-end flow automation.
- Keep the design understandable and modifiable for rapid methodology experiments.

**Go-To Diagram**
- `overall.md` is the canonical architecture diagram and quick reference.
- `block_diagram/dashcam.png` is the visual diagram asset.

**What This Repo Contains**
- `top/dashcam_top/` top-level SoC RTL, testbench, and integration collateral.
- `ips/` RTL IP blocks used by the top-level SoC.
- `fips/` foundation IP such as the Wishbone interconnect.
- `dv/` simulation testbenches and smoke tests.
- `sw/` firmware/software build targets used by the system.
- `constraints/` and `power/` SDC/UPF collateral for Sky130.
- `flows/` OpenROAD and OpenLane flow configs.
- `scripts/` flow helpers: reggen, synth, pnr, signoff, dft, cdc/rdc, lec.
- `third_party/` vendored IP (picoRV32).
- `docs/` architecture/specs/how-tos; `documents/` reference notes.
- `block_diagram/` diagram assets.
- `pdk/`, `pnr/`, `signoff/`, `dft/`, `sdf/`, `mem/`, `libs/`, `build/`, `yard/` workflow outputs or placeholders.

**Architecture Summary**
- Wishbone bus with two slaves: CSR window at `0x1000_0000` and SRAM window at `0x2000_0000`.
- Optional RISC-V CPU (`picorv32_wb`) or an external Wishbone master (`USE_CPU=0` default).
- Camera stream (`cam_valid`, `cam_sof`, `cam_pixel[7:0]`) feeds `camera_capture` and `simple_dma`.
- DMA writes pixels into `simple_sram` and asserts a single IRQ on completion.
- SD storage is a simulation stub (`sdspi_stub`).
- Single clock, async reset assert with sync deassert (`reset_sync`).

**CSR Map (Base `0x1000_0000`)**

| Name | Address | Access | Description |
|---|---:|---|---|
| CTRL | 0x1000_0000 | rw | [0] camera enable, [1] DMA start, [2] SD enable, [3] IRQ enable |
| CAM_STATUS | 0x1000_0004 | ro | frame count |
| DMA_BASE | 0x1000_0008 | rw | SRAM base (lower 16 bits used) |
| DMA_LEN | 0x1000_000C | rw | length in bytes (lower 16 bits used) |
| DMA_STATUS | 0x1000_0010 | ro | bytes written + done flag |
| IRQ_STATUS | 0x1000_0014 | ro | IRQ pending |
| IRQ_CLEAR | 0x1000_0018 | wo | clear IRQ |
| IOMUX_SEL | 0x1000_001C | rw | mux select |
| SD_STATUS | 0x1000_0020 | ro | SD write count (sim) |
| BUILD_INFO | 0x1000_0024 | ro | build stamp |

**Common Commands (From Repo Root)**
1. Generate CSR RTL and docs: `make regs`
2. Lint RTL with Verilator: `make lint`
3. Run smoke sim (Verilator): `make sim`
4. Build software/firmware: `make sw`
5. Synthesis (Yosys): `make synth`
6. PnR (OpenROAD native): `make pnr`
7. Signoff checks: `make signoff`
8. DFT flow: `make dft`
9. CDC/RDC checks: `make cdc` or `make rdc`
10. LEC flow: `make lec`
11. Build OpenROAD locally: `make openroad`
12. Clean sim and sw outputs: `make clean`

Smoke output artifact after `make sim`:
- `dv/sim/verilator_smoke/out/frame_0000.ppm`

**How To Work With This Repo**
- If you change `ips/csr_regs/dashcam_csr.rdl`, rerun `make regs` to regenerate RTL and docs.
- Start with `make lint` and `make sim` for quick feedback before synthesis or PnR.
- Validate at the smallest scope first, then move to top-level integration.

**EDA Tooling Suggestions (Optional)**
These are not required by the repo, but are common drop-in choices for similar flows.
- Simulation: Verilator, Icarus Verilog, Synopsys VCS, Cadence Xcelium, Siemens Questa.
- Lint/CDC/RDC: Verilator, SpyGlass, Questa CDC, VC CDC, Cadence Conformal CDC.
- Synthesis: Yosys, Synopsys Design Compiler, Cadence Genus.
- PnR: OpenROAD, OpenLane, Synopsys ICC2, Cadence Innovus.
- STA/Signoff: OpenSTA, Synopsys PrimeTime, Cadence Tempus.
- Physical verification: KLayout, Magic, Calibre, Pegasus.
- Waveform/debug: GTKWave, Verdi, SimVision.

**Disclaimer**
This is mock, pre-silicon “toy” data intended for internal experimentation and methodology testing. It is provided as-is, without warranties of any kind.

**Contact**
For access or questions, reach out to `vatsa.prahallada@arm.com`.
