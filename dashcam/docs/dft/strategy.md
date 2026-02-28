# DFT Strategy

Trace: REQ-DFT-001

- Scan: full-scan for sequential elements except async-only flops.
- MBIST: SRAM march algorithm controller with pass/fail register.
- LBIST: PRPG/MISR placeholder chain for logic test mode.
- Test modes selected via JTAG-accessible test control register.
