# Q04 – Interrupt plumbing

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add an interrupt for SD write completion and test it.

## Steps
1. **Spec update**
   - Update `docs/architecture/interrupt_map.md` and the interrupt source list under `specs/interrupts/`.

2. **RTL update**
   - Add `sd_write_done` interrupt source into the interrupt controller input vector.
   - Assign it a stable IRQ ID matching docs.

3. **Firmware update**
   - Add ISR handler mapping.
   - Clear/ack the interrupt in the peripheral CSR.
   - Add a status print/log or memory flag.

4. **DV update**
   - Add a directed test (simple SV or UVM sequence) that triggers the SD write path and expects the IRQ.

5. **Run**
   ```bash
   make sim
   ```

## Commercial tools
- Collect coverage (Questa/Xcelium) including toggle coverage for the new IRQ line.
