`timescale 1ns / 1ps
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