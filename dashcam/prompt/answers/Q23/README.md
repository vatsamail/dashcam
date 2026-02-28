# Q23 – Performance profiling

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Estimate FPS throughput.

## Steps
1. Add cycle counter sampling:
   - use RISC-V `mcycle` and `minstret`
2. Add timestamps around:
   - frame start
   - DMA complete
   - SD write complete
3. Export metrics:
   - print to UART log (sim) or write to a memory buffer dumped at end
4. Provide summary:
   - average cycles/frame
   - estimated FPS at target clock

## Evidence
- A table in `results/perf.md` with sample numbers and assumptions.
