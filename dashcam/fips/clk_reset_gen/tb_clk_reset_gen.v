//==============================================================================
// File      : tb_clk_reset_gen.v
// Author    : Open-Source Example
// Description: Testbench for clk_reset_gen
//==============================================================================
`timescale 1ns/1ps

module tb_clk_reset_gen;

    // Testbench signals
    reg  clk_in_tb;
    reg  reset_in_tb;
    wire clk_out_tb;
    wire locked_tb;
    wire reset_out_tb;

    // DUT instantiation
    clk_reset_gen #(
        .CLK_MUL(2),
        .CLK_DIV(1)
    ) dut (
        .clk_in    (clk_in_tb),
        .reset_in  (reset_in_tb),
        .clk_out   (clk_out_tb),
        .locked    (locked_tb),
        .reset_out (reset_out_tb)
    );

    // Generate input clock
    initial begin
        clk_in_tb = 0;
        forever #5 clk_in_tb = ~clk_in_tb; // 100 MHz simulation
    end

    // Test sequence
    initial begin
        // Initialize
        reset_in_tb = 1;
        #30;
        reset_in_tb = 0;
        // Let the design run
        #200;
        $display("Test completed. Check waveforms for correct behavior.");
        $finish;
    end

endmodule
