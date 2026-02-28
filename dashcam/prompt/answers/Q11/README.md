# Q11 – Formal check

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add and prove formal properties.

## Recommended properties
- No response without request (interconnect)
- DMA must eventually complete or error (bounded liveness)
- Interrupt acknowledge clears pending bit

## Tools
- Commercial: Synopsys VC Formal or Cadence JasperGold
- Open-source: SymbiYosys for a small module proof

## Steps
1. Add SVA properties under `rtl/interconnect/formal/` (or similar).
2. Add a formal harness module.
3. Run:
   - Commercial: provided templates under `asic/signoff/` or `dv/`
   - Open-source:
     ```bash
     make formal
     ```
4. Provide proof logs and property pass summary.
