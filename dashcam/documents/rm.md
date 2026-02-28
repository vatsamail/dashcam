# Dashcam SoC Reference Manual (RM)

## 1. Features
- Wishbone interconnect with CSR + SRAM slave decode.
- Optional picoRV32 CPU (disabled by default in sim).
- Camera capture pipeline with DMA to SRAM.
- SD-SPI stub (simulation logging).
- Single interrupt: DMA completion.
- CSR collateral generated from SystemRDL into RTL, C headers, docs, IP-XACT.

## 2. System Block Diagram
```
                       +-------------------------+
Camera -> Capture ---> | DMA -> SRAM (WB slave) |---->
                       +------------+------------+
                                    |
                                    v
                       +------------+------------+
                       |   Wishbone Mux         |
                       +------------+------------+
                                    |
                           +--------+--------+
                           | CSR / IRQ / IOMUX|
                           +------------------+
```

## 3. Memory Map
Base address: `0x1000_0000`

| Name | Address | Access | Description |
|---|---:|---|---|
| CTRL | 0x1000_0000 | rw | camera enable + DMA start |
| CAM_STATUS | 0x1000_0004 | ro | frame count |
| DMA_BASE | 0x1000_0008 | rw | DMA base addr |
| DMA_LEN | 0x1000_000C | rw | DMA length |
| DMA_STATUS | 0x1000_0010 | ro | bytes written + done |
| IRQ_STATUS | 0x1000_0014 | ro | irq pending |
| IRQ_CLEAR | 0x1000_0018 | wo | clear irq |
| IOMUX_SEL | 0x1000_001C | rw | I/O select |
| SD_STATUS | 0x1000_0020 | ro | SD write count |
| BUILD_INFO | 0x1000_0024 | ro | build stamp |

## 4. Registers (Behavior)
- `CTRL.cam_en` enables capture.
- `CTRL.dma_start` triggers DMA (self-clearing pulse on write).
- `DMA_STATUS` indicates bytes written and done flag.
- `IRQ_CLEAR` clears pending IRQ.

## 5. Interrupts
| IRQ | Source |
|---:|---|
| 0 | DMA done |

## 6. Reset and Clocking
- `clk`: single system clock (200MHz target).
- `rst_n`: async assert, sync deassert via `reset_sync`.

## 7. Programming Flow
```
Reset -> configure DMA_BASE/DMA_LEN -> CTRL.cam_en=1
  -> write CTRL.dma_start -> poll DMA_STATUS or IRQ
  -> read SRAM for frame bytes
```

## 8. Simulation
- Smoke sim: `make sim` produces `dv/sim/verilator_smoke/out/frame_0000.ppm`.

## 9. Known Limitations (Mock)
- No real SD controller; SPI stub only.
- No multi-clock or advanced power management.
