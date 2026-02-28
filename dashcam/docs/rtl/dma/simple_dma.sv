module simple_dma (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [15:0] base,
    input  logic [15:0] len,
    input  logic        pix_valid,
    input  logic [7:0]  pix_data,
    output logic        wr_en,
    output logic [15:0] wr_addr,
    output logic [7:0]  wr_data,
    output logic [15:0] bytes_written,
    output logic        done
);
    logic active;

    always_ff @(posedge clk or negedge rst_n) begin
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
