module irq_ctrl (
    input  wire clk,
    input  wire rst_n,
    input  wire dma_done,
    input  wire clr,
    output wire irq,
    output reg  pending
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pending <= 1'b0;
        end else begin
            if (dma_done) pending <= 1'b1;
            if (clr) pending <= 1'b0;
        end
    end
    assign irq = pending;
endmodule
