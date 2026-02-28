# Q20 – Release automation

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Create a deterministic release artifact.

## Steps
1. Add `make release` that:
   - runs `make clean regs sw sim`
   - snapshots generated artifacts:
     - `specs/ipxact/`
     - `specs/csr/`
     - docs tables
   - creates `dist/dashcam-soc-mock-<version>.tar.gz`
   - writes `dist/manifest.json` with file hashes

2. Versioning
- Use a `VERSION` file or `git describe` fallback.
- Ensure manifest captures tool versions if available.

## Evidence
- Provide the tarball and manifest.
