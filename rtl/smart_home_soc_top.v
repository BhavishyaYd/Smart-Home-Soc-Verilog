`timescale 1ns/1ps

module smart_home_soc_top (

    input  wire        clk_50mhz,
    input  wire        rst_btn,

    input  wire [7:0]  temp_sensor,
    input  wire [7:0]  light_sensor,

    input  wire        arm_btn,
    input  wire        disarm_btn,
    input  wire        motion_in,
    input  wire        doorbell_in,

    input  wire        mode_wr_en,
    input  wire [1:0]  mode_sel,

    output wire        cooling_out,
    output wire        overheat_buzz,
    output wire        led_light_out,
    output wire        strobe_led_out,
    output wire        alarm_buzz_out,
    output wire        servo_pwm_out,
    output wire        gate_led_out,
    output wire [1:0]  mode_leds
);

    // Internal wires
    wire [1:0] current_mode;

    // Constants
    wire [7:0] temp_threshold = 8'd30;
    wire [7:0] hyst_val       = 8'd3;
    wire [7:0] lux_threshold  = 8'd50;

    // ==========================
    // GOVERNANCE REGISTER
    // ==========================
    governance_reg u_gov (
        .clk(clk_50mhz),
        .rst_n(rst_btn),
        .wr_en(mode_wr_en),
        .mode_in(mode_sel),
        .mode_out(current_mode),
        .comfort_mode(),     // unused
        .lockdown_mode()
    );

    assign mode_leds = current_mode;

    // ==========================
    // THERMAL BLOCK
    // ==========================
    thermal_block u_thermal (
        .clk(clk_50mhz),
        .rst_n(rst_btn),
        .temp_in(temp_sensor),
        .threshold(temp_threshold),
        .hyst_val(hyst_val),
        .cooling_on(cooling_out),
        .overheat_irq(overheat_buzz)
    );

    // ==========================
    // LUMINANCE BLOCK
    // ==========================
    luminance_block u_lum (
        .clk(clk_50mhz),
        .rst_n(rst_btn),
        .light_in(light_sensor),
        .lux_threshold(lux_threshold),
        .led_on(led_light_out)
    );

    // ==========================
    // SECURITY FSM
    // ==========================
    security_fsm u_sec (
        .clk(clk_50mhz),
        .rst_n(rst_btn),
        .arm_btn(arm_btn),
        .disarm_btn(disarm_btn),
        .motion_in(motion_in),
        .strobe_led(strobe_led_out),
        .alarm_tone(alarm_buzz_out)
    );

    // ==========================
    // GATE CONTROL
    // ==========================
    gate_control u_gate (
        .clk(clk_50mhz),
        .rst_n(rst_btn),
        .doorbell_in(doorbell_in),
        .pwm_out(servo_pwm_out),
        .gate_open_led(gate_led_out)
    );

endmodule