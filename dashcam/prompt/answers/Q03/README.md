# Q03 – Memory map extension

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add a new peripheral address region (e.g., `I2C0`).

## Steps
1. Update address map source-of-truth:
   - Either SystemRDL address blocks or `specs/address_map/` generator inputs.

2. Regenerate maps + headers:
   ```bash
   make regs
   ```

3. Add RTL stub for `i2c0` under `rtl/periphs/i2c/` (or similar) and connect it in top-level interconnect decode.

4. Update firmware:
   - Add base address define from generated headers.
   - Add a driver stub under `sw/firmware/drivers/i2c0.c`.

5. Validate:
   ```bash
   make sw
   make sim
   ```

## Open-source tools
- Use `verilator --trace` to confirm reads/writes hit the new decode region.
