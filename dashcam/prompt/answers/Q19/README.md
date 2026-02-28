# Q19 – Board constraints generation

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Generate IO constraints from board + iomux plan.

## Steps
1. Use the connector map (`board/connector_map.md`) and IOMUX plan (`docs/architecture/iomux_plan.md`).
2. Generate constraints file:
   - FPGA: XDC (Vivado) or SDC-like
   - ASIC: IO placement constraints (template)
3. Validate:
   - every top IO is assigned
   - no duplicate pins
   - matches docs

## Open-source
- Provide a Python script in `sw/tools/` or `automation_ops/` to generate constraints from a YAML/CSV input.
