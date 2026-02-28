###############################################################################
# Makefile for dashcam_soc_top (wrapper)
###############################################################################

.PHONY: all lint sim clean soc_regs soc_sw soc_smoke

all: lint sim

lint:
	$(MAKE) -C ../.. lint

sim:
	$(MAKE) -C ../.. sim

clean:
	$(MAKE) -C ../.. clean

soc_regs:
	$(MAKE) -C ../.. regs

soc_sw:
	$(MAKE) -C ../.. sw

soc_smoke:
	$(MAKE) -C ../.. sim
