`timescale 1ns / 1ps
module y_reg(
    input clk, rst, en,
    input [3:0] D,
    output reg [3:0] Q
    //output reg zFlag
    );
always @(posedge clk, posedge rst) begin
    if (rst)     Q <= 0;  // reset (load 0)
    else if (en) Q <= D;  // Set
    else         Q <= Q;  // Hold
end

// always @(Q) begin
//     if (Q == 0) zFlag = 1;
//     else        zFlag = 0; 
// end
endmodule