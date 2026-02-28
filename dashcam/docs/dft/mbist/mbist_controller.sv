module mbist_controller (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic done,
    output logic pass
);
    logic [3:0] ctr;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin ctr <= 0; done <= 0; pass <= 1; end
        else if (start) begin ctr <= 0; done <= 0; pass <= 1; end
        else if (!done) begin
            ctr <= ctr + 1;
            if (ctr == 4'hf) done <= 1;
        end
    end
endmodule
