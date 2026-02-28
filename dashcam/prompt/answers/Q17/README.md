# Q17 – Debug bring-up with OpenOCD/GDB

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Attach debugger to simulated CPU and inspect state.

## Steps (typical)
1. Launch sim with debug server enabled (repo should include a switch):
   ```bash
   make sim DEBUG=1
   ```
2. In another terminal, run OpenOCD (or documented stub):
   ```bash
   openocd -f debug/openocd_cfg/dashcam_soc.cfg
   ```
3. Run GDB:
   ```bash
   riscv64-unknown-elf-gdb sw/firmware/build/dashcam.elf
   (gdb) target remote :3333
   (gdb) b main
   (gdb) c
   (gdb) p/x frame_buffer_addr
   ```

## Evidence
- Screenshot or log of breakpoint hit and inspected variable.
