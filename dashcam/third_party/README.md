# Third-party Content

This repository vendors open-source IP snapshots used by the mock SoC. Each package
includes its upstream source, commit/tag, and license information.

| Package | Source | License | Notes |
|---|---|---|---|
| picoRV32 | https://github.com/YosysHQ/picorv32 | ISC | RISC-V core (Wishbone wrapper in `picorv32.v`) |
| wb_intercon | https://github.com/olofk/wb_intercon | ISC | Wishbone mux/interconnect |
| systemrdl-compiler | https://github.com/SystemRDL/systemrdl-compiler | BSD-3-Clause | Reference parser (optional; generator uses internal parser) |
