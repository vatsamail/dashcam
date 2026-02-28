`timescale 1ns/1ps
module reset_sync_tb; reg clk=0; reg rst_n=0; wire rst_sync_n; always #5 clk=~clk; reset_sync u(.clk(clk),.rst_n(rst_n),.rst_sync_n(rst_sync_n)); initial begin #20 rst_n=1; #50 $finish; end endmodule
