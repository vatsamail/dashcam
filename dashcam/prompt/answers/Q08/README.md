# Q08 – Portable Stimulus extension

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Extend PSS scenarios and generate a scenario execution report.

## Steps
1. Locate the PSS model under `dv/plan/` or `dv/pss/` (as generated).
2. Add a scenario:
   - start recording
   - intentionally drop N frames (disable DMA for N)
   - recover and continue
3. Generate / export test intent:
   - Commercial: Questa in PSS mode, or a PSS toolchain available in your environment
   - Open-source: provide a “PSS-to-directed” mapping script if repo includes one
4. Record:
   - list of scenarios executed
   - pass/fail summary

## Deliverable
- Updated PSS file(s)
- `results/pss_report.md` describing what ran and what evidence was collected.
