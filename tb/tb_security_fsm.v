`timescale 1ns/1ps

module tb_security_fsm;

    // Inputs
    reg clk;
    reg rst_n;
    reg arm_btn;
    reg disarm_btn;
    reg motion_in;

    // Outputs
    wire strobe_led;
    wire alarm_tone;

    // Instantiate DUT
    security_fsm uut (
        .clk(clk),
        .rst_n(rst_n),
        .arm_btn(arm_btn),
        .disarm_btn(disarm_btn),
        .motion_in(motion_in),
        .strobe_led(strobe_led),
        .alarm_tone(alarm_tone)
    );

    // Clock generation (50 MHz → 20ns period)
    always #10 clk = ~clk;

    // VCD dump (for GTKWave)
    initial begin
        $dumpfile("security_fsm.vcd");
        $dumpvars(0, tb_security_fsm);
    end

    // Stimulus
    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        arm_btn = 0;
        disarm_btn = 0;
        motion_in = 0;

        // Reset release
        #20 rst_n = 1;

        // ----------------------------
        // TEST 1: Arm system
        // ----------------------------
        #40 arm_btn = 1;
        #20 arm_btn = 0;

        // ----------------------------
        // TEST 2: Motion detected → ALARM
        // ----------------------------
        #100 motion_in = 1;
        #20  motion_in = 0;

        // Let alarm run
        #200;

        // ----------------------------
        // TEST 3: Disarm system
        // ----------------------------
        #40 disarm_btn = 1;
        #20 disarm_btn = 0;

        // ----------------------------
        // TEST 4: Re-arm and trigger again
        // ----------------------------
        #100 arm_btn = 1;
        #20  arm_btn = 0;

        #100 motion_in = 1;
        #20  motion_in = 0;

        #200;

        // Final disarm
        #40 disarm_btn = 1;
        #20 disarm_btn = 0;

        #200;

        $finish;
    end

endmodule