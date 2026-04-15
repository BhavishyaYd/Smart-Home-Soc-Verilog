module tb_luminance;

    reg clk, rst_n;
    reg [7:0] light_in, lux_threshold;
    wire led_on;

    luminance_block uut (
        .clk(clk),
        .rst_n(rst_n),
        .light_in(light_in),
        .lux_threshold(lux_threshold),
        .led_on(led_on)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        lux_threshold = 8'd50;

        #20 rst_n = 1;

        // Bright condition
        light_in = 8'd200;
        #200;

        // Dark condition (after LPF delay)
        light_in = 8'd20;
        #400;

        #100 $finish;
    end

endmodule