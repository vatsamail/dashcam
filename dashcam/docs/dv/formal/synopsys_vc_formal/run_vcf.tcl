# Synopsys VC Formal template
read_file -sverilog ../../../rtl/top/dashcam_soc_top.sv
set_top dashcam_soc_top
# add assertions/properties here
prove
report_results
