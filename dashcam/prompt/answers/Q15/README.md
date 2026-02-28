# Q15 – DFT scan strategy

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add scan/test mode support and scripts.

## Steps
1. Add test mode pins/signals:
   - `scan_en`, `scan_in/out`, `test_mode`, `scan_clk`
2. Wrap key blocks or the whole top with scan-ready wrappers under `rtl/dft/`.
3. Provide insertion templates:
   - `dft/scan/` for Tessent scripts
   - `dft/scan/` for Synopsys DFT Compiler or equivalent templates
4. Document scan chain plan:
   - number of chains
   - length estimate
   - clocking strategy

## Open-source notes
- If using Yosys, document how to preserve scan flops and stitch chains with a simple script (even if limited).
