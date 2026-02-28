//==============================================================================
// File      : subsys_power_gate.v
// Author    : Example
// SPDX-License-Identifier: Apache-2.0
// Description: Simple clock gating and power domain stubs
//==============================================================================
module subsys_power_gate
(
    input  wire clk_in,
    input  wire reset_in,
    input  wire enable_power,    // from a PMU or subsystem reg
    output wire clk_gated_out,
    output wire reset_gated_out,
    output wire power_domain_on
);

    // In real designs: actual power gating logic or signals to power switch
    assign power_domain_on = enable_power;

    // Simple clock gating: (in production, use library gating cell)
    reg clk_gated_reg;
    always @(*) begin
        // Glitchy if used incorrectly—this is only for illustration
        clk_gated_reg = (enable_power) ? clk_in : 1'b0;
    end
    assign clk_gated_out = clk_gated_reg;

    // Gated reset: if power is off, presumably the block is held in reset
    assign reset_gated_out = reset_in | ~enable_power;

endmodule
