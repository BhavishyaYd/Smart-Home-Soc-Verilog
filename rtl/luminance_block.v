// ============================================================
// Module: luminance_block.v
// Description: Digital Luminance Processing Module
//              Low-pass filter + glitch-free LED switching
// ============================================================

module luminance_block (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  light_in,       // 8-bit ambient light sensor
    input  wire [7:0]  lux_threshold,  // Light threshold for darkness detection
    output reg         led_on          // LED lighting control
);

    // -------------------------------------------------------
    // Digital Low-Pass Filter (IIR, alpha ~ 0.25)
    // filtered = (3*filtered + light_in) / 4
    // Implemented with shifts to avoid dividers
    // -------------------------------------------------------
    reg [9:0] filtered; // Extended precision accumulator

    always @(posedge clk) begin
        if (!rst_n) begin
            filtered <= 10'd0;
            led_on   <= 1'b0;
        end else begin
            // IIR: filtered = filtered - (filtered >> 2) + (light_in >> 2)
            filtered <= filtered - (filtered >> 2) + ({2'b00, light_in} >> 2);

            // Glitch-free switching: use filtered[9:2] as 8-bit result
            // LED ON when filtered light level is BELOW threshold
            if (filtered[9:2] < lux_threshold) begin
                led_on <= 1'b1;
            end else begin
                led_on <= 1'b0;
            end
        end
    end

endmodule
