`timescale 1ns / 1ps

module traffic_controller_fsm(
    input clk,               // 1Hz clock from divider
    input rst_n,             // Active-low reset
    input pedestrian_btn,    // Debounced pedestrian button
    output reg [2:0] vehicle_light,  // R/Y/G (MSB to LSB)
    output reg [1:0] pedestrian_light, // R/G
    output [3:0] countdown_value    // For 7-segment display
);

// State parameters
parameter [2:0] 
    VEHICLE_GREEN  = 3'b001,
    VEHICLE_YELLOW = 3'b010,
    VEHICLE_RED    = 3'b100;

parameter [1:0]
    PEDESTRIAN_RED   = 2'b10,
    PEDESTRIAN_GREEN = 2'b01;

// Timing parameters (in seconds)
parameter VEHICLE_GREEN_TIME = 15;
parameter VEHICLE_YELLOW_TIME = 3;
parameter PEDESTRIAN_GREEN_TIME = 10;

reg [2:0] current_state, next_state;
reg [5:0] timer;
reg pedestrian_request;

assign countdown_value = (current_state == VEHICLE_RED) ? 
                        ((timer < PEDESTRIAN_GREEN_TIME) ? (PEDESTRIAN_GREEN_TIME - timer) : 0) : 0;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        current_state <= VEHICLE_GREEN;
        timer <= 0;
        pedestrian_request <= 0;
    end
    else begin
        current_state <= next_state;
        
        // Timer logic
        if(current_state != next_state)
            timer <= 0;
        else
            timer <= timer + 1;
            
        // Pedestrian request latching
        if(pedestrian_btn && !pedestrian_request)
            pedestrian_request <= 1'b1;
        else if(current_state == VEHICLE_RED)
            pedestrian_request <= 1'b0;
    end
end

// Next state logic
always @(*) begin
    case(current_state)
        VEHICLE_GREEN: begin
            if((timer == VEHICLE_GREEN_TIME-1) || pedestrian_request)
                next_state = VEHICLE_YELLOW;
            else
                next_state = VEHICLE_GREEN;
        end
        
        VEHICLE_YELLOW: begin
            if(timer == VEHICLE_YELLOW_TIME-1)
                next_state = VEHICLE_RED;
            else
                next_state = VEHICLE_YELLOW;
        end
        
        VEHICLE_RED: begin
            if(timer == PEDESTRIAN_GREEN_TIME-1)
                next_state = VEHICLE_GREEN;
            else
                next_state = VEHICLE_RED;
        end
        
        default: next_state = VEHICLE_GREEN;
    endcase
end

// Output logic
always @(*) begin
    case(current_state)
        VEHICLE_GREEN: begin
            vehicle_light = 3'b001;
            pedestrian_light = PEDESTRIAN_RED;
        end
        
        VEHICLE_YELLOW: begin
            vehicle_light = 3'b010;
            pedestrian_light = PEDESTRIAN_RED;
        end
        
        VEHICLE_RED: begin
            vehicle_light = 3'b100;
            pedestrian_light = PEDESTRIAN_GREEN;
        end
        
        default: begin
            vehicle_light = 3'b001;
            pedestrian_light = PEDESTRIAN_RED;
        end
    endcase
end

endmodule
