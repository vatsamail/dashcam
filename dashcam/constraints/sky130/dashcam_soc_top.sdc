# Dashcam SoC SDC (Sky130)
# Target: 200MHz @ 1.8V

create_clock -name core_clk -period 5.000 [get_ports clk]
set_clock_uncertainty 0.2 [get_clocks core_clk]

set_input_delay  0.5 -clock core_clk [all_inputs]
set_output_delay 0.5 -clock core_clk [all_outputs]

set_false_path -from [get_ports rst_n]
