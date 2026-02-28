module simple_dma (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] base,
    input  wire [15:0] len,
    input  wire        pix_valid,
    input  wire [7:0]  pix_data,
    output reg         wr_en,
    output reg  [15:0] wr_addr,
    output reg  [7:0]  wr_data,
    output reg  [15:0] bytes_written,
    output reg         done
);
    reg active;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active <= 1'b0;
            bytes_written <= 16'h0;
            wr_en <= 1'b0;
            wr_addr <= 16'h0;
            wr_data <= 8'h0;
            done <= 1'b0;
        end else begin
            wr_en <= 1'b0;
            done <= 1'b0;
            if (start) begin
                active <= 1'b1;
                bytes_written <= 16'h0;
            end
            if (active && pix_valid) begin
                wr_en <= 1'b1;
                wr_addr <= base + bytes_written;
                wr_data <= pix_data;
                bytes_written <= bytes_written + 16'd1;
                if (bytes_written + 16'd1 >= len) begin
                    active <= 1'b0;
                    done <= 1'b1;
                end
            end
        end
    end
endmodule
