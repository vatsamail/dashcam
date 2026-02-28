# Verification Plan

Objectives:
- REQ-DV-001-OBJ1: validate camera ingest, DMA transfer, IRQ handling, SD invocation.
- REQ-DV-001-OBJ2: provide open-source smoke and commercial UVM path.

Test list:
- `tb_dashcam_smoke`: end-to-end capture to storage artifact.
- `uvm_smoke_test` (template): register programming and scoreboard checks.
