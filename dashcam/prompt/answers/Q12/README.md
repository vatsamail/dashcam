# Q12 – UPF power intent

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Create a new power domain for camera subsystem.

## Steps
1. Update `asic/constraints/top.upf`:
   - Define `PD_CAMERA`
   - Add isolation strategy for camera outputs
   - Define retention if needed (optional)

2. Update docs:
   - `docs/architecture/threat_model.md` (power state impact)
   - Add a power intent review checklist note in `docs/architecture/soc_overview.md`

3. Validate with:
   - Commercial: UPF checks in implementation tool
   - Open-source: static checks for syntax + consistency (repo scripts)

## Evidence
- Diff of UPF
- A short review checklist showing isolation points and control signals
