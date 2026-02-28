//==============================================================================
// File      : tb_jtag_debug.v
// Author    : Open-Source Example
// Description: Testbench for jtag_debug
//==============================================================================
`timescale 1ns/1ps

module tb_jtag_debug;

    reg tck;
    reg tms;
    reg tdi;
    wire tdo;
    wire halt_cpu;
    wire [7:0] debug_reg;

    jtag_debug dut (
        .tck      (tck),
        .tms      (tms),
        .tdi      (tdi),
        .tdo      (tdo),
        .halt_cpu (halt_cpu),
        .debug_reg(debug_reg)
    );

    // TCK
    initial begin
        tck = 0;
        forever #5 tck = ~tck;
    end

    initial begin
        tms = 0; tdi = 0;
        #20;
        // Shift in some bits
        repeat(8) begin
            tdi = 1; // shift in '1'
            @(posedge tck);
        end
        // Now shift in zero for variety
        tdi = 0; 
        repeat(8) @(posedge tck);

        // Check final debug_reg
        $display("Debug Register = 0x%h, halt_cpu=%b", debug_reg, halt_cpu);
        #50;
        $finish;
    end

endmodule
