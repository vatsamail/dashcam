# Q07 – Camera pipeline timestamp overlay

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Overlay a timestamp/metadata on frames.

## Two valid approaches
### A) Hardware overlay (preferred)
- Add an overlay module in `rtl/camera/` that:
  - reads a timestamp CSR,
  - blends characters/pixels into the first N lines.

### B) Firmware overlay
- Write pixels into frame buffer after DMA completes and before SD write.

## Evidence
- Provide two output frames:
  - baseline frame (no overlay)
  - overlay-enabled frame
- Show the overlay region differs as expected.

## Tools
- Open-source: `python sw/tools/ppm_dump.py` (or similar) to inspect output.
- Commercial: Questa waveform view.
