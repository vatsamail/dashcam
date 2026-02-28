//==============================================================================
// File      : crypto_block.v
// Author    : Open-Source Example
// Version   : 1.0
// SPDX-License-Identifier: Apache-2.0
// Description: Simple cryptographic block mock-up (AES-like interface)
//==============================================================================
module crypto_block
(
    input  wire        clk,
    input  wire        reset_n,
    input  wire        start,
    input  wire [127:0] key,
    input  wire [127:0] data_in,
    output wire [127:0] data_out,
    output wire         done
);

    //--------------------------------------------------------------------------
    // State machine for encryption
    //--------------------------------------------------------------------------
    typedef enum logic [1:0] {
        IDLE,
        BUSY,
        DONE
    } aes_state_e;

    reg [1:0] state, next_state;
    reg [127:0] r_data;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state  <= IDLE;
            r_data <= 128'h0;
        end else begin
            state <= next_state;
            if (start && state == IDLE) begin
                r_data <= data_in ^ key; // trivial "encryption"
            end else if (state == BUSY) begin
                r_data <= r_data + 128'h1; // mock round operation
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = BUSY;
            BUSY: next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end

    assign done      = (state == DONE);
    assign data_out  = r_data;

endmodule
