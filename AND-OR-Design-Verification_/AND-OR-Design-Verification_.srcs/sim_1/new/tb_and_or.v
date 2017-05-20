`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2017 07:29:02 PM
// Design Name: And/Or TestBench
// Module Name: tb_and_or
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


module tb_and_or;
	reg[3:0] tb_top_input;
	wire tb_top_out;
	src_and_or DUT(.top_level_in(tb_top_input), .top_level_out(tb_top_out));
	initial
	begin
		tb_top_input = 0; 
		#5 tb_top_input = 4'b0000; #5 tb_top_input = 4'b0001;
		#5 tb_top_input = 4'b0010; #5 tb_top_input = 4'b0011;
		#5 tb_top_input = 4'b0100; #5 tb_top_input = 4'b0101;
		#5 tb_top_input = 4'b0110; #5 tb_top_input = 4'b0111;
		#5 tb_top_input = 4'b1000; #5 tb_top_input = 4'b1001;
		#5 tb_top_input = 4'b1010; #5 tb_top_input = 4'b1011;
		#5 tb_top_input = 4'b1100; #5 tb_top_input = 4'b1101;
		#5 tb_top_input = 4'b1110; #5 tb_top_input = 4'b1111;
		#100 $finish; 
	end
endmodule
