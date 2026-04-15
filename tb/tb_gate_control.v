`timescale 1ns/1ps

module tb_gate_control;

    reg clk;
    reg rst_n;
    reg doorbell_in;

    wire pwm_out;
    wire gate_open_led;

    // Instantiate DUT
    gate_control uut (
        .clk(clk),
        .rst_n(rst_n),
        .doorbell_in(doorbell_in),
        .pwm_out(pwm_out),
        .gate_open_led(gate_open_led)
    );

    // Clock (50 MHz)
    always #10 clk = ~clk;

    initial begin
        $dumpfile("gate_control.vcd");
        $dumpvars(0, tb_gate_control);
    end

    initial begin
        // Init
        clk = 0;
        rst_n = 0;
        doorbell_in = 0;

        // Reset release
        #20 rst_n = 1;

        // -----------------------
        // TEST 1: Trigger gate open
        // -----------------------
        #50 doorbell_in = 1;
        #20 doorbell_in = 0;

        // Wait (shortened simulation)
        #2000;

        // Trigger again
        #100 doorbell_in = 1;
        #20  doorbell_in = 0;

        #2000;

        $finish;
    end

endmodule