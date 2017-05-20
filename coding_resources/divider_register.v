`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module r_reg(
	input clk, rst, LD, sL, sR, sh_b,
	input [4:0] D,
	output reg [4:0] Q);

wire [4:0] out;
assign out = Q;
always @(posedge clk, posedge rst) begin
	if (rst)     Q <= 5'b00000;         // rst
	else if (LD) Q <= D;                // Load D_in
	else if (sL) Q <= {out[3:0], sh_b}; // Shift Left w/ x3
	else if (sR) Q <= {1'b0, out[4:1]}; // Shift Right
	else         Q <= out;              // Hold
end
endmodule