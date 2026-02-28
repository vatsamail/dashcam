SHELL := /bin/bash
OUT := out

RTL := \
	../../../rtl/top/dashcam_soc_top.sv \
	../../../rtl/camera/camera_capture.sv \
	../../../rtl/dma/simple_dma.sv \
	../../../rtl/mem/simple_sram.sv \
	../../../rtl/periphs/irq_ctrl.sv \
	../../../rtl/periphs/iomux.sv \
	../../../rtl/periphs/sdspi_stub.sv

TB := tb_dashcam_smoke.sv

.PHONY: run clean

run:
	mkdir -p $(OUT)
	rm -f $(OUT)/sdcard.img $(OUT)/frame0.ppm $(OUT)/smoke.log
	verilator --binary --timing -Wall -Wno-fatal -Wno-WIDTH -Wno-UNUSEDSIGNAL -Wno-UNDRIVEN -sv -I../../../rtl/periphs $(TB) $(RTL)
	./obj_dir/Vtb_dashcam_smoke | tee $(OUT)/smoke.log
	grep -q "SMOKE_PASS" $(OUT)/smoke.log
	@test -f $(OUT)/frame0.ppm
	@test -f $(OUT)/sdcard.img

clean:
	rm -rf obj_dir $(OUT)
