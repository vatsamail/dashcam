# SoC Overview

This SoC mock uses a Wishbone-like internal bus and includes camera ingest, DMA, SRAM buffer, IRQ controller, IOMUX, and SD SPI stub.

Traceability:
- REQ-CAM-001/002: camera pipeline and frame counter
- REQ-DMA-001/002/003: DMA engine and status
- REQ-INT-001/002: IRQ controller
- REQ-SD-001: SD write stub path
- REQ-SEC-001: secure boot mock flow and memory region policy
