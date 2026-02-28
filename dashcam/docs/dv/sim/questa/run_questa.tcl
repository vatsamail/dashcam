# Questa template
vlib work
vlog -sv ../../../../rtl/top/dashcam_soc_top.sv ../../verilator_smoke/tb_dashcam_smoke.sv
vsim -c tb_dashcam_smoke -do "run -all; quit -f"
