# OpenROAD template
read_lef tech.lef
read_lef stdcell.lef
read_verilog ../../synthesis/open_source/dashcam_soc_top.v
link_design dashcam_soc_top
read_sdc ../../constraints/top.sdc
initialize_floorplan -utilization 60 -aspect_ratio 1.0 -core_space 10
place_pins -hor_layers met2 -ver_layers met3
global_placement
detailed_placement
cts
global_routing
detailed_routing
report_tns
report_wns
