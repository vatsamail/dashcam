module camera_capture (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        cam_valid,
    input  wire        cam_sof,
    input  wire [7:0]  cam_pixel,
    output reg         pix_valid,
    output reg  [7:0]  pix_data,
    output reg  [15:0] frame_count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pix_valid <= 1'b0;
            pix_data <= 8'h00;
            frame_count <= 16'h0;
        end else begin
            pix_valid <= enable && cam_valid;
            pix_data <= cam_pixel;
            if (enable && cam_valid && cam_sof) begin
                frame_count <= frame_count + 16'd1;
            end
        end
    end
endmodule
