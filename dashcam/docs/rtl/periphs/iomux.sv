module iomux (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] sel_i,
    output logic [3:0] sel_o
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) sel_o <= 4'h0;
        else sel_o <= sel_i;
    end
endmodule
