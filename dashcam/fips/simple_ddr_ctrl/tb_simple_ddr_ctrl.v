//==============================================================================
// File      : tb_simple_ddr_ctrl.v
// Author    : Open-Source Example
// Description: Testbench for simple_ddr_ctrl
//==============================================================================
`timescale 1ns/1ps

module tb_simple_ddr_ctrl;

    localparam ADDR_WIDTH = 28;
    localparam DATA_WIDTH = 128;

    reg                       clk;
    reg                       reset_n;
    reg  [ADDR_WIDTH-1:0]     mem_addr;
    reg  [DATA_WIDTH-1:0]     mem_wdata;
    reg                       mem_we;
    wire [DATA_WIDTH-1:0]     mem_rdata;
    reg                       mem_req;
    wire                      mem_ack;

    wire [ADDR_WIDTH-1:0]     ddr_addr;
    wire [DATA_WIDTH-1:0]     ddr_data;
    wire                      ddr_we_n;

    // DUT
    simple_ddr_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk       (clk),
        .reset_n   (reset_n),
        .mem_addr  (mem_addr),
        .mem_wdata (mem_wdata),
        .mem_we    (mem_we),
        .mem_rdata (mem_rdata),
        .mem_req   (mem_req),
        .mem_ack   (mem_ack),
        .ddr_addr  (ddr_addr),
        .ddr_data  (ddr_data),
        .ddr_we_n  (ddr_we_n)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset
    initial begin
        reset_n = 0;
        #20 reset_n = 1;
    end

    // Test
    initial begin
        // Wait for reset to deassert
        @(posedge reset_n);
        @(posedge clk);

        // Write transaction
        mem_addr  = 28'h000000A;
        mem_wdata = 128'hDEADBEEF_01234567_89ABCDEF_13572468;
        mem_we    = 1'b1;
        mem_req   = 1'b1;

        @(posedge clk);
        mem_req = 1'b0;

        // Wait a few cycles
        repeat(5) @(posedge clk);

        // Read transaction
        mem_addr  = 28'h000000A;
        mem_we    = 1'b0;
        mem_req   = 1'b1;

        @(posedge clk);
        mem_req = 1'b0;

        // Wait
        repeat(5) @(posedge clk);
        $display("Read Data = 0x%h", mem_rdata);

        #50 $finish;
    end

endmodule
