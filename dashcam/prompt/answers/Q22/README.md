# Q22 – Security hardening (mock secure boot)

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add a simple secure-boot-like check.

## Steps
1. Add firmware image header with:
   - magic
   - version
   - length
   - hash/signature field

2. ROM/bootloader behavior:
   - compute hash (or mock check) and compare
   - refuse boot if mismatch (enter safe loop)

3. Update docs:
   - `docs/architecture/threat_model.md`
   - `docs/requirements/safety_privacy.md`

4. Add a test:
   - valid image boots
   - invalid image halts and sets a status CSR

## Tools
- Open-source: use SHA256 in C (small implementation) or a stub hash.
- Commercial: none required.
