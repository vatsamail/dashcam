module simple_sram #(
    parameter ADDR_W = 16,
    parameter DEPTH = 65536
) (
    input  logic              clk,
    input  logic              dma_wr_en,
    input  logic [ADDR_W-1:0] dma_wr_addr,
    input  logic [7:0]        dma_wr_data,
    input  logic              wb_cyc,
    input  logic              wb_stb,
    input  logic              wb_we,
    input  logic [31:0]       wb_addr,
    input  logic [31:0]       wb_wdata,
    output logic [31:0]       wb_rdata,
    output logic              wb_ack
);
    logic [7:0] mem [0:DEPTH-1];
    logic wb_hit;
    logic [ADDR_W-1:0] wb_word_addr;

    assign wb_hit = wb_cyc && wb_stb && (wb_addr[31:28] == 4'h2);
    assign wb_word_addr = wb_addr[17:2] << 2;

    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) mem[i] = 8'h00;
    end

    always_ff @(posedge clk) begin
        if (dma_wr_en) begin
            mem[dma_wr_addr] <= dma_wr_data;
        end

        wb_ack <= wb_hit;
        if (wb_hit) begin
            if (wb_we) begin
                mem[wb_word_addr + 0] <= wb_wdata[7:0];
                mem[wb_word_addr + 1] <= wb_wdata[15:8];
                mem[wb_word_addr + 2] <= wb_wdata[23:16];
                mem[wb_word_addr + 3] <= wb_wdata[31:24];
            end
            wb_rdata <= {mem[wb_word_addr + 3], mem[wb_word_addr + 2], mem[wb_word_addr + 1], mem[wb_word_addr + 0]};
        end else begin
            wb_rdata <= 32'h0;
        end
    end
endmodule
