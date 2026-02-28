# Cadence JasperGold template
analyze -sv ../../../rtl/top/dashcam_soc_top.sv
elaborate dashcam_soc_top
# define properties and apps
prove -all
report -summary
