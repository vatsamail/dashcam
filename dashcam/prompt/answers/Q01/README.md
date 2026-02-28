# Q01 – Repo bring-up (baseline)

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## What “done” looks like
- Firmware builds successfully.
- `make sim` runs a smoke test that:
  - boots firmware (or runs a ROM stub),
  - configures camera + DMA,
  - triggers at least one interrupt,
  - produces an output artifact such as:
    - `dv/sim/verilator_smoke/out/frame_0000.ppm` (or `.raw`), OR
    - `dv/sim/verilator_smoke/out/sdcard.img`

## Steps
1. **Build generated registers + headers**
   ```bash
   make regs
   ```

2. **Build firmware**
   ```bash
   make sw
   ```
   Expected output: an ELF under `sw/firmware/build/`.

3. **Run open-source smoke sim**
   ```bash
   make sim
   ```

4. **Collect evidence**
   - Save `dv/sim/verilator_smoke/logs/run.log`
   - Save the output artifact from `dv/sim/verilator_smoke/out/`

## Troubleshooting
- If Verilator errors on unsupported SV features, run the repo’s “verilator-safe” target:
  ```bash
  make sim VERILATOR_SAFE=1
  ```
- If you have Questa/Xcelium:
  ```bash
  make -C dv/sim/questa run
  # or
  make -C dv/sim/xcelium run
  ```
