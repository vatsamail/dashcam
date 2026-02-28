# Dashcam SoC Hackathon – Possible Challenges (Mini-Projects)

**Assumes you generated the repo using `generate_repo.sh` emitted by GPT-Codex.**

1. Repo bring-up: run `make regs && make sw && make sim` and produce `frame_0000.ppm`.
2. CSR regen: add `CAM_CTRL.enable_overlay` in SystemRDL and regenerate RTL+headers+docs+IP-XACT.
3. Memory map: add `I2C0` region and update docs + firmware stub.
4. Interrupts: add SD write-done IRQ, update RTL+FW+DV.
5. IOMUX: add new function mapping and validate.
6. DMA errors: add overflow/unaligned detection + tests.
7. Timestamp overlay: implement and show before/after frames.
8. PSS scenario: add “drop frames and recover” and report.
9. Coverage: improve toggle/func coverage with 2 new tests and report delta.
10. Lint: fix top 10 warnings and show delta.
