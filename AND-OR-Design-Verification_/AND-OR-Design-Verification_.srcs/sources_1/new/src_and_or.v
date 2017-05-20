`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team Standy
// Engineer: Anahit Sarao
// 
// Create Date: 04/02/2017 07:15:21 PM
// Design Name: And/Or Design
// Module Name: src_and_or
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
module and_gate(input [1:0] in, output [1:0] out);
	assign out = in[1] & in[0];
endmodule

module or_gate(input [1:0] in, output [1:0] out);
	assign out = in[1]|& in[0];
endmodule

module src_and_or(input [3:0] top_level_in, output top_level_out);
	wire [1:0] signal;
	and_gate U1(.in(top_level_in[3:2]), .out(signal[1]));
	and_gate U2(.in(top_level_in[1:0]), .out(signal[0]));
	or_gate U3 (.in(signal), .out(top_level_out));
endmodule