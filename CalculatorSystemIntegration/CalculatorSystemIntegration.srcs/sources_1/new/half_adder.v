`timescale 1ns / 1ps
module half_adder(	input A, B, output P, G);
assign G = A & B;
assign P = A ^ B;
endmodule