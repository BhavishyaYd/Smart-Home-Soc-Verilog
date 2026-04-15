module tb_thermal;

    reg clk, rst_n;
    reg [7:0] temp_in, threshold, hyst_val;
    wire cooling_on, overheat_irq;

    thermal_block uut (
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp_in),
        .threshold(threshold),
        .hyst_val(hyst_val),
        .cooling_on(cooling_on),
        .overheat_irq(overheat_irq)
    );

    // Clock
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        threshold = 8'd30;
        hyst_val  = 8'd3;
        temp_in   = 8'd25;

        #20 rst_n = 1;

        // Below threshold
        #50 temp_in = 8'd28;

        // Above threshold → ON
        #50 temp_in = 8'd35;

        // Inside hysteresis band → still ON
        #50 temp_in = 8'd28;

        // Below band → OFF
        #50 temp_in = 8'd26;

        #100 $finish;
    end

endmodule