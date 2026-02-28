module tb_dashcam_smoke;
    reg clk;
    reg rst_n;

    reg wb_cyc;
    reg wb_stb;
    reg wb_we;
    reg [3:0] wb_sel;
    reg [31:0] wb_addr;
    reg [31:0] wb_wdata;
    wire [31:0] wb_rdata;
    wire wb_ack;

    reg cam_valid;
    reg cam_sof;
    reg [7:0] cam_pixel;
    wire irq;

    localparam CSR_BASE = 32'h1000_0000;
    localparam MEM_BASE = 32'h2000_0000;

    dashcam_soc_top #(.USE_CPU(0)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wb_cyc_i(wb_cyc),
        .wb_stb_i(wb_stb),
        .wb_we_i(wb_we),
        .wb_sel_i(wb_sel),
        .wb_adr_i(wb_addr),
        .wb_dat_i(wb_wdata),
        .wb_dat_o(wb_rdata),
        .wb_ack_o(wb_ack),
        .cam_valid(cam_valid),
        .cam_sof(cam_sof),
        .cam_pixel(cam_pixel),
        .irq(irq)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task automatic wb_write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge clk);
            wb_cyc <= 1'b1;
            wb_stb <= 1'b1;
            wb_we <= 1'b1;
            wb_sel <= 4'hF;
            wb_addr <= addr;
            wb_wdata <= data;
            do @(posedge clk); while (!wb_ack);
            wb_cyc <= 1'b0;
            wb_stb <= 1'b0;
            wb_we <= 1'b0;
            wb_sel <= 4'h0;
        end
    endtask

    task automatic wb_read(input [31:0] addr, output [31:0] data);
        begin
            @(posedge clk);
            wb_cyc <= 1'b1;
            wb_stb <= 1'b1;
            wb_we <= 1'b0;
            wb_sel <= 4'hF;
            wb_addr <= addr;
            do @(posedge clk); while (!wb_ack);
            data = wb_rdata;
            wb_cyc <= 1'b0;
            wb_stb <= 1'b0;
            wb_sel <= 4'h0;
        end
    endtask

    task automatic send_frame(input integer nbytes);
        integer i;
        begin
            cam_valid <= 1'b0;
            cam_sof <= 1'b0;
            cam_pixel <= 8'h00;
            @(posedge clk);
            for (i = 0; i < nbytes; i = i + 1) begin
                cam_valid <= 1'b1;
                cam_sof <= (i == 0);
                cam_pixel <= i[7:0];
                @(posedge clk);
            end
            cam_valid <= 1'b0;
            cam_sof <= 1'b0;
        end
    endtask

    task automatic dump_ppm;
        integer fd;
        integer i;
        reg [31:0] word;
        reg [7:0] pix;
        begin
            fd = $fopen("out/frame_0000.ppm", "w");
            if (!fd) begin
                $fatal(1, "cannot open ppm output");
            end
            $fwrite(fd, "P3\n8 8\n255\n");
            for (i = 0; i < 64; i = i + 1) begin
                wb_read(MEM_BASE + (i & ~32'h3), word);
                case (i[1:0])
                    2'd0: pix = word[7:0];
                    2'd1: pix = word[15:8];
                    2'd2: pix = word[23:16];
                    default: pix = word[31:24];
                endcase
                $fwrite(fd, "%0d %0d %0d\n", pix, pix, pix);
            end
            $fclose(fd);
        end
    endtask

    reg [31:0] r;
    initial begin
        wb_cyc = 0;
        wb_stb = 0;
        wb_we = 0;
        wb_sel = 0;
        wb_addr = 0;
        wb_wdata = 0;
        cam_valid = 0;
        cam_sof = 0;
        cam_pixel = 0;

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;

        wb_write(CSR_BASE + 32'h08, 32'h0);
        wb_write(CSR_BASE + 32'h0c, 32'd64);
        wb_write(CSR_BASE + 32'h1c, 32'h3);
        wb_write(CSR_BASE + 32'h00, 32'b1101); // cam_en, sd_en, irq_en
        wb_write(CSR_BASE + 32'h00, 32'b1111); // + dma_start pulse

        send_frame(64);

        repeat (50) @(posedge clk);
        if (!irq) $fatal(1, "IRQ did not assert");

        wb_read(CSR_BASE + 32'h04, r);
        if (r[15:0] != 16'd1) $fatal(1, "frame_count mismatch: %0d", r[15:0]);

        wb_read(CSR_BASE + 32'h10, r);
        if (r[31:16] != 16'd64) $fatal(1, "dma bytes_written mismatch: %0d", r[31:16]);

        wb_read(CSR_BASE + 32'h14, r);
        if (r[0] != 1'b1) $fatal(1, "irq status missing");

        wb_write(CSR_BASE + 32'h18, 32'h1);
        repeat (3) @(posedge clk);
        wb_read(CSR_BASE + 32'h14, r);
        if (r[0] != 1'b0) $fatal(1, "irq did not clear");

        wb_read(CSR_BASE + 32'h20, r);
        if (r[15:0] < 16'd1) $fatal(1, "sd write path not invoked");

        dump_ppm();

        $display("SMOKE_PASS frame_count=1 bytes=64 sd_writes=%0d", r[15:0]);
        $finish;
    end
endmodule
