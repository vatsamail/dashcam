//==============================================================================
// File      : axi_interconnect.v
// Author    : Open-Source Example
// Version   : 1.0
// SPDX-License-Identifier: Apache-2.0
// Description: Simple multi-master, multi-slave AXI interconnect mock-up
//==============================================================================

module axi_interconnect
#(
    parameter NUM_MASTERS = 2,
    parameter NUM_SLAVES  = 2,
    parameter ADDR_WIDTH  = 32,
    parameter DATA_WIDTH  = 32
)
(
    // Masters' AXI Interfaces
    input  wire [NUM_MASTERS-1:0]                M_AXI_ACLK,
    input  wire [NUM_MASTERS-1:0]                M_AXI_ARESETN,
    // For brevity, we model only the AR channel:
    input  wire [NUM_MASTERS*ADDR_WIDTH-1:0]     M_AXI_ARADDR,
    input  wire [NUM_MASTERS*3-1:0]              M_AXI_ARPROT,
    input  wire [NUM_MASTERS-1:0]                M_AXI_ARVALID,
    output wire [NUM_MASTERS-1:0]                M_AXI_ARREADY,

    // Slaves' AXI Interfaces
    output wire [NUM_SLAVES*ADDR_WIDTH-1:0]      S_AXI_ARADDR,
    output wire [NUM_SLAVES*3-1:0]               S_AXI_ARPROT,
    output wire [NUM_SLAVES-1:0]                 S_AXI_ARVALID,
    input  wire [NUM_SLAVES-1:0]                 S_AXI_ARREADY
);

    //--------------------------------------------------------------------------
    // Address decoder / rudimentary route
    // (In a real design, you'd parse the address, figure out which slave to
    //  route to, handle arbitration among masters, etc.)
    //--------------------------------------------------------------------------

    // For simplicity, assume all requests go to slave 0 if ARADDR < 0x8000_0000
    // otherwise go to slave 1. The logic below is simplified for demonstration.
    reg [NUM_MASTERS-1:0] route_to_slave0;
    integer i;

    always @(*) begin
        for (i=0; i<NUM_MASTERS; i=i+1) begin
            if (M_AXI_ARADDR[i*ADDR_WIDTH +: ADDR_WIDTH] < 32'h8000_0000)
                route_to_slave0[i] = 1'b1;
            else
                route_to_slave0[i] = 1'b0;
        end
    end

    // Connect masters to slaves
    // In practice, you need one-hot for each slave, plus arbitration.
    assign S_AXI_ARADDR[0*ADDR_WIDTH +: ADDR_WIDTH] = (|route_to_slave0) 
        ? M_AXI_ARADDR[0*ADDR_WIDTH +: ADDR_WIDTH] : {ADDR_WIDTH{1'b0}};
    assign S_AXI_ARADDR[1*ADDR_WIDTH +: ADDR_WIDTH] = (~|route_to_slave0) 
        ? M_AXI_ARADDR[0*ADDR_WIDTH +: ADDR_WIDTH] : {ADDR_WIDTH{1'b0}};

    // Pass through ARPROT (simplified)
    assign S_AXI_ARPROT[0*3 +: 3] = (|route_to_slave0)
        ? M_AXI_ARPROT[0*3 +: 3] : 3'b000;
    assign S_AXI_ARPROT[1*3 +: 3] = (~|route_to_slave0)
        ? M_AXI_ARPROT[0*3 +: 3] : 3'b000;

    // Pass through ARVALID
    assign S_AXI_ARVALID[0] = (|route_to_slave0) & M_AXI_ARVALID[0];
    assign S_AXI_ARVALID[1] = (~|route_to_slave0) & M_AXI_ARVALID[0];

    // ARREADY from slaves -> back to the corresponding master
    assign M_AXI_ARREADY[0] = (S_AXI_ARREADY[0] & (|route_to_slave0))
                           | (S_AXI_ARREADY[1] & (~|route_to_slave0));

    // For demonstration, we only connect the 1st master signals.
    // Additional masters require more complex arbitration logic.

endmodule
