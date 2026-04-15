module security_fsm (
    input clk,
    input rst_n,
    input arm_btn,
    input disarm_btn,
    input motion_in,
    output reg strobe_led,
    output reg alarm_tone
);

    reg [2:0] state;

    localparam NORMAL = 3'b001,
               ARMED  = 3'b010,
               ALARM  = 3'b100;

    always @(posedge clk) begin
        if (!rst_n)
            state <= NORMAL;
        else begin
            case (state)
                NORMAL: if (arm_btn) state <= ARMED;
                ARMED: begin
                    if (motion_in) state <= ALARM;
                    else if (disarm_btn) state <= NORMAL;
                end
                ALARM: if (disarm_btn) state <= NORMAL;
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == ALARM) begin
            strobe_led <= 1;
            alarm_tone <= 1;
        end else begin
            strobe_led <= 0;
            alarm_tone <= 0;
        end
    end

endmodule