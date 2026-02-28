# Q16 – MBIST enhancement

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Extend MBIST controller to cover 2 memories and report status.

## Steps
1. Identify memory instances in `rtl/mem/` (e.g., `sram0`, `sram1`).
2. Update MBIST controller under `dft/mbist/`:
   - loop over instances
   - add per-instance fail address capture
3. Add CSRs:
   - `MBIST_STATUS`
   - `MBIST_FAIL_ADDR0/1`
4. Add DV test that runs MBIST at reset or via CSR trigger.
5. Add firmware command to start MBIST and print status.

## Evidence
- Simulation log showing MBIST pass
- Negative test if you can inject a memory fault in sim
