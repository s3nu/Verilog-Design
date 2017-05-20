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

`timescale 1ns / 1ps
module partial_prod(
	input [3:0] a, b,	
	output wire [3:0] pp0, pp1, pp2, pp3
    );
andMod and0(.x(pp0[0]), .a(a[0]), .b(b[0]));
andMod and1(.x(pp1[0]), .a(a[0]), .b(b[1]));
andMod and2(.x(pp2[0]), .a(a[0]), .b(b[2]));
andMod and3(.x(pp3[0]), .a(a[0]), .b(b[3]));

andMod and4(.x(pp0[1]), .a(a[1]), .b(b[0]));
andMod and5(.x(pp1[1]), .a(a[1]), .b(b[1]));
andMod and6(.x(pp2[1]), .a(a[1]), .b(b[2]));
andMod and7(.x(pp3[1]), .a(a[1]), .b(b[3]));

andMod and8(.x(pp0[2]), .a(a[2]), .b(b[0]));
andMod and9(.x(pp1[2]), .a(a[2]), .b(b[1]));
andMod andA(.x(pp2[2]), .a(a[2]), .b(b[2]));
andMod andB(.x(pp3[2]), .a(a[2]), .b(b[3]));

andMod andC(.x(pp0[3]), .a(a[3]), .b(b[0]));
andMod andD(.x(pp1[3]), .a(a[3]), .b(b[1]));
andMod andE(.x(pp2[3]), .a(a[3]), .b(b[2]));
andMod andF(.x(pp3[3]), .a(a[3]), .b(b[3]));
endmodule