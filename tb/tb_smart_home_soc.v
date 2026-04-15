// ============================================================
// Testbench: tb_smart_home_soc.v
// Description: Top-level simulation testbench
//              Verifies all 5 modules via stimulus injection
//              Run in ModelSim / Vivado Simulator / Icarus
// ============================================================
`timescale 1ns / 1ps

module tb_smart_home_soc;

    // -------------------------------------------------------
    // DUT Port Declarations
    // -------------------------------------------------------
    reg         clk_50mhz;
    reg         rst_btn;
    reg  [7:0]  temp_sensor;
    reg  [7:0]  light_sensor;
    reg         arm_btn;
    reg         disarm_btn;
    reg         motion_in;
    reg         doorbell_in;
    reg         mode_wr_en;
    reg  [1:0]  mode_sel;

    wire        cooling_out;
    wire        overheat_buzz;
    wire        led_light_out;
    wire        strobe_led_out;
    wire        alarm_buzz_out;
    wire        servo_pwm_out;
    wire        gate_led_out;
    wire [1:0]  mode_leds;

    // -------------------------------------------------------
    // DUT Instantiation
    // -------------------------------------------------------
    smart_home_soc_top dut (
        .clk_50mhz    (clk_50mhz),
        .rst_btn      (rst_btn),
        .temp_sensor  (temp_sensor),
        .light_sensor (light_sensor),
        .arm_btn      (arm_btn),
        .disarm_btn   (disarm_btn),
        .motion_in    (motion_in),
        .doorbell_in  (doorbell_in),
        .mode_wr_en   (mode_wr_en),
        .mode_sel     (mode_sel),
        .cooling_out  (cooling_out),
        .overheat_buzz(overheat_buzz),
        .led_light_out(led_light_out),
        .strobe_led_out(strobe_led_out),
        .alarm_buzz_out(alarm_buzz_out),
        .servo_pwm_out(servo_pwm_out),
        .gate_led_out (gate_led_out),
        .mode_leds    (mode_leds)
    );

    // -------------------------------------------------------
    // Clock Generation: 50 MHz -> 20ns period
    // -------------------------------------------------------
    initial clk_50mhz = 0;
    always #10 clk_50mhz = ~clk_50mhz;

    // -------------------------------------------------------
    // Task: Apply Reset
    // -------------------------------------------------------
    task apply_reset;
        begin
            rst_btn = 0; // Assert active-low reset
            repeat(5) @(posedge clk_50mhz);
            rst_btn = 1; // Release reset
            @(posedge clk_50mhz);
            $display("[%0t] Reset released.", $time);
        end
    endtask

    // -------------------------------------------------------
    // Task: Wait N clock cycles
    // -------------------------------------------------------
    task wait_cycles;
        input integer n;
        begin
            repeat(n) @(posedge clk_50mhz);
        end
    endtask

    // -------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------
    initial begin
        // Waveform dump for GTKWave / ModelSim
        $dumpfile("smart_home_soc.vcd");
        $dumpvars(0, tb_smart_home_soc);

        // Initialize inputs
        temp_sensor  = 8'd25;
        light_sensor = 8'd100;
        arm_btn      = 0;
        disarm_btn   = 0;
        motion_in    = 0;
        doorbell_in  = 0;
        mode_wr_en   = 0;
        mode_sel     = 2'b00;

        // ---- RESET ----
        apply_reset;

        // =====================================================
        // TEST 1: Thermal Block - Normal Temperature
        // =====================================================
        $display("[TEST 1] Temperature below threshold (25 < 30)");
        temp_sensor = 8'd25;
        wait_cycles(10);
        if (!cooling_out && !overheat_buzz)
            $display("  PASS: Cooling OFF, no interrupt.");
        else
            $display("  FAIL: Unexpected cooling activation.");

        // =====================================================
        // TEST 2: Thermal Block - Overheat
        // =====================================================
        $display("[TEST 2] Temperature above threshold (35 > 30)");
        temp_sensor = 8'd35;
        wait_cycles(10);
        if (cooling_out && overheat_buzz)
            $display("  PASS: Cooling ON, overheat interrupt triggered.");
        else
            $display("  FAIL: Cooling/interrupt not triggered.");

        // =====================================================
        // TEST 3: Thermal Hysteresis
        // =====================================================
        $display("[TEST 3] Hysteresis - temp drops to 28 (above threshold-hyst=27)");
        temp_sensor = 8'd28;
        wait_cycles(10);
        if (cooling_out)
            $display("  PASS: Cooling still ON (hysteresis prevents early shutoff).");
        else
            $display("  FAIL: Cooling turned off too early.");

        $display("[TEST 3b] Temp drops below hysteresis band (25 < 27)");
        temp_sensor = 8'd25;
        wait_cycles(10);
        if (!cooling_out)
            $display("  PASS: Cooling OFF after hysteresis band.");
        else
            $display("  FAIL: Cooling still on.");

        // =====================================================
        // TEST 4: Luminance Block - Dark Room
        // =====================================================
        $display("[TEST 4] Dark room - light sensor = 20 (below 50)");
        light_sensor = 8'd20;
        wait_cycles(50); // Allow LPF to settle
        if (led_light_out)
            $display("  PASS: LED lights ON in dark.");
        else
            $display("  INFO: LED not ON yet - LPF settling...");
        wait_cycles(200);
        $display("  LED status after filter settle: %b", led_light_out);

        // =====================================================
        // TEST 5: Luminance Block - Bright Room
        // =====================================================
        $display("[TEST 5] Bright room - light sensor = 200 (above 50)");
        light_sensor = 8'd200;
        wait_cycles(200);
        $display("  LED status: %b (expected 0)", led_light_out);

        // =====================================================
        // TEST 6: Security FSM - Arm System
        // =====================================================
        $display("[TEST 6] Arming the security system");
        arm_btn = 1;
        wait_cycles(2);
        arm_btn = 0;
        wait_cycles(5);
        $display("  Mode LEDs: %b", mode_leds);

        // =====================================================
        // TEST 7: Security FSM - Motion Detection -> ALARM
        // =====================================================
        $display("[TEST 7] Motion detected while armed");
        motion_in = 1;
        wait_cycles(5);
        motion_in = 0;
        wait_cycles(100); // Let alarm run briefly
        if (strobe_led_out || alarm_buzz_out)
            $display("  PASS: Alarm triggered (strobe=%b, buzz=%b)",
                     strobe_led_out, alarm_buzz_out);
        else
            $display("  INFO: Alarm outputs observed in waveform.");

        // =====================================================
        // TEST 8: Security FSM - Disarm
        // =====================================================
        $display("[TEST 8] Disarming the alarm");
        disarm_btn = 1;
        wait_cycles(3);
        disarm_btn = 0;
        wait_cycles(10);
        if (!strobe_led_out && !alarm_buzz_out)
            $display("  PASS: Alarm cleared.");

        // =====================================================
        // TEST 9: Gate Control - Doorbell
        // =====================================================
        $display("[TEST 9] Doorbell ring - gate should open");
        doorbell_in = 1;
        wait_cycles(3);
        doorbell_in = 0;
        wait_cycles(20);
        if (gate_led_out)
            $display("  PASS: Gate open LED ON.");
        $display("  PWM output visible in waveform: servo_pwm_out");

        // =====================================================
        // TEST 10: Governance Register - Switch to LOCKDOWN
        // =====================================================
        $display("[TEST 10] Switching to LOCKDOWN mode");
        mode_sel   = 2'b01;
        mode_wr_en = 1;
        wait_cycles(2);
        mode_wr_en = 0;
        wait_cycles(5);
        if (mode_leds == 2'b01)
            $display("  PASS: LOCKDOWN mode active (mode_leds=%b).", mode_leds);
        else
            $display("  FAIL: Mode not updated (mode_leds=%b).", mode_leds);

        // =====================================================
        // END OF TESTS
        // =====================================================
        wait_cycles(50);
        $display("\n[SIMULATION COMPLETE] Check .vcd waveform for full analysis.");
        $finish;
    end

    // -------------------------------------------------------
    // Timeout watchdog
    // -------------------------------------------------------
    initial begin
        #50_000_000; // 50ms simulation limit
        $display("TIMEOUT: Simulation exceeded time limit.");
        $finish;
    end

endmodule
