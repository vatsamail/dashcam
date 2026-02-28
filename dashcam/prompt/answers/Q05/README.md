# Q05 – IOMUX new function

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add a new IOMUX function and prove it configures correctly.

## Steps
1. Update `docs/architecture/iomux_plan.md` with the new function and pin.
2. Update IOMUX register definitions (SystemRDL) and regenerate:
   ```bash
   make regs
   ```
3. Update RTL IOMUX muxing logic under `rtl/periphs/iomux/`.
4. Update firmware init to select the new function.
5. Add a sim check: observe the pin toggles (wave or trace) in response to internal signal.

## Open-source evidence
- Use VCD/FST trace from Verilator smoke run and show the mapped pin toggling.
