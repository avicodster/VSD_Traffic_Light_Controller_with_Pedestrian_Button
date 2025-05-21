`timescale 1ns / 1ps

module debounce_filter(
    input clk,
    input btn_in,
    output reg btn_out
);

reg [1:0] shift_reg;

initial begin
    shift_reg = 2'b00;
    btn_out = 1'b0;
end

always @(posedge clk) begin
    shift_reg <= {shift_reg[0], btn_in};
    if(shift_reg == 2'b11)
        btn_out <= 1'b1;
    else if(shift_reg == 2'b00)
        btn_out <= 1'b0;
end

endmodule
