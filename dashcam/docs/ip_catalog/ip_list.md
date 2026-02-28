# IP Catalog

| IP | Type | Source | License | Notes |
| camera_capture | custom RTL | local | MIT | Camera ingest (external pixel stream) |
| simple_dma | custom RTL | local | MIT | linear byte DMA |
| simple_sram | custom RTL | local | MIT | behavioral SRAM |
| irq_ctrl | custom RTL | local | MIT | single IRQ source |
| iomux | custom RTL | local | MIT | pin function selector |
| sdspi_stub | custom RTL | local | MIT | simulation storage model |
| reset_sync | custom RTL | local | MIT | async reset sync (deassert) |
| dashcam_csr_regs | generated RTL | SystemRDL | MIT | CSR register file generated from `ips/csr_regs/dashcam_csr.rdl` |
| picorv32 | open-source | https://github.com/YosysHQ/picorv32 | ISC | RISC-V core (Wishbone wrapper) |
| wb_intercon | open-source | https://github.com/olofk/wb_intercon | ISC | Wishbone mux/interconnect |
