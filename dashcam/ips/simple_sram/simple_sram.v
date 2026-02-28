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
    output reg  [31:0]       wb_dat_o,
    output reg               wb_ack_o
);
`ifdef USE_SRAM_MACRO
    // Map to Sky130 1kB SRAM macro (32x256, 1RW1R)
    // Note: This mapping prioritizes DMA writes. Wishbone writes are supported
    // when DMA is idle. Wishbone reads use the read-only port.
    wire wb_hit = wb_cyc_i && wb_stb_i;
    wire use_dma = dma_wr_en;

    wire [7:0] addr0 = use_dma ? dma_wr_addr[9:2] : wb_adr_i[9:2];
    wire [31:0] din0 = use_dma ? {4{dma_wr_data}} : wb_dat_i;
    wire [3:0] wmask0 = use_dma ? (4'b0001 << dma_wr_addr[1:0]) : wb_sel_i;

    wire csb0 = ~(use_dma || wb_hit);
    wire web0 = use_dma ? 1'b0 : ~wb_we_i;

    wire csb1 = ~wb_hit;
    wire [7:0] addr1 = wb_adr_i[9:2];

    wire [31:0] dout0;
    wire [31:0] dout1;

    sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
        .clk0(clk),
        .csb0(csb0),
        .web0(web0),
        .wmask0(wmask0),
        .addr0(addr0),
        .din0(din0),
        .dout0(dout0),
        .clk1(clk),
        .csb1(csb1),
        .addr1(addr1),
        .dout1(dout1)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h0;
        end else begin
            wb_ack_o <= wb_hit;
            wb_dat_o <= dout1;
        end
    end
`else
    reg [7:0] mem [0:DEPTH-1];
    wire wb_hit = wb_cyc_i && wb_stb_i;
    wire [ADDR_W-1:0] wb_byte_addr = wb_adr_i[ADDR_W-1:0];

    integer i;
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end else begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] = 8'h00;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h0;
        end else begin
            if (dma_wr_en) begin
                mem[dma_wr_addr] <= dma_wr_data;
            end

            wb_ack_o <= wb_hit;
            if (wb_hit) begin
                if (wb_we_i) begin
                    if (wb_sel_i[0]) mem[wb_byte_addr + 0] <= wb_dat_i[7:0];
                    if (wb_sel_i[1]) mem[wb_byte_addr + 1] <= wb_dat_i[15:8];
                    if (wb_sel_i[2]) mem[wb_byte_addr + 2] <= wb_dat_i[23:16];
                    if (wb_sel_i[3]) mem[wb_byte_addr + 3] <= wb_dat_i[31:24];
                end
                wb_dat_o <= {mem[wb_byte_addr + 3], mem[wb_byte_addr + 2], mem[wb_byte_addr + 1], mem[wb_byte_addr + 0]};
            end else begin
                wb_dat_o <= 32'h0;
            end
        end
    end
`endif
endmodule
