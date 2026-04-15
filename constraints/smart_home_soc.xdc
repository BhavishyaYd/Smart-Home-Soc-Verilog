## ============================================================
## Constraints: smart_home_soc.xdc
## Target Board: Basys3 (Artix-7 XC7A35T)
## ============================================================

## === CLOCK ===
set_property PACKAGE_PIN W5      [get_ports clk_50mhz]
set_property IOSTANDARD  LVCMOS33 [get_ports clk_50mhz]
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports clk_50mhz]

## === RESET (Active-Low, Center Button) ===
set_property PACKAGE_PIN U18     [get_ports rst_btn]
set_property IOSTANDARD  LVCMOS33 [get_ports rst_btn]

## === PUSH BUTTONS ===
# ARM button (BTNU)
set_property PACKAGE_PIN T18     [get_ports arm_btn]
set_property IOSTANDARD  LVCMOS33 [get_ports arm_btn]

# DISARM button (BTNL)
set_property PACKAGE_PIN W19     [get_ports disarm_btn]
set_property IOSTANDARD  LVCMOS33 [get_ports disarm_btn]

# DOORBELL button (BTNR)
set_property PACKAGE_PIN T17     [get_ports doorbell_in]
set_property IOSTANDARD  LVCMOS33 [get_ports doorbell_in]

## === SWITCHES (SW[7:0] = temp_sensor[7:0]) ===
set_property PACKAGE_PIN V17     [get_ports {temp_sensor[0]}]
set_property PACKAGE_PIN V16     [get_ports {temp_sensor[1]}]
set_property PACKAGE_PIN W16     [get_ports {temp_sensor[2]}]
set_property PACKAGE_PIN W17     [get_ports {temp_sensor[3]}]
set_property PACKAGE_PIN W15     [get_ports {temp_sensor[4]}]
set_property PACKAGE_PIN V15     [get_ports {temp_sensor[5]}]
set_property PACKAGE_PIN W14     [get_ports {temp_sensor[6]}]
set_property PACKAGE_PIN W13     [get_ports {temp_sensor[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {temp_sensor[*]}]

## === SWITCHES (SW[15:8] = light_sensor[7:0]) ===
set_property PACKAGE_PIN V2      [get_ports {light_sensor[0]}]
set_property PACKAGE_PIN T3      [get_ports {light_sensor[1]}]
set_property PACKAGE_PIN T2      [get_ports {light_sensor[2]}]
set_property PACKAGE_PIN R3      [get_ports {light_sensor[3]}]
set_property PACKAGE_PIN W2      [get_ports {light_sensor[4]}]
set_property PACKAGE_PIN U1      [get_ports {light_sensor[5]}]
set_property PACKAGE_PIN T1      [get_ports {light_sensor[6]}]
set_property PACKAGE_PIN R2      [get_ports {light_sensor[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {light_sensor[*]}]

## === MODE CONTROL ===
set_property PACKAGE_PIN V2      [get_ports mode_wr_en]
set_property IOSTANDARD  LVCMOS33 [get_ports mode_wr_en]
set_property PACKAGE_PIN T3      [get_ports {mode_sel[0]}]
set_property PACKAGE_PIN T2      [get_ports {mode_sel[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {mode_sel[*]}]

## === MOTION INPUT (PMOD JA[0]) ===
set_property PACKAGE_PIN J1      [get_ports motion_in]
set_property IOSTANDARD  LVCMOS33 [get_ports motion_in]

## === OUTPUTS: LEDs ===
# LD0 = cooling_out
set_property PACKAGE_PIN U16     [get_ports cooling_out]
set_property IOSTANDARD  LVCMOS33 [get_ports cooling_out]
# LD1 = overheat_buzz
set_property PACKAGE_PIN E19     [get_ports overheat_buzz]
set_property IOSTANDARD  LVCMOS33 [get_ports overheat_buzz]
# LD2 = led_light_out
set_property PACKAGE_PIN U19     [get_ports led_light_out]
set_property IOSTANDARD  LVCMOS33 [get_ports led_light_out]
# LD3 = strobe_led_out
set_property PACKAGE_PIN V19     [get_ports strobe_led_out]
set_property IOSTANDARD  LVCMOS33 [get_ports strobe_led_out]
# LD4 = alarm_buzz_out
set_property PACKAGE_PIN W18     [get_ports alarm_buzz_out]
set_property IOSTANDARD  LVCMOS33 [get_ports alarm_buzz_out]
# LD5 = gate_led_out
set_property PACKAGE_PIN U15     [get_ports gate_led_out]
set_property IOSTANDARD  LVCMOS33 [get_ports gate_led_out]
# LD6-LD7 = mode_leds
set_property PACKAGE_PIN U14     [get_ports {mode_leds[0]}]
set_property PACKAGE_PIN V14     [get_ports {mode_leds[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {mode_leds[*]}]

## === SERVO PWM OUTPUT (PMOD JB[0]) ===
set_property PACKAGE_PIN A14     [get_ports servo_pwm_out]
set_property IOSTANDARD  LVCMOS33 [get_ports servo_pwm_out]
