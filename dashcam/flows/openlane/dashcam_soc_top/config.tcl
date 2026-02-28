# OpenLane config for dashcam_soc_top (Sky130)
set ::env(DESIGN_NAME) dashcam_soc_top
set ::env(VERILOG_FILES) [list \
    $::env(DESIGN_DIR)/../../top/dashcam_top/rtl/dashcam_soc_top.sv \
    $::env(DESIGN_DIR)/../../ips/camera_capture/camera_capture.v \
    $::env(DESIGN_DIR)/../../ips/simple_dma/simple_dma.v \
    $::env(DESIGN_DIR)/../../ips/simple_sram/simple_sram.v \
    $::env(DESIGN_DIR)/../../ips/irq_ctrl/irq_ctrl.v \
    $::env(DESIGN_DIR)/../../ips/iomux/iomux.v \
    $::env(DESIGN_DIR)/../../ips/sdspi_stub/sdspi_stub_bb.v \
    $::env(DESIGN_DIR)/../../ips/reset_sync/reset_sync.v \
    $::env(DESIGN_DIR)/../../fips/wb_intercon/rtl/wb_mux.v \
    $::env(DESIGN_DIR)/../../third_party/picorv32/picorv32.v \
    $::env(DESIGN_DIR)/../../ips/csr_regs/rtl/dashcam_csr_regs.sv \
]

set ::env(VERILOG_DEFINES) "USE_SRAM_MACRO"

set ::env(EXTRA_VERILOG_MODELS) [list \
    $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_1kbyte_1rw1r_32x256_8.v \
]
set ::env(EXTRA_LEFS) [list \
    $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef \
]
set ::env(EXTRA_GDS_FILES) [list \
    $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds \
]
set ::env(EXTRA_LIBS) [list \
    $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib \
]

set ::env(CLOCK_PORT) clk
set ::env(CLOCK_PERIOD) 5.000

set ::env(SYNTH_STRATEGY) "DELAY 3"
set ::env(FP_CORE_UTIL) 40
set ::env(PL_TARGET_DENSITY) 0.45
set ::env(DIE_AREA) "0 0 1500 1500"
set ::env(CORE_AREA) "100 100 1400 1400"

set ::env(SDC_FILE) $::env(DESIGN_DIR)/../../constraints/sky130/dashcam_soc_top.sdc
set ::env(POWER_PIN) VDD
set ::env(GROUND_PIN) VSS
