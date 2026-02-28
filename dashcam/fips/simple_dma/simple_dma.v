//==============================================================================
// File      : simple_dma.v
// Author    : Open-Source Example
// Version   : 1.0
// SPDX-License-Identifier: Apache-2.0
// Description: Simple DMA engine mock-up
//==============================================================================
module simple_dma
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)
(
    input  wire                clk,
    input  wire                reset_n,

    // Control registers interface
    input  wire                start,
    input  wire [ADDR_WIDTH-1:0] src_addr,
    input  wire [ADDR_WIDTH-1:0] dst_addr,
    input  wire [31:0]         xfer_size, // in words
    output wire                busy,
    output wire                done,

    // Memory interface (shared or separate AXI/whatever bus)
    // For simplicity, direct signals:
    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_wdata,
    output wire                  mem_we,
    input  wire [DATA_WIDTH-1:0] mem_rdata,
    output wire                  mem_req,
    input  wire                  mem_ack
);

    //--------------------------------------------------------------------------
    // State machine
    //--------------------------------------------------------------------------
    typedef enum logic [1:0] {
        IDLE,
        READ,
        WRITE,
        COMPLETE
    } dma_state_e;

    reg [1:0] state, next_state;

    reg [ADDR_WIDTH-1:0] r_src, r_dst;
    reg [31:0]           r_count;
    reg                  r_done;

    assign busy = (state != IDLE && state != COMPLETE);
    assign done = (state == COMPLETE);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state   <= IDLE;
            r_src   <= {ADDR_WIDTH{1'b0}};
            r_dst   <= {ADDR_WIDTH{1'b0}};
            r_count <= 32'h0;
            r_done  <= 1'b0;
        end else begin
            state <= next_state;
            if (start && (state == IDLE)) begin
                r_src   <= src_addr;
                r_dst   <= dst_addr;
                r_count <= xfer_size;
            end
            if (state == COMPLETE)
                r_done <= 1'b1;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    if (start) next_state = READ;
            READ:    if (mem_ack) next_state = WRITE;
            WRITE:   if (mem_ack) begin
                         if (r_count == 1) next_state = COMPLETE;
                         else next_state = READ;
                     end
            COMPLETE: next_state = IDLE; // could wait for SW clear
        endcase
    end

    //--------------------------------------------------------------------------
    // Memory signals
    //--------------------------------------------------------------------------
    assign mem_req   = (state == READ || state == WRITE);
    assign mem_we    = (state == WRITE);
    assign mem_addr  = (state == READ) ? r_src : r_dst;
    assign mem_wdata = mem_rdata;

    // Decrement count after each read->write cycle
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            r_count <= 32'h0;
        end else if ((state == WRITE) && mem_ack) begin
            r_count <= r_count - 1;
            r_src   <= r_src + (DATA_WIDTH/8); // increment by word-size
            r_dst   <= r_dst + (DATA_WIDTH/8);
        end
    end

endmodule
