//==============================================================================
// File      : subsys_regfile.v
// Author    : Example
// SPDX-License-Identifier: Apache-2.0
// Description: Generic APB register block
//==============================================================================
module subsys_regfile
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)
(
    input  wire                  PCLK,
    input  wire                  PRESETn,
    input  wire [ADDR_WIDTH-1:0] PADDR,
    input  wire [DATA_WIDTH-1:0] PWDATA,
    output wire [DATA_WIDTH-1:0] PRDATA,
    input  wire                  PWRITE,
    input  wire                  PSEL,
    input  wire                  PENABLE,

    // Example outputs to control subsystem
    output wire        enable_subsys,
    output wire        reset_subsys,
    output wire [3:0]  iomux_sel,      // from an IOMUX register
    // Example read from fuses
    output wire [15:0] fuse_data
);

    //--------------------------------------------------------------------------
    // Simple internal register mapping
    // Address offsets (word offsets for APB):
    // 0x00: CONTROL register  (R/W)
    // 0x04: STATUS register   (R/W)
    // 0x08: IOMUX register    (R/W)
    // 0x0C: FUSE_DATA (R/O)
    //--------------------------------------------------------------------------
    reg [31:0] reg_control;
    reg [31:0] reg_status;
    reg [31:0] reg_iomux;
    reg [15:0] fuse_mem; // pseudo fuse data

    // Initialize fuses to some fixed pattern
    initial fuse_mem = 16'hDEAD;

    wire write_en = PSEL & PENABLE & PWRITE;
    wire read_en  = PSEL & PENABLE & ~PWRITE;

    // Address decode
    wire sel_control = (PADDR[7:0] == 8'h00);
    wire sel_status  = (PADDR[7:0] == 8'h04);
    wire sel_iomux   = (PADDR[7:0] == 8'h08);
    wire sel_fuse    = (PADDR[7:0] == 8'h0C);

    // Write
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg_control <= 32'h0000_0000;
            reg_status  <= 32'h0000_0000;
            reg_iomux   <= 32'h0000_0000;
        end else if (write_en) begin
            if (sel_control) reg_control <= PWDATA;
            if (sel_status)  reg_status  <= PWDATA;
            if (sel_iomux)   reg_iomux   <= PWDATA;
            // Fuse is read-only, no write.
        end
    end

    // Read
    reg [DATA_WIDTH-1:0] read_data_r;
    always @(*) begin
        if (read_en) begin
            if (sel_control) read_data_r = reg_control;
            else if (sel_status)  read_data_r = reg_status;
            else if (sel_iomux)   read_data_r = reg_iomux;
            else if (sel_fuse)    read_data_r = {16'h0000, fuse_mem};
            else                  read_data_r = 32'h0;
        end else begin
            read_data_r = 32'h0;
        end
    end

    assign PRDATA = read_data_r;

    //--------------------------------------------------------------------------
    // Drive subsystem controls from the register contents
    //--------------------------------------------------------------------------
    assign enable_subsys = reg_control[0];  // bit 0
    assign reset_subsys  = reg_control[1];  // bit 1
    assign iomux_sel     = reg_iomux[3:0];
    assign fuse_data     = fuse_mem;

endmodule
