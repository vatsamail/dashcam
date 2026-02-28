# Q21 – Mock Jira grooming

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add backlog items for “Add audio capture pipeline”.

## Steps
1. Update `jira_mock/epics.md` with a new Epic:
   - EPIC-AUDIO-001: Audio pipeline for dashcam

2. Update `jira_mock/tickets.json` with 5 stories:
   - I2S input peripheral
   - DMA support for audio buffers
   - Firmware driver + ring buffer
   - Storage mux for audio/video sync
   - DV tests + coverage

3. Ensure each ticket includes:
   - summary, description, acceptance criteria, dependencies, labels, assignee placeholders

## Evidence
- Diff of `tickets.json` and a short grooming note in your write-up.
