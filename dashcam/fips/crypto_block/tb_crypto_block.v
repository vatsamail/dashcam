//==============================================================================
// File      : tb_crypto_block.v
// Author    : Open-Source Example
// Description: Testbench for crypto_block
//==============================================================================
`timescale 1ns/1ps

module tb_crypto_block;

    reg          clk;
    reg          reset_n;
    reg          start;
    reg  [127:0] key;
    reg  [127:0] data_in;
    wire [127:0] data_out;
    wire         done;

    crypto_block dut (
        .clk      (clk),
        .reset_n  (reset_n),
        .start    (start),
        .key      (key),
        .data_in  (data_in),
        .data_out (data_out),
        .done     (done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset_n = 0;
        key     = 128'hA5A5A5A5_5A5A5A5A_DEADBEEF_12345678;
        data_in = 128'h00112233_44556677_8899AABB_CCDDEEFF;
        start   = 0;
        #20 reset_n = 1;
        #10 start = 1;
        #10 start = 0;

        wait(done);
        $display("Encrypted data_out = 0x%h", data_out);

        #50 $finish;
    end

endmodule
