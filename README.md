# Project Title
 VSD Traffic Light Controller with Pedestrian Button
# Day1
 ## Theme
The theme chosen is **FSM with Control Logic System**.

This theme is significant for modern urban infrastructure, as it addresses real-world challenges in traffic flow optimization and pedestrian safety using advanced digital hardware and programmable logic.
## Brief Introduction
A Traffic Light Controller with Pedestrian Button is an intelligent traffic management system designed to control the flow of vehicles and pedestrians at road intersections. Unlike basic traffic lights, this system includes a push-button for pedestrians. When pressed, the button signals the controller to safely halt vehicle traffic and allow pedestrians to cross. This ensures both efficient vehicle movement and enhanced pedestrian safety, making it a crucial feature in urban and suburban traffic systems.
## Expected Output
### 1.Normal Operation
--> The traffic lights cycle through green, yellow, and red phases for vehicles.

--> The pedestrian signal remains in "Don’t Walk" (red).
### 2.Pedestrain Request
--> When the pedestrian button is pressed, the controller detects the request.
### 3.Crossing Phase
--> Vehicles are stopped (red light).
### 4.Safety and Efficiency
--> Making sure only on crossing is allowed per button press.
# Block Diagram
![image](https://github.com/user-attachments/assets/85a2ddf5-cd28-429d-8bc1-327cbcee8783)
# FSM transition Diagram
![FSM_DISAGRAM](https://github.com/user-attachments/assets/3a0ea6b0-9dab-4c4e-a471-bb6e1cc80afb)

# Day 2 - RTL Skeleton
- Created traffic_controller_fsm module with defined I/O:

  Inputs: clk, rst_n, pedestrian_btn

  Outputs: vehicle_light, pedestrian_light, seg7

  clk: System clock (12MHz on VSDSquadron FPGA)

  rst_n: Active-low reset signal

  pedestrian_btn: Input from pedestrian crossing button

  vehicle_light[2:0]: Controls R/Y/G signals for vehicles

  pedestrian_light[1:0]: Controls R/G signals for pedestrians

  seg7[6:0]: 7-segment display output for countdown timer

- Declared FSM states and control skeleton (VEHICLE_GREEN → VEHICLE_YELLOW → VEHICLE_RED → VEHICLE_GREEN)

- Set up testbench in TrafficController_tb.v

- Committed updates in /src/ with appropriate modular structure:

- Created top.v for board pin assignment and module integration

- Created traffic_controller_fsm.v for state machine logic

- Created clock_divider.v for 12MHz to 1Hz conversion

- Created debounce_filter.v for button debouncing

- Created seven_segment.v for display driver

- Designed FSM transition diagram showing state flows and conditions
# Why This FSM-Based Structure?
- Natural Fit for Sequential Control: Traffic light systems inherently operate in a sequence of well-defined states (e.g., Green, Yellow, Red for vehicles; Walk/Don’t Walk for pedestrians).
- Reliability and Safety: Since only one state is active at a time, FSMs reduce the risk of conflicting outputs or undefined behavior. For example, it prevents both vehicle and pedestrian green lights from being on simultaneously, enhancing safety—a critical requirement for traffic management systems.

