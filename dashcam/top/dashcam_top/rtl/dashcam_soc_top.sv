`include "dashcam_csr_offsets.vh"

module dashcam_soc_top #(
    parameter USE_CPU = 0
) (
    input  wire        clk,
    input  wire        rst_n,

    // External Wishbone master (used when USE_CPU=0)
    input  wire        wb_cyc_i,
    input  wire        wb_stb_i,
    input  wire        wb_we_i,
    input  wire [3:0]  wb_sel_i,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output wire [31:0] wb_dat_o,
    output wire        wb_ack_o,

    // Camera input
    input  wire        cam_valid,
    input  wire        cam_sof,
    input  wire [7:0]  cam_pixel,

    // IRQ output
    output wire        irq
);
    // Master signals to interconnect
    wire [31:0] m_adr;
    wire [31:0] m_dat_o;
    wire [31:0] m_dat_i;
    wire        m_we;
    wire [3:0]  m_sel;
    wire        m_stb;
    wire        m_cyc;
    wire        m_ack;

    wire [2:0]  m_cti = 3'b000;
    wire [1:0]  m_bte = 2'b00;

    wire rst_sync_n;
    reset_sync u_reset_sync (
        .clk(clk),
        .rst_n(rst_n),
        .rst_sync_n(rst_sync_n)
    );

    generate
        if (USE_CPU) begin : gen_cpu
            wire cpu_trap;
            picorv32_wb #(
                .ENABLE_MUL(1),
                .ENABLE_DIV(1),
                .ENABLE_IRQ(1)
            ) u_cpu (
                .trap(cpu_trap),
                .wb_rst_i(!rst_sync_n),
                .wb_clk_i(clk),
                .wbm_adr_o(m_adr),
                .wbm_dat_o(m_dat_o),
                .wbm_dat_i(m_dat_i),
                .wbm_we_o(m_we),
                .wbm_sel_o(m_sel),
                .wbm_stb_o(m_stb),
                .wbm_ack_i(m_ack),
                .wbm_cyc_o(m_cyc),
                .pcpi_valid(),
                .pcpi_insn(),
                .pcpi_rs1(),
                .pcpi_rs2(),
                .pcpi_wr(1'b0),
                .pcpi_rd(32'h0),
                .pcpi_wait(1'b0),
                .pcpi_ready(1'b0),
                .irq(32'h0),
                .eoi()
            );
            assign wb_dat_o = 32'h0;
            assign wb_ack_o = 1'b0;
        end else begin : gen_ext
            assign m_adr = wb_adr_i;
            assign m_dat_o = wb_dat_i;
            assign m_we = wb_we_i;
            assign m_sel = wb_sel_i;
            assign m_stb = wb_stb_i;
            assign m_cyc = wb_cyc_i;
            assign wb_dat_o = m_dat_i;
            assign wb_ack_o = m_ack;
        end
    endgenerate

    // Interconnect
    localparam NUM_SLAVES = 2;
    localparam [NUM_SLAVES*32-1:0] MATCH_ADDR = {32'h2000_0000, 32'h1000_0000};
    localparam [NUM_SLAVES*32-1:0] MATCH_MASK = {32'hF000_0000, 32'hFFFF_F000};

    wire [NUM_SLAVES*32-1:0] wbs_adr;
    wire [NUM_SLAVES*32-1:0] wbs_dat_o;
    wire [NUM_SLAVES*4-1:0]  wbs_sel;
    wire [NUM_SLAVES-1:0]    wbs_we;
    wire [NUM_SLAVES-1:0]    wbs_cyc;
    wire [NUM_SLAVES-1:0]    wbs_stb;
    wire [NUM_SLAVES*3-1:0]  wbs_cti;
    wire [NUM_SLAVES*2-1:0]  wbs_bte;
    wire [NUM_SLAVES*32-1:0] wbs_dat_i;
    wire [NUM_SLAVES-1:0]    wbs_ack;
    wire [NUM_SLAVES-1:0]    wbs_err;
    wire [NUM_SLAVES-1:0]    wbs_rty;

    wb_mux #(
        .dw(32),
        .aw(32),
        .num_slaves(NUM_SLAVES),
        .MATCH_ADDR(MATCH_ADDR),
        .MATCH_MASK(MATCH_MASK)
    ) u_wb_mux (
        .wb_clk_i(clk),
        .wb_rst_i(!rst_sync_n),
        .wbm_adr_i(m_adr),
        .wbm_dat_i(m_dat_o),
        .wbm_sel_i(m_sel),
        .wbm_we_i(m_we),
        .wbm_cyc_i(m_cyc),
        .wbm_stb_i(m_stb),
        .wbm_cti_i(m_cti),
        .wbm_bte_i(m_bte),
        .wbm_dat_o(m_dat_i),
        .wbm_ack_o(m_ack),
        .wbm_err_o(),
        .wbm_rty_o(),
        .wbs_adr_o(wbs_adr),
        .wbs_dat_o(wbs_dat_o),
        .wbs_sel_o(wbs_sel),
        .wbs_we_o(wbs_we),
        .wbs_cyc_o(wbs_cyc),
        .wbs_stb_o(wbs_stb),
        .wbs_cti_o(wbs_cti),
        .wbs_bte_o(wbs_bte),
        .wbs_dat_i(wbs_dat_i),
        .wbs_ack_i(wbs_ack),
        .wbs_err_i(wbs_err),
        .wbs_rty_i(wbs_rty)
    );

    assign wbs_err = {NUM_SLAVES{1'b0}};
    assign wbs_rty = {NUM_SLAVES{1'b0}};

    // Slave 0: CSR
    wire [31:0] ctrl;
    wire        ctrl_we;
    wire [31:0] dma_base;
    wire        dma_base_we;
    wire [31:0] dma_len;
    wire        dma_len_we;
    wire [31:0] iomux_sel;
    wire        iomux_sel_we;
    wire        irq_clear_pulse;

    wire [15:0] frame_count;
    wire [15:0] bytes_written;
    wire        dma_done;
    wire        irq_pending;
    wire [15:0] sd_write_count;

    wire [31:0] cam_status = {16'h0, frame_count};
    wire [31:0] dma_status = {bytes_written, 15'h0, dma_done};
    wire [31:0] irq_status = {31'h0, irq_pending};
    wire [31:0] sd_status = {16'h0, sd_write_count};
    wire [31:0] build_info = 32'h20260226;

    dashcam_csr_regs u_csrs (
        .clk(clk),
        .rst_n(rst_sync_n),
        .wb_adr_i(wbs_adr[0*32 +: 32]),
        .wb_dat_i(wbs_dat_o[0*32 +: 32]),
        .wb_dat_o(wbs_dat_i[0*32 +: 32]),
        .wb_we_i(wbs_we[0]),
        .wb_stb_i(wbs_stb[0]),
        .wb_cyc_i(wbs_cyc[0]),
        .wb_ack_o(wbs_ack[0]),
        .ctrl(ctrl),
        .ctrl_we(ctrl_we),
        .dma_base(dma_base),
        .dma_base_we(dma_base_we),
        .dma_len(dma_len),
        .dma_len_we(dma_len_we),
        .irq_clear_pulse(irq_clear_pulse),
        .iomux_sel(iomux_sel),
        .iomux_sel_we(iomux_sel_we),
        .cam_status_in(cam_status),
        .dma_status_in(dma_status),
        .irq_status_in(irq_status),
        .sd_status_in(sd_status),
        .build_info_in(build_info)
    );

    // Camera, DMA, peripherals
    wire pix_valid;
    wire [7:0] pix_data;
    wire dma_start_pulse = ctrl_we && ctrl[1];
    wire cam_en = ctrl[0];
    wire sd_en = ctrl[2];
    wire irq_en = ctrl[3];

    camera_capture u_cam (
        .clk(clk),
        .rst_n(rst_sync_n),
        .enable(cam_en),
        .cam_valid(cam_valid),
        .cam_sof(cam_sof),
        .cam_pixel(cam_pixel),
        .pix_valid(pix_valid),
        .pix_data(pix_data),
        .frame_count(frame_count)
    );

    wire dma_wr_en;
    wire [15:0] dma_wr_addr;
    wire [7:0] dma_wr_data;

    simple_dma u_dma (
        .clk(clk),
        .rst_n(rst_sync_n),
        .start(dma_start_pulse),
        .base(dma_base[15:0]),
        .len(dma_len[15:0]),
        .pix_valid(pix_valid),
        .pix_data(pix_data),
        .wr_en(dma_wr_en),
        .wr_addr(dma_wr_addr),
        .wr_data(dma_wr_data),
        .bytes_written(bytes_written),
        .done(dma_done)
    );

    // Slave 1: Framebuffer SRAM with DMA write port
    simple_sram #(
        .ADDR_W(16),
        .DEPTH(65536)
    ) u_fb_sram (
        .clk(clk),
        .rst_n(rst_sync_n),
        .dma_wr_en(dma_wr_en),
        .dma_wr_addr(dma_wr_addr),
        .dma_wr_data(dma_wr_data),
        .wb_cyc_i(wbs_cyc[1]),
        .wb_stb_i(wbs_stb[1]),
        .wb_we_i(wbs_we[1]),
        .wb_sel_i(wbs_sel[1*4 +: 4]),
        .wb_adr_i(wbs_adr[1*32 +: 32]),
        .wb_dat_i(wbs_dat_o[1*32 +: 32]),
        .wb_dat_o(wbs_dat_i[1*32 +: 32]),
        .wb_ack_o(wbs_ack[1])
    );

    irq_ctrl u_irq (
        .clk(clk),
        .rst_n(rst_sync_n),
        .dma_done(dma_done),
        .clr(irq_clear_pulse),
        .irq(),
        .pending(irq_pending)
    );

    iomux u_iomux (
        .clk(clk),
        .rst_n(rst_sync_n),
        .sel_i(iomux_sel[3:0]),
        .sel_o()
    );

    sdspi_stub u_sd (
        .clk(clk),
        .rst_n(rst_sync_n),
        .start(dma_done && sd_en),
        .bytes(dma_len[15:0]),
        .write_count(sd_write_count),
        .busy()
    );

    assign irq = irq_en && irq_pending;
endmodule
