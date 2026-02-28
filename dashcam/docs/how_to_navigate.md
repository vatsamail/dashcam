# How To Navigate This Repo

- `ips/csr_regs/dashcam_csr.rdl`: source-of-truth CSR register definitions (SystemRDL).
- `scripts/reggen.py`: generator from SystemRDL to headers/IP-XACT/maps/RTL.
- `ips/`, `fips/`, `top/dashcam_top/`: synthesizable mock RTL and integration top.
- `dv/sim/verilator_smoke/`: open-source smoke sim and artifact generation.
- `sw/`: firmware record-loop app and stub firmware.hex generation.
- `docs/asic/`, `docs/dft/`, `docs/post_silicon/`: implementation and lifecycle templates.
- `legacy/`: archived subsystem-based design files (not used in Wishbone SoC flow).
