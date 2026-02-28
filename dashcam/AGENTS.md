# Repository Guidelines

## Project Structure & Module Organization
This repository is a mock SoC design centered on RTL deliverables.

- `ips/`: reusable IP blocks (each block typically includes `.v`, `_tb.sv`, `.core`, `.xml`, `.yaml`, `.sdc`, `.upf`, `_bom.json`).
- `fips/`: foundation IP used by subsystems and top-level integration.
- `ss/`: subsystem integrations (audio, video, security, connectivity), including top wrappers.
- `top/dashcam_top/`: SoC top-level RTL, testbench, and integration Makefile.
- `block_diagram/`, `documents/`: architecture assets and reference notes.
- `yard/`: scratch/build artifacts and generated outputs; treat as non-source unless explicitly needed.

## Build, Test, and Development Commands
Run commands from repo root unless noted.

- `make -C ips/camera_if lint`: lint a single IP with Verilator.
- `make -C ips/camera_if sim`: compile/run IP simulation with Icarus Verilog (`iverilog` + `vvp`).
- `make -C ss/audio_subsystem all`: lint and simulate subsystem (includes dependent IPs).
- `make -C top/dashcam_top all`: full top-level lint + sim, cascading into subsystems and CPU.
- `make -C <path> clean`: remove `run_files/` and `reports/` artifacts for that block.

## Coding Style & Naming Conventions
- Use Verilog/SystemVerilog with 4-space indentation; keep module/testbench formatting consistent with nearby files.
- Name RTL files `<block>.v`; name testbenches `<block>_tb.sv`.
- Keep generated collateral (`.core`, `.xml`, `.yaml`, `.sdc`, `.upf`, `_bom.json`) aligned to the same `<block>` base name.
- Prefer small, localized edits; avoid broad refactors across multiple IP directories in one change.

## Testing Guidelines
- Primary checks are `lint` and `sim` Make targets per IP/subsystem/top.
- Treat any `error` in `reports/*_lint.log` or `reports/*_sim_run.log` as a failure.
- Add or update `<block>_tb.sv` whenever RTL behavior changes.
- Validate at the smallest scope first (IP), then subsystem, then `top/dashcam_top`.

## Commit & Pull Request Guidelines
- Recent history is informal; standardize on concise imperative commits, e.g. `ips/camera_if: fix frame_valid reset`.
- Keep commits scoped to one logical change (single IP/subsystem whenever possible).
- PRs should include:
  - change summary and touched paths,
  - exact validation commands run,
  - key log snippets (lint/sim pass or failure context),
  - linked issue/task if available.
