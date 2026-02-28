module irq_ctrl (
    input  logic clk,
    input  logic rst_n,
    input  logic dma_done,
    input  logic clr,
    output logic irq,
    output logic pending
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pending <= 1'b0;
        end else begin
            if (dma_done) pending <= 1'b1;
            if (clr) pending <= 1'b0;
        end
    end
    assign irq = pending;
endmodule
