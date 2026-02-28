# Q25 – Docs quality pass

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Improve doc consistency and traceability.

## Checklist
- Fix broken links in `README.md` and docs
- Ensure every requirement ID (REQ-xxx) is referenced from:
  - architecture sections
  - verification plan sections
  - tests (where applicable)
- Normalize terminology per `docs/glossary.md`
- Ensure diagrams render (Mermaid syntax)

## Evidence
- Link check output (script or tool)
- A short “before/after” summary of doc issues fixed
