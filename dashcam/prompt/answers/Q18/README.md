# Q18 – Emulation packaging

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Package design for an emulator using templates.

## Steps
1. Pick platform: Veloce or Palladium or ZeBu.
2. Use `emulation/*_templates/`:
   - map top-level ports
   - add clock/reset and transactors (if required)
3. Document run recipe:
   - compile step
   - load firmware
   - run scenario “capture N frames”
4. Provide expected performance metrics:
   - cycles/sec, FPS estimate

## Evidence
- Template diffs + a runnable command sequence for your emulator environment.
