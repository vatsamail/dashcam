SHELL := /bin/bash
CC_RISCV := $(shell command -v riscv64-unknown-elf-gcc 2>/dev/null)
OBJCOPY := $(shell command -v riscv64-unknown-elf-objcopy 2>/dev/null)
CFLAGS := -Os -ffreestanding -fno-builtin -nostdlib -Iinclude
LDFLAGS := -T linker.ld
OUTDIR := build

.PHONY: all clean

all:
	mkdir -p $(OUTDIR)
	if [ -n "$(CC_RISCV)" ] && [ -n "$(OBJCOPY)" ]; then \
		echo "[sw] building firmware with riscv64-unknown-elf-gcc"; \
		$(CC_RISCV) $(CFLAGS) -o $(OUTDIR)/firmware.elf main.c $(LDFLAGS); \
		$(OBJCOPY) -O verilog --verilog-data-width=8 $(OUTDIR)/firmware.elf $(OUTDIR)/firmware.hex; \
	else \
		echo "[sw] riscv toolchain not found, generating stub firmware.hex"; \
		python3 -c "from pathlib import Path; out=Path('build/firmware.hex'); out.write_text('00\\n'*256); print(f'[sw] wrote {out}')"; \
	fi

clean:
	rm -rf $(OUTDIR)
