# Synopsys TestMAX ATPG template
read_netlist ../../rtl/top/dashcam_soc_top_scan.v
read_library stdcell.lib
set_faults -model stuck
run_atpg
report_coverage
