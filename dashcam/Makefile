SHELL := /bin/bash
PY := python3

.PHONY: regs sw sim lint clean pdk synth pnr signoff dft cdc rdc lec openroad

regs:
	$(PY) scripts/reggen.py --rdl ips/csr_regs/dashcam_csr.rdl --outdir .

sw:
	$(MAKE) -C sw all

lint:
	verilator --lint-only -Wall -Wno-fatal -Wno-WIDTH -Wno-UNUSEDSIGNAL -Wno-UNDRIVEN -sv \
		-Ifips/wb_intercon/rtl -Iips/csr_regs/rtl \
		top/dashcam_top/rtl/dashcam_soc_top.sv \
		ips/camera_capture/camera_capture.v \
		ips/simple_dma/simple_dma.v \
		ips/simple_sram/simple_sram.v \
		ips/irq_ctrl/irq_ctrl.v \
		ips/iomux/iomux.v \
		ips/sdspi_stub/sdspi_stub.v \
		ips/reset_sync/reset_sync.v \
		fips/wb_intercon/rtl/wb_mux.v \
		third_party/picorv32/picorv32.v \
		ips/csr_regs/rtl/dashcam_csr_regs.sv

sim: regs
	$(MAKE) -C dv/sim/verilator_smoke run

pdk:
	./scripts/check_pdk.sh

openroad:
	./scripts/build_openroad_native.sh

synth: regs
	./scripts/run_synth.sh

pnr: pdk synth
	./scripts/run_openroad_native.sh

signoff: pdk
	./scripts/run_signoff.sh

dft:
	./scripts/run_dft.sh

cdc:
	./scripts/run_cdc_rdc.sh

rdc:
	./scripts/run_cdc_rdc.sh

lec:
	./scripts/run_lec.sh

clean:
	$(MAKE) -C dv/sim/verilator_smoke clean
	$(MAKE) -C sw clean
	find . -name "__pycache__" -type d -prune -exec rm -rf {} +
