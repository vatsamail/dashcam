# Software Stack

Firmware configures camera capture, DMA, interrupt, and SD write path.

## Build

```bash
make -C docs/sw/firmware/apps all
```

Uses `riscv64-unknown-elf-gcc` if available; otherwise uses host `cc` for compile-only smoke.
