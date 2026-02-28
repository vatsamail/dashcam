set design $::env(DESIGN_NAME)
set root_dir $::env(ROOT_DIR)
set pdk_root $::env(PDK_ROOT)
set out_dir $::env(OUT_DIR)
set rpt_dir $::env(RPT_DIR)

file mkdir $out_dir
file mkdir $rpt_dir

set tech_lef "${pdk_root}/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
set std_lef "${pdk_root}/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set std_lib "${pdk_root}/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
set sram_lef "${pdk_root}/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"
set sram_lib "${pdk_root}/sky130A/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib"
set netlist "${root_dir}/build/synth/dashcam_soc_top_synth.v"
set sdc "${root_dir}/constraints/sky130/dashcam_soc_top.sdc"

proc safe_report {cmd outfile} {
  if {[catch {eval $cmd} result]} {
    puts "WARN: $cmd failed: $result"
    return
  }
  set f [open $outfile w]
  puts $f $result
  close $f
}

read_lef $tech_lef
read_lef $std_lef
read_lef $sram_lef
read_liberty $std_lib
read_liberty $sram_lib
read_verilog $netlist
link_design $design
read_sdc $sdc

initialize_floorplan -die_area "0 0 2000 2000" -core_area "100 100 1900 1900" -site unithd
place_pins -random

global_placement
detailed_placement
estimate_parasitics -placement

write_def "${out_dir}/${design}_placed.def"
write_verilog "${out_dir}/${design}_placed.v"

safe_report {report_checks -path_delay min_max} "${rpt_dir}/${design}_timing.rpt"
safe_report {report_wns} "${rpt_dir}/${design}_wns.rpt"
safe_report {report_tns} "${rpt_dir}/${design}_tns.rpt"
safe_report {report_power} "${rpt_dir}/${design}_power.rpt"
