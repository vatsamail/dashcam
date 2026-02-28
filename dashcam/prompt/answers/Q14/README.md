# Q14 – OpenROAD flow

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Run OpenROAD flow to completion.

## Steps
1. Generate synthesis netlist (open-source flow):
   ```bash
   make -C asic/synthesis/open_source synth
   ```
2. Run OpenROAD PnR:
   ```bash
   make -C asic/pn_r/openroad run
   ```
3. Collect results:
   - area report
   - timing summary
   - DRC summary (if available)

## Evidence
- Logs + final report paths
- Runtime on your machine
