# Q24 – Post-silicon plan update

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Extend post-silicon validation plan for SD card + sensor variants.

## Steps
1. Update `post_silicon/validation_plan.md`:
   - add SD card compatibility matrix
   - add sensor variants list and bring-up steps
2. Add test procedures:
   - power-up sequence
   - hot-plug / brownout
   - long-duration record
3. Add data capture requirements:
   - logs, traces, failure signatures

## Evidence
- Updated plan with test IDs and pass/fail criteria.
