// ============================================================
// Module: governance_reg.v
// Description: Global State & Security Governance Register
//              Memory-Mapped Control Word for all slave modules
//
// Register Map (2-bit mode bus):
//   2'b00 = COMFORT  - Standard automated comfort logic
//   2'b01 = LOCKDOWN - High-sensitivity, immediate interrupts
//   2'b10 = Reserved
//   2'b11 = Reserved
// ============================================================

module governance_reg (
    input  wire        clk,
    input  wire        rst_n,
    // Write interface (from top-level / FPGA switches)
    input  wire        wr_en,          // Write enable strobe
    input  wire [1:0]  mode_in,        // Mode to write
    // Read interface (broadcast to all slave modules)
    output reg  [1:0]  mode_out,       // Current operating mode
    // Status flags
    output wire        comfort_mode,   // High when in COMFORT
    output wire        lockdown_mode   // High when in LOCKDOWN
);

    localparam COMFORT  = 2'b00;
    localparam LOCKDOWN = 2'b01;

    always @(posedge clk) begin
        if (!rst_n) begin
            mode_out <= COMFORT; // Default: comfort on reset
        end else if (wr_en) begin
            mode_out <= mode_in;
        end
    end

    assign comfort_mode  = (mode_out == COMFORT);
    assign lockdown_mode = (mode_out == LOCKDOWN);

endmodule
