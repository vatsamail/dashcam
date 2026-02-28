module iomux (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] sel_i,
    output reg  [3:0] sel_o
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sel_o <= 4'h0;
        end else begin
            sel_o <= sel_i;
        end
    end
endmodule
