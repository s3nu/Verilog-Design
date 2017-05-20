`timescale 1ns / 1ps
module cla_gen(	input wire [3:0] A, B,
				input wire c_in,
				output wire c_out, 
				output wire [3:0] Sum);

wire [3:0] P, G;
wire [4:0] C;

half_adder ha0(.A(A[0]), .B(B[0]), .P(P[0]), .G(G[0]));
half_adder ha1(.A(A[1]), .B(B[1]), .P(P[1]), .G(G[1]));
half_adder ha2(.A(A[2]), .B(B[2]), .P(P[2]), .G(G[2]));
half_adder ha3(.A(A[3]), .B(B[3]), .P(P[3]), .G(G[3]));

c_gen cgen0(.P(P), .G(G), .c_in(c_in), .C(C));

xor xor0(Sum[0], c_in, P[0]);
xor xor1(Sum[1], C[1], P[1]);
xor xor2(Sum[2], C[2], P[2]);
xor xor3(Sum[3], C[3], P[3]);

assign c_out = C[4];
endmodule
