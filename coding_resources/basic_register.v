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
module d_reg #(parameter WIDTH = 4)
	(  input wire  clk, 
	   input wire  rst, 
	   input wire  en,
	   input wire  [WIDTH-1:0]d,
	   output reg  [WIDTH-1:0]q);

always @(posedge clk, posedge rst) begin
	if (rst) 		q <= 0;
	else if (en) 	q <= d;
	else 			q <= q;
end
endmodule