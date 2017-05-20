`timescale 1ns / 1ps
module comparator(
	input [3:0] A, B,
	output reg out);
always @(*) begin
	if (A<B) out = 1;
	else     out = 0;
end
endmodule