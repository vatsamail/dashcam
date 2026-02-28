# Assumptions

- A1: REQ-GEN-001. This is a behavioral mock SoC intended for simulation and process collateral, not tapeout-quality silicon.
- A2: REQ-SW-001. RISC-V firmware source is provided and built with `riscv64-unknown-elf-gcc` when available; otherwise a stub `firmware.hex` is generated for simulation bring-up.
- A3: REQ-BUS-001. Internal control bus uses a Wishbone interconnect (vendored `wb_intercon`); the smoke test uses an external Wishbone master for bring-up.
- A6: REQ-RST-001. Reset is asynchronously asserted and synchronously deasserted via `reset_sync`.
- A4: REQ-STOR-001. SD card write path is modeled as SPI-mode stub writing `sdcard.img` during simulation.
- A5: REQ-SEC-001. Secure boot is a mock policy with ROM hash check placeholders; cryptographic root-of-trust IP is out of scope.
- A7: REQ-PNR-001. Native OpenROAD flow requires the OpenROAD binary (and submodules if building from source); if unavailable, PnR is not executed.
