# Coverage Plan

Functional:
- camera frame start observed (REQ-CAM-002)
- DMA length boundary (REQ-DMA-002)
- IRQ set/clear sequence (REQ-INT-001/002)
- SD write trigger path (REQ-SD-001)

Toggle coverage:
- Questa: `vlog -coveropt 3; vsim -coverage; coverage save`
- Xcelium: `xrun -coverage all`
- Verilator approximation: line/toggle via `--coverage` and postprocess counters.
