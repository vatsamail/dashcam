# Siemens Tessent ATPG template
read_design ../../rtl/top/dashcam_soc_top_scan.v
set_fault_model stuck_at
create_patterns
report_statistics
