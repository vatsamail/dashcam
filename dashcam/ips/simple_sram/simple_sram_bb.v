(* blackbox *)
module simple_sram #(
    parameter ADDR_W = 16,
    parameter DEPTH = 65536,
    parameter INIT_FILE = ""
) (
    input  wire              clk,
    input  wire              rst_n,
    input  wire              dma_wr_en,
    input  wire [ADDR_W-1:0] dma_wr_addr,
    input  wire [7:0]        dma_wr_data,
    input  wire              wb_cyc_i,
    input  wire              wb_stb_i,
    input  wire              wb_we_i,
    input  wire [3:0]        wb_sel_i,
    input  wire [31:0]       wb_adr_i,
    input  wire [31:0]       wb_dat_i,
    output wire [31:0]       wb_dat_o,
    output wire              wb_ack_o
);
endmodule
