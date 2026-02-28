`include "soc_csr_offsets.vh"

module dashcam_soc_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wb_cyc,
    input  logic        wb_stb,
    input  logic        wb_we,
    input  logic [31:0] wb_addr,
    input  logic [31:0] wb_wdata,
    output logic [31:0] wb_rdata,
    output logic        wb_ack,
    input  logic        cam_valid,
    input  logic        cam_sof,
    input  logic [7:0]  cam_pixel,
    output logic        irq
);
    logic [31:0] csr_rdata;
    logic csr_ack;

    logic [31:0] ctrl;
    logic [31:0] dma_base;
    logic [31:0] dma_len;
    logic [31:0] iomux_sel;

    logic cam_en;
    logic sd_en;
    logic dma_start_pulse;
    logic irq_en;

    logic pix_valid;
    logic [7:0] pix_data;
    logic [15:0] frame_count;

    logic dma_wr_en;
    logic [15:0] dma_wr_addr;
    logic [7:0] dma_wr_data;
    logic [15:0] bytes_written;
    logic dma_done;

    logic irq_pending;
    logic irq_clr;

    logic [3:0] iomux_lat;
    logic [15:0] sd_write_count;
    logic sd_start;
    logic irq_unused;
    logic sd_busy;

    logic [31:0] mem_rdata;
    logic mem_ack;

    assign cam_en = ctrl[0];
    assign irq_en = ctrl[3];
    assign sd_en = ctrl[2];
    assign sd_start = dma_done && sd_en;
    assign irq = irq_en && irq_pending;

    camera_capture u_cam (
        .clk, .rst_n, .enable(cam_en), .cam_valid, .cam_sof, .cam_pixel,
        .pix_valid, .pix_data, .frame_count
    );

    simple_dma u_dma (
        .clk, .rst_n,
        .start(dma_start_pulse),
        .base(dma_base[15:0]),
        .len(dma_len[15:0]),
        .pix_valid,
        .pix_data,
        .wr_en(dma_wr_en),
        .wr_addr(dma_wr_addr),
        .wr_data(dma_wr_data),
        .bytes_written,
        .done(dma_done)
    );

    simple_sram u_mem (
        .clk,
        .dma_wr_en,
        .dma_wr_addr,
        .dma_wr_data,
        .wb_cyc,
        .wb_stb,
        .wb_we,
        .wb_addr,
        .wb_wdata,
        .wb_rdata(mem_rdata),
        .wb_ack(mem_ack)
    );

    irq_ctrl u_irq (
        .clk,
        .rst_n,
        .dma_done,
        .clr(irq_clr),
        .irq(irq_unused),
        .pending(irq_pending)
    );

    iomux u_iomux (
        .clk,
        .rst_n,
        .sel_i(iomux_sel[3:0]),
        .sel_o(iomux_lat)
    );

    sdspi_stub u_sd (
        .clk,
        .rst_n,
        .start(sd_start),
        .bytes(dma_len[15:0]),
        .write_count(sd_write_count),
        .busy(sd_busy)
    );

    function automatic logic csr_hit(input logic [31:0] a);
        csr_hit = (a[31:12] == 20'h10000);
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl <= 32'h0;
            dma_base <= 32'h0;
            dma_len <= 32'd64;
            iomux_sel <= 32'h0;
            dma_start_pulse <= 1'b0;
            irq_clr <= 1'b0;
            csr_ack <= 1'b0;
            csr_rdata <= 32'h0;
        end else begin
            dma_start_pulse <= 1'b0;
            irq_clr <= 1'b0;
            csr_ack <= 1'b0;
            csr_rdata <= 32'h0;

            if (wb_cyc && wb_stb && csr_hit(wb_addr)) begin
                csr_ack <= 1'b1;
                if (wb_we) begin
                    case (wb_addr[7:0])
                        `CSR_CTRL: begin
                            ctrl <= wb_wdata;
                            if (wb_wdata[1]) dma_start_pulse <= 1'b1;
                        end
                        `CSR_DMA_BASE: dma_base <= wb_wdata;
                        `CSR_DMA_LEN: dma_len <= wb_wdata;
                        `CSR_IRQ_CLEAR: if (wb_wdata[0]) irq_clr <= 1'b1;
                        `CSR_IOMUX_SEL: iomux_sel <= wb_wdata;
                        default: ;
                    endcase
                end else begin
                    case (wb_addr[7:0])
                        `CSR_CTRL: csr_rdata <= ctrl;
                        `CSR_CAM_STATUS: csr_rdata <= {16'h0, frame_count};
                        `CSR_DMA_BASE: csr_rdata <= dma_base;
                        `CSR_DMA_LEN: csr_rdata <= dma_len;
                        `CSR_DMA_STATUS: csr_rdata <= {bytes_written, 15'h0, dma_done};
                        `CSR_IRQ_STATUS: csr_rdata <= {31'h0, irq_pending};
                        `CSR_IOMUX_SEL: csr_rdata <= iomux_sel;
                        `CSR_SD_STATUS: csr_rdata <= {16'h0, sd_write_count};
                        `CSR_BUILD_INFO: csr_rdata <= 32'h20260226;
                        default: csr_rdata <= 32'h0;
                    endcase
                end
            end
        end
    end

    assign wb_rdata = csr_hit(wb_addr) ? csr_rdata : mem_rdata;
    assign wb_ack = csr_hit(wb_addr) ? csr_ack : mem_ack;
endmodule
