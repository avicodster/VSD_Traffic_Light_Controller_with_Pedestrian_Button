`timescale 1ns / 1ps

module clock_divider(
    input clk,
    output reg clk_1Hz
);

reg [23:0] counter;

initial begin
    clk_1Hz = 0;
    counter = 0;
end

always @(posedge clk) begin
    if(counter == 12_000_000 - 1) begin
        clk_1Hz <= ~clk_1Hz;
        counter <= 0;
    end
    else
        counter <= counter + 1;
end

endmodule
