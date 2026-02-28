//==============================================================================
// File      : jtag_debug.v
// Author    : Open-Source Example
// Version   : 1.0
// SPDX-License-Identifier: Apache-2.0
// Description: Mock JTAG debug module
//==============================================================================
module jtag_debug
(
    // JTAG interface
    input  wire tck,
    input  wire tms,
    input  wire tdi,
    output wire tdo,

    // SoC signals
    output wire halt_cpu,
    output wire [7:0] debug_reg
);

    // Simple shift register approach
    reg [7:0] shift_reg;
    reg [3:0] tap_state;

    assign tdo = shift_reg[0];
    assign debug_reg = shift_reg;
    assign halt_cpu = (shift_reg == 8'hFF); // If we shift in FF, halt CPU

    // State machine placeholders
    always @(posedge tck) begin
        // example TAP (Test Access Port) logic
        if (tms) begin
            tap_state <= tap_state + 1;
        end

        shift_reg <= {tdi, shift_reg[7:1]};
    end

endmodule
