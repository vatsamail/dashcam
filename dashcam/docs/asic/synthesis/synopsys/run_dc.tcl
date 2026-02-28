# Synopsys Design Compiler template
set_app_var search_path {. ../../../../rtl}
read_file -format sverilog ../../../../rtl/top/dashcam_soc_top.sv
current_design dashcam_soc_top
link
source ../../constraints/top.sdc
compile_ultra
report_timing > timing.rpt
report_area > area.rpt
write -format ddc -output dashcam_soc_top.ddc
