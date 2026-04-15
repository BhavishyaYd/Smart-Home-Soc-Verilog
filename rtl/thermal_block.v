// ============================================================
// Module: thermal_block.v
// Description: Autonomous Thermal Intelligence Block
//              8-bit comparator with hysteresis for HVAC control
// ============================================================

module thermal_block (
    input  wire        clk,
    input  wire        rst_n,          // Active-low synchronous reset
    input  wire [7:0]  temp_in,        // 8-bit temperature sensor input
    input  wire [7:0]  threshold,      // User-defined temperature threshold
    input  wire [7:0]  hyst_val,       // Hysteresis band value (e.g., 8'd5)
    output reg         cooling_on,     // Cooling actuator signal
    output reg         overheat_irq    // Overheat interrupt (buzzer trigger)
);

    // Internal state
    reg cooling_state; // Tracks current cooling on/off state for hysteresis

    always @(posedge clk) begin
        if (!rst_n) begin
            cooling_on    <= 1'b0;
            overheat_irq  <= 1'b0;
            cooling_state <= 1'b0;
        end else begin
            // Hysteresis Logic Loop:
            // Turn ON  cooling when temp > threshold
            // Turn OFF cooling when temp < (threshold - hyst_val)
            if (!cooling_state) begin
                if (temp_in > threshold) begin
                    cooling_state <= 1'b1;
                    cooling_on    <= 1'b1;
                    overheat_irq  <= 1'b1;
                end else begin
                    overheat_irq  <= 1'b0;
                end
            end else begin
                if (temp_in < (threshold - hyst_val)) begin
                    cooling_state <= 1'b0;
                    cooling_on    <= 1'b0;
                    overheat_irq  <= 1'b0;
                end
            end
        end
    end

endmodule
