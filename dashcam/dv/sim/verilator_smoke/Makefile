SHELL := /bin/bash
ROOT := ../../..
OUT := out

RTL := \
	$(ROOT)/top/dashcam_top/rtl/dashcam_soc_top.sv \
	$(ROOT)/ips/camera_capture/camera_capture.v \
	$(ROOT)/ips/simple_dma/simple_dma.v \
	$(ROOT)/ips/simple_sram/simple_sram.v \
	$(ROOT)/ips/irq_ctrl/irq_ctrl.v \
	$(ROOT)/ips/iomux/iomux.v \
	$(ROOT)/ips/sdspi_stub/sdspi_stub.v \
	$(ROOT)/ips/reset_sync/reset_sync.v \
	$(ROOT)/fips/wb_intercon/rtl/wb_mux.v \
	$(ROOT)/third_party/picorv32/picorv32.v \
	$(ROOT)/ips/csr_regs/rtl/dashcam_csr_regs.sv

TB := tb_dashcam_smoke.sv

.PHONY: run clean

run:
	mkdir -p $(OUT)
	rm -f $(OUT)/sdcard.img $(OUT)/frame_0000.ppm $(OUT)/smoke.log
	verilator --binary --timing -Wall -Wno-fatal -Wno-WIDTH -Wno-UNUSEDSIGNAL -Wno-UNDRIVEN -sv \
		-I$(ROOT)/fips/wb_intercon/rtl -I$(ROOT)/ips/csr_regs/rtl $(TB) $(RTL)
	./obj_dir/Vtb_dashcam_smoke | tee $(OUT)/smoke.log
	grep -q "SMOKE_PASS" $(OUT)/smoke.log
	@test -f $(OUT)/frame_0000.ppm

clean:
	rm -rf obj_dir $(OUT)
