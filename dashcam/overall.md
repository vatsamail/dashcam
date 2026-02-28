# Dashcam SoC — Go-To Diagram

Dashcam SoC is a compact, Wishbone-based mock SoC used for flow development and pre-silicon methodology validation. This page is the single source of truth for the top-level architecture view.

## System Diagram
```
+------------------------------ Dashcam SoC ------------------------------+
| clk, rst_n                                                               |
|   |                                                                      |
|   v                                                                      |
| reset_sync -> rst_sync_n                                                  |
|                                                                          |
|  +-------------------+      +---------------------------+                |
|  | WB Master         |<---->| wb_mux (wb_intercon)       |                |
|  | - picorv32_wb      |      | addr decode               |                |
|  | - external WB      |      | 0x1000_0000 CSR            |                |
|  +-------------------+      | 0x2000_0000 SRAM           |                |
|                             +-------------+-------------+                |
|                                           |                              |
|         +--------------------+            |                              |
|         | dashcam_csr_regs    |<-----------+                              |
|         | (SystemRDL gen)     |                                           |
|         +---------+----------+                                           |
|                   |                                                      |
| cam_valid/sof/pix |                                                      |
|                   v                                                      |
|         +--------------------+       +------------------+      +---------+|
|         | camera_capture     |------>| simple_dma       |----->| simple  ||
|         +--------------------+       +--------+---------+      | sram    ||
|                                                |               +----+----+|
|                                                |                    |     |
|                                                +-> irq_ctrl -----> irq    |
|                                                +-> sdspi_stub (sim)       |
|                                                +-> iomux (demo)           |
+---------------------------------------------------------------------------+
```

## Address Map
- CSR window: `0x1000_0000` (generated from `ips/csr_regs/dashcam_csr.rdl`)
- SRAM window: `0x2000_0000` (`simple_sram`, DMA writes and Wishbone accesses)

## Key Files
- Top RTL: `top/dashcam_top/rtl/dashcam_soc_top.sv`
- CSR RDL: `ips/csr_regs/dashcam_csr.rdl`
- SDC: `constraints/sky130/dashcam_soc_top.sdc`
- UPF: `power/sky130/dashcam_soc_top.upf`
- OpenROAD flow: `flows/openroad/dashcam_soc_top/flow.tcl`

## Notes
- DMA uses 16-bit base/length fields and writes byte-by-byte to SRAM.
- `USE_CPU` parameter selects internal `picorv32_wb` or external Wishbone master.
- SD storage is a simulation stub only (`sdspi_stub`).
