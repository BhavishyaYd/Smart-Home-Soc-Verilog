module gate_control (
    input clk,
    input rst_n,
    input doorbell_in,
    output reg pwm_out,
    output reg gate_open_led
);

    reg gate_open;
    reg [15:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            gate_open <= 0;
            counter <= 0;
        end else begin
            if (doorbell_in && !gate_open) begin
                gate_open <= 1;
                counter <= 0;
            end else if (gate_open) begin
                counter <= counter + 1;
                if (counter > 2000)   // shortened for simulation
                    gate_open <= 0;
            end
        end
    end

    always @(posedge clk) begin
        pwm_out <= gate_open;
        gate_open_led <= gate_open;
    end

endmodule