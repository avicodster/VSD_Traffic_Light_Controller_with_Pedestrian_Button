`timescale 1ns / 1ps

module top(
    input clk,               // 12MHz clock
    input rst_n,             // Active-low reset
    input pedestrian_btn,    // Pedestrian request
    output [2:0] vehicle_light,  // R/Y/G (MSB to LSB)
    output [1:0] pedestrian_light, // R/G
    output [6:0] seg7        // 7-segment display
);

wire clk_1Hz;
wire pedestrian_btn_debounced;
wire [3:0] countdown_value;

// Instantiate clock divider
clock_divider clk_div(
    .clk(clk),
    .clk_1Hz(clk_1Hz)
);

// Instantiate button debouncer
debounce_filter debouncer(
    .clk(clk_1Hz),
    .btn_in(pedestrian_btn),
    .btn_out(pedestrian_btn_debounced)
);

// Instantiate traffic controller FSM
traffic_controller_fsm controller(
    .clk(clk_1Hz),
    .rst_n(rst_n),
    .pedestrian_btn(pedestrian_btn_debounced),
    .vehicle_light(vehicle_light),
    .pedestrian_light(pedestrian_light),
    .countdown_value(countdown_value)
);

// Instantiate 7-segment display
seven_segment display(
    .value(countdown_value),
    .segments(seg7)
);

endmodule
