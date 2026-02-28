# Q10 – Lint cleanup

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Fix top 10 lint warnings.

## Steps
1. Run lint:
   - Commercial: SpyGlass
   - Open-source: Verible (SV lint) + clang-format for C
   ```bash
   make lint
   ```

2. Fix warnings without functional change:
   - unused signals
   - width mismatches
   - inferred latches in combinational blocks
   - non-blocking vs blocking style issues

3. Prove no regressions:
   ```bash
   make sim
   ```

## Evidence
- Lint report before/after with warning count delta.
