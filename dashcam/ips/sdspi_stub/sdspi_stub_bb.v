(* blackbox *)
module sdspi_stub (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] bytes,
    output wire [15:0] write_count,
    output wire        busy
);
endmodule
