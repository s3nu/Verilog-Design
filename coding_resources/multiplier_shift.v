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

module shifter(
	input wire [3:0] in,	// 4-bit num to shift
	input wire [1:0] shift,	// 0-3 shift val
	output wire [7:0] out 	// only 7-bit as 8th is carry out
    );
assign out = {4'b0000, in} << shift; 
endmodule