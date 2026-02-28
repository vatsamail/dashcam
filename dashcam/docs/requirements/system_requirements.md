# System Requirements

- REQ-CAM-001: SoC shall ingest DVP-style pixel stream (valid, sof, pixel[7:0]).
- REQ-CAM-002: SoC shall count captured frames.
- REQ-DMA-001: DMA shall transfer camera bytes to SRAM at programmable base.
- REQ-DMA-002: DMA shall support programmable transfer length.
- REQ-DMA-003: DMA shall expose done and bytes_written status.
- REQ-INT-001: Interrupt shall assert on DMA completion.
- REQ-INT-002: Interrupt shall be clearable by firmware.
- REQ-IOMUX-001: IOMUX CSR shall provide programmable function select.
- REQ-SD-001: Storage path shall be invokable to persist stream data to SD/host file.
- REQ-SW-001: Firmware shall boot and configure camera+DMA+interrupt loop.
- REQ-SEC-001: Security model shall include privilege split and secure-boot mock.
- REQ-DFT-001: DFT collateral shall define scan/MBIST/LBIST strategy and modes.
- REQ-DV-001: DV plan shall include UVM and open-source smoke coverage guidance.
- REQ-OPS-001: CI shall run regs generation, firmware build, and smoke sim.
