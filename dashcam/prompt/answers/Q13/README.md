# Q13 – Timing closure task

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Increase target clock frequency and improve STA metrics.

## Steps
1. Update `asic/constraints/top.sdc` to new target (e.g., 200MHz -> 240MHz).
2. Identify critical paths:
   - camera -> DMA boundary
   - interconnect arbitration
3. Apply fixes:
   - add pipeline registers
   - retime decode
   - reduce fanout with buffering (document)
4. Re-run STA:
   - Synopsys PrimeTime or Cadence Tempus
5. Provide summary:
   - WNS/TNS before vs after
   - top 5 critical paths

## Open-source alternative
- Run OpenSTA with extracted netlist from OpenROAD flow (if repo supports it).
