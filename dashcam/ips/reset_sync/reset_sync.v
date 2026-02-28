module reset_sync (
    input  wire clk,
    input  wire rst_n,
    output wire rst_sync_n
);
    reg [1:0] sync_ff;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= 2'b00;
        end else begin
            sync_ff <= {sync_ff[0], 1'b1};
        end
    end
    assign rst_sync_n = sync_ff[1];
endmodule
