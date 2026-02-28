SHELL := /bin/bash
CC_RISCV := $(shell command -v riscv64-unknown-elf-gcc 2>/dev/null)
CC_HOST := $(shell command -v cc 2>/dev/null)
CFLAGS_COMMON := -Os -ffreestanding -Wall -Wextra -I../../../specs/csr

OUTDIR := build
SRC := main.c

.PHONY: all clean

all:
	mkdir -p $(OUTDIR)
	if [ -n "$(CC_RISCV)" ]; then \
		echo "[sw] building with riscv64-unknown-elf-gcc"; \
		$(CC_RISCV) $(CFLAGS_COMMON) -nostdlib -T linker.ld -o $(OUTDIR)/dashcam_fw.elf $(SRC); \
	else \
		echo "[sw] riscv64-unknown-elf-gcc not found, building host fallback"; \
		$(CC_HOST) -std=c11 -DHOST_BUILD $(CFLAGS_COMMON) -o $(OUTDIR)/dashcam_fw_host $(SRC); \
	fi

clean:
	rm -rf $(OUTDIR)
