`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name:
// Module Name: basic_add 
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
module andMod(input a, b, output x);
	assign x = a&b;
endmodule

module basic_add(input c, input p, output reg sum );
	always @(c, p)
	begin
	    sum = p ^ c;
	end
endmodule

module AND(input [3:0] a, input  b, output [3:0] val);
	assign val[0] = a[0] & b;
	assign val[1] = a[1] & b;
	assign val[2] = a[2] & b;
	assign val[3] = a[3] & b;
endmodule


module basic_add(input c, input p, output reg sum );
	always @(c, p)
	begin
	    sum = p ^ c;
	end
endmodule