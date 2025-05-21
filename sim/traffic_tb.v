`timescale 1ns / 1ps

module TrafficController_tb;

// Inputs
reg clk_12MHz;
reg rst_n;
reg pedestrian_btn;

// Outputs
wire [2:0] vehicle_light;
wire [1:0] pedestrian_light;
wire [6:0] seg7;

// Instantiate Unit Under Test (UUT)
top uut (
    .clk(clk_12MHz),
    .rst_n(rst_n),
    .pedestrian_btn(pedestrian_btn),
    .vehicle_light(vehicle_light),
    .pedestrian_light(pedestrian_light),
    .seg7(seg7)
);

// Generate 12MHz clock
always #41.67 clk_12MHz = ~clk_12MHz;  // 12MHz clock period = 83.34ns

// Test scenario
initial begin
    // Initialize inputs
    clk_12MHz = 0;
    rst_n = 0;
    pedestrian_btn = 0;
    
    // Power-on reset
    #100 rst_n = 1;
    #1000000;  // Allow 1ms for initial clock division
    
    // Test Case 1: Normal operation cycle
    $display("\n[TEST 1] Normal Operation Cycle");
    #12000000;  // Observe 12s of operation (1Hz equivalent)
    
    // Test Case 2: Single pedestrian request
    $display("\n[TEST 2] Single Pedestrian Request");
    pedestrian_btn = 1;
    #50000000;  // Hold button for 50ms (simulate press)
    pedestrian_btn = 0;
    #30000000;  // Observe full pedestrian phase
    
    // Test Case 3: Multiple button presses
    $display("\n[TEST 3] Multiple Button Presses");
    repeat(3) begin
        pedestrian_btn = 1;
        #1000000;  // 1ms pulses
        pedestrian_btn = 0;
        #1000000;
    end
    #50000000;  // Observe behavior
    
    // Test Case 4: Reset during operation
    $display("\n[TEST 4] Reset During Operation");
    rst_n = 0;
    #100000;
    rst_n = 1;
    #10000000;
    
    $display("\nAll tests completed");
    $finish;
end

// Real-time monitoring
always @(posedge uut.clk_1Hz) begin
    $display("[%0t] State: VEH=%b PED=%b SEG=%b",
        $time, vehicle_light, pedestrian_light, seg7);
end

// Automatic verification
reg [2:0] prev_vehicle;
always @(posedge uut.controller.clk_1Hz) begin
    prev_vehicle <= uut.controller.current_state;
    
    // Verify state transitions
    if(prev_vehicle == uut.controller.VEHICLE_GREEN &&
       uut.controller.current_state == uut.controller.VEHICLE_YELLOW) 
    begin
        if(uut.controller.timer != 2)  // Modified parameter check
            $error("Early transition from GREEN!");
    end
end

endmodule
