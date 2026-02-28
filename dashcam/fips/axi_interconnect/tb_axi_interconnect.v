//==============================================================================
// File      : tb_axi_interconnect.v
// Author    : Open-Source Example
// Description: Simple testbench for axi_interconnect
//==============================================================================
`timescale 1ns/1ps

module tb_axi_interconnect;

    localparam NUM_MASTERS = 2;
    localparam NUM_SLAVES  = 2;
    localparam ADDR_WIDTH  = 32;
    localparam DATA_WIDTH  = 32;

    // Master 0 signals
    reg                 m0_aclk;
    reg                 m0_aresetn;
    reg [ADDR_WIDTH-1:0] m0_araddr;
    reg [2:0]            m0_arprot;
    reg                  m0_arvalid;
    wire                 m0_arready;

    // Slave signals
    wire [NUM_SLAVES*ADDR_WIDTH-1:0] s_araddr;
    wire [NUM_SLAVES*3-1:0]          s_arprot;
    wire [NUM_SLAVES-1:0]            s_arvalid;
    reg  [NUM_SLAVES-1:0]            s_arready;

    // DUT instantiation
    axi_interconnect #(
        .NUM_MASTERS(NUM_MASTERS),
        .NUM_SLAVES(NUM_SLAVES),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .M_AXI_ACLK       ({(NUM_MASTERS){m0_aclk}}),
        .M_AXI_ARESETN    ({(NUM_MASTERS){m0_aresetn}}),
        .M_AXI_ARADDR     ({m0_araddr}), // only hooking up master 0 for demonstration
        .M_AXI_ARPROT     ({m0_arprot}),
        .M_AXI_ARVALID    ({m0_arvalid}),
        .M_AXI_ARREADY    (m0_arready),

        .S_AXI_ARADDR     (s_araddr),
        .S_AXI_ARPROT     (s_arprot),
        .S_AXI_ARVALID    (s_arvalid),
        .S_AXI_ARREADY    (s_arready)
    );

    // Clock
    initial begin
        m0_aclk = 0;
        forever #5 m0_aclk = ~m0_aclk;
    end

    initial begin
        m0_aresetn = 0;
        #25 m0_aresetn = 1;
    end

    initial begin
        m0_araddr  = 32'h0000_1000;
        m0_arprot  = 3'b000;
        m0_arvalid = 1'b0;
        s_arready  = 2'b11;  // Slaves always ready

        @(posedge m0_aclk);
        @(posedge m0_aclk);
        m0_arvalid = 1'b1;
        @(posedge m0_aclk);
        m0_arvalid = 1'b0;

        // Wait some cycles
        repeat (10) @(posedge m0_aclk);

        // Try address in second region
        m0_araddr = 32'h9000_0000;
        m0_arvalid = 1'b1;
        @(posedge m0_aclk);
        m0_arvalid = 1'b0;

        // End
        #50;
        $finish;
    end

endmodule
