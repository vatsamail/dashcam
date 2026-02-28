# Cadence Innovus template
set init_verilog ../../synthesis/cadence/dashcam_soc_top_netlist.v
set init_lef_file "tech.lef stdcell.lef"
set init_mmmc_file mmmc.tcl
init_design
place_opt_design
clock_opt_design
route_opt_design
report_timing > timing_postroute.rpt
