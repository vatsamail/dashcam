module camera_capture (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    input  logic       cam_valid,
    input  logic       cam_sof,
    input  logic [7:0] cam_pixel,
    output logic       pix_valid,
    output logic [7:0] pix_data,
    output logic [15:0] frame_count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pix_valid <= 1'b0;
            pix_data <= 8'h00;
            frame_count <= 16'h0;
        end else begin
            pix_valid <= enable && cam_valid;
            pix_data <= cam_pixel;
            if (enable && cam_valid && cam_sof) frame_count <= frame_count + 16'd1;
        end
    end
endmodule
