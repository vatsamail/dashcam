module sdspi_stub (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [15:0] bytes,
    output logic [15:0] write_count,
    output logic        busy
);
    integer fd;
    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_count <= 16'h0;
            busy <= 1'b0;
        end else begin
            if (start) begin
                busy <= 1'b1;
                write_count <= write_count + 16'd1;
                fd = $fopen("out/sdcard.img", "ab");
                if (fd) begin
                    for (i = 0; i < bytes; i = i + 1) begin
                        $fwrite(fd, "%c", i[7:0]);
                    end
                    $fclose(fd);
                end
                busy <= 1'b0;
            end
        end
    end
endmodule
