# Synopsys ICC2/Fusion Compiler template
open_lib worklib
read_verilog ../../synthesis/synopsys/dashcam_soc_top.v
source ../../constraints/top.sdc
create_floorplan -core_utilization 0.6
place_opt
clock_opt
route_auto
report_timing > timing_postroute.rpt
