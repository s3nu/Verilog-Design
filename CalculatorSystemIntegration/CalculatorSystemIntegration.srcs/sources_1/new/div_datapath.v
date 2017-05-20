`timescale 1ns / 1ps

module dp(
	input clk, rst, 
	input Yen, Xen, Ren,        // Register/counter enables/loads
	input X_sL, Xsh_b, RsL, RsR,// Shift reg ctrl bits
	input s1, s2, s3,           // mux selectors
	input load_cnt, ud, Cen,    // Up/Down counter ctrl
	input [3:0] X_in, Y_in,     // Divident, Divisor
	output [3:0] R, Q,          
	output R_lt_Y, cnt_out,
    output errFlag);

wire [3:0] X_out, Y_out;
wire [4:0] subOut, R_in, R_out;
wire x3;

mux2   #(5) m0(.A(subOut), .B(5'b00000), .sel(s1), .out(R_in));
mux2   #(4) m1(.A(R_out[3:0]), .B(4'b0000), .sel(s2), .out(R));
mux2   #(4) m2(.A(X_out), .B(4'b0000), .sel(s3), .out(Q));
y_reg       y0(.clk(clk), .rst(rst), .en(Yen), .D(Y_in), .Q(Y_out));
x_reg       x0(.clk(clk), .rst(rst), .LD(Xen), .sL(X_sL), 
	           .sh_b(Xsh_b), .D(X_in), .Q(X_out), .msb(x3));
r_reg       r0(.clk(clk), .rst(rst), .LD(Ren), .sL(RsL),
			   .sR(RsR), .sh_b(x3), .D(R_in), .Q(R_out));
comparator  c0(.A(R_out[3:0]), .B(Y_out), .out(R_lt_Y));
comparator  c1(.A(Y_in), .B(4'b0001), .out(errFlag));
sub         s0(.A(R_out), .B({1'b0,Y_out}), .out(subOut));
ud_counter  u0(.clk(clk), .rst(rst), .ce(Cen),
			     .ld(load_cnt), .ud(ud), .D(3'b100), .zFlag(cnt_out));
endmodule