`timescale 1ns/1ps
module simple_dma_tb;
    reg clk = 0;
    reg rst_n = 0;
    always #5 clk = ~clk;

    initial begin
        #20 rst_n = 1'b1;
        #100 $finish;
    end
endmodule
