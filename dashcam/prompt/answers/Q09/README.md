# Q09 – Coverage improvement

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Improve toggle + functional coverage for camera + DMA.

## Steps
1. Run baseline coverage:
   - Questa: enable toggle coverage (`+cover=bcesft` etc.)
   - Xcelium: enable coverage (`-coverage all` etc.)
   - Open-source approximation: add event counters + assertions; use Verilator line coverage if supported.

2. Identify low-covered logic:
   - camera frame sync edges, DMA boundary conditions, error states.

3. Add two tests:
   - One directed test for boundary length.
   - One stress test for back-to-back frames with interrupts.

4. Re-run and show delta report.

## Evidence
- Before/after coverage report files
- Short summary table in your write-up
