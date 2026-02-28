`include "dashcam_csr_offsets.vh"
module dashcam_csr_regs (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output reg         wb_ack_o,
    output reg  [31:0] ctrl,
    output reg         ctrl_we,
    output reg  [31:0] dma_base,
    output reg         dma_base_we,
    output reg  [31:0] dma_len,
    output reg         dma_len_we,
    output reg  [31:0] iomux_sel,
    output reg         iomux_sel_we,
    output reg         irq_clear_pulse,
    input  wire [31:0] cam_status_in,
    input  wire [31:0] dma_status_in,
    input  wire [31:0] irq_status_in,
    input  wire [31:0] sd_status_in,
    input  wire [31:0] build_info_in
);

    wire sel = wb_stb_i & wb_cyc_i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl <= 32'h00000000;
            ctrl_we <= 1'b0;
            dma_base <= 32'h00000000;
            dma_base_we <= 1'b0;
            dma_len <= 32'h00000040;
            dma_len_we <= 1'b0;
            iomux_sel <= 32'h00000000;
            iomux_sel_we <= 1'b0;
            irq_clear_pulse <= 1'b0;
            wb_ack_o <= 1'b0;
        end else begin
            wb_ack_o <= 1'b0;
            ctrl_we <= 1'b0;
            dma_base_we <= 1'b0;
            dma_len_we <= 1'b0;
            iomux_sel_we <= 1'b0;
            irq_clear_pulse <= 1'b0;
            if (sel) begin
                wb_ack_o <= 1'b1;
                if (wb_we_i) begin
                    case (wb_adr_i[7:0])
                        `CSR_CTRL: begin
                            ctrl <= wb_dat_i;
                            ctrl_we <= 1'b1;
                        end
                        `CSR_DMA_BASE: begin
                            dma_base <= wb_dat_i;
                            dma_base_we <= 1'b1;
                        end
                        `CSR_DMA_LEN: begin
                            dma_len <= wb_dat_i;
                            dma_len_we <= 1'b1;
                        end
                        `CSR_IOMUX_SEL: begin
                            iomux_sel <= wb_dat_i;
                            iomux_sel_we <= 1'b1;
                        end
                        `CSR_IRQ_CLEAR: begin
                            irq_clear_pulse <= wb_dat_i[0];
                        end
                        default: ;
                    endcase
                end
            end
        end
    end

    always @(*) begin
        wb_dat_o = 32'h0;
        case (wb_adr_i[7:0])
            `CSR_CTRL: wb_dat_o = ctrl;
            `CSR_DMA_BASE: wb_dat_o = dma_base;
            `CSR_DMA_LEN: wb_dat_o = dma_len;
            `CSR_IOMUX_SEL: wb_dat_o = iomux_sel;
            `CSR_CAM_STATUS: wb_dat_o = cam_status_in;
            `CSR_DMA_STATUS: wb_dat_o = dma_status_in;
            `CSR_IRQ_STATUS: wb_dat_o = irq_status_in;
            `CSR_SD_STATUS: wb_dat_o = sd_status_in;
            `CSR_BUILD_INFO: wb_dat_o = build_info_in;
            `CSR_IRQ_CLEAR: wb_dat_o = 32'h0;
            default: wb_dat_o = 32'h0;
        endcase
    end
endmodule
