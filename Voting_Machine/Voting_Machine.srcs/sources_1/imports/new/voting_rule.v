`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2017 02:50:41 AM
// Design Name: 
// Module Name: voting_rule
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
module voting_rule(w,n,o,a,b,c,d);
	input w,n,o;
	output a,b,c,d;
	assign a = w&n&o;
	assign b = ~w&~n&o | ~w&n&o | w&~n&o | w&n&~o;
	assign c = ~w&n&~o | ~w&n&o | w&~n&~o | w&~n&o;
	assign d = ~w&n&~o | ~w&n&o | w&n&~o | w&n&o;
endmodule // end voting_rule