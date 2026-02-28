# DMA Subsystem

DMA is a linear byte writer from camera stream to SRAM.

- Inputs: start, base, len, pix_valid, pix_data
- Outputs: wr_en, wr_addr, wr_data, done, bytes_written

Trace: REQ-DMA-001, REQ-DMA-002, REQ-DMA-003.
