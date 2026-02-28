//==============================================================================
// File      : tb_simple_dma.v
// Author    : Open-Source Example
// Description: Testbench for simple_dma
//==============================================================================
`timescale 1ns/1ps

module tb_simple_dma;

    reg            clk;
    reg            reset_n;
    reg            start;
    reg [31:0]     src_addr;
    reg [31:0]     dst_addr;
    reg [31:0]     xfer_size;
    wire           busy;
    wire           done;

    wire [31:0]    mem_addr;
    wire [31:0]    mem_wdata;
    wire           mem_we;
    reg  [31:0]    mem_rdata;
    wire           mem_req;
    reg            mem_ack;

    // DUT
    simple_dma dut (
        .clk       (clk),
        .reset_n   (reset_n),
        .start     (start),
        .src_addr  (src_addr),
        .dst_addr  (dst_addr),
        .xfer_size (xfer_size),
        .busy      (busy),
        .done      (done),
        .mem_addr  (mem_addr),
        .mem_wdata (mem_wdata),
        .mem_we    (mem_we),
        .mem_rdata (mem_rdata),
        .mem_req   (mem_req),
        .mem_ack   (mem_ack)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset_n = 0;
        start   = 0;
        src_addr = 32'h1000;
        dst_addr = 32'h2000;
        xfer_size= 8; // 8 words

        #25 reset_n = 1;
        #10 start = 1;
        #10 start = 0;
    end

    // Memory ACK + data model
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            mem_ack   <= 0;
            mem_rdata <= 32'hA5A5A5A5;
        end else begin
            mem_ack <= mem_req;
            if (mem_we && mem_req) begin
                // "Write" mem_wdata somewhere
            end else if (!mem_we && mem_req) begin
                // "Read" data
                mem_rdata <= mem_rdata + 1; // increment pattern
            end
        end
    end

    initial begin
        #2000;
        $display("DMA test done");
        $finish;
    end

endmodule
