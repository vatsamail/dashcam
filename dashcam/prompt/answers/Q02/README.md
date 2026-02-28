# Q02 – CSR regeneration

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Change a CSR definition in SystemRDL and regenerate:
- RTL register block(s)
- C headers
- Docs tables
- IP-XACT

## Steps
1. Edit the SystemRDL file under `specs/sysrdl/`:
   - Example: add field `enable_overlay` into `CAM_CTRL`.

2. Regenerate artifacts:
   ```bash
   make regs
   ```
   This should run the repo’s generator scripts (see `sw/tools/` or `automation_ops/build_system.md`).

3. Validate consistency:
   - Compare generated header vs RTL addresses/bitfields.
   - Ensure docs tables in `docs/architecture/` or `docs/microarchitecture/` reflect the new field.
   - Confirm IP-XACT updated under `specs/ipxact/`.

4. Prove correctness:
   - Run smoke sim:
     ```bash
     make sim
     ```
   - Add a simple firmware write/read of the new bit and confirm behavior (or confirm it’s a no-op but readable).

## Commercial tool option
- Run register lint/checker via IP-XACT import in your favorite EDA platform (where available).
