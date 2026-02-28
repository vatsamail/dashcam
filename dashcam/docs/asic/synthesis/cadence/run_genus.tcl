# Cadence Genus template
read_hdl ../../../../rtl/top/dashcam_soc_top.sv
elaborate dashcam_soc_top
read_sdc ../../constraints/top.sdc
synthesize -to_mapped
report timing > timing.rpt
report area > area.rpt
write_hdl > dashcam_soc_top_netlist.v
