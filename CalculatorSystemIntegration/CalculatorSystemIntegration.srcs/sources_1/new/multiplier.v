`timescale 1ns / 1ps

module multiplier(
	input [3:0] aD, bD,
	input clk, rst, inEnable, sEnable, outEnable,
	output [7:0] pQ
	 );
	// Debugging
	//output [3:0] pp0, pp1, pp2, pp3; 	
   

wire [3:0] pp0, pp1, pp2, pp3; 		// 4-bit partial product
wire [7:0] pad0, pad1, pad2, pad3;	// 8-bit padded pp
wire [7:0] sum0, sum1;				// pp padded sums
wire carry0, carry1, carry2;		// CLA carry bits
wire x0, x1, x2;					// unused carry bits
wire [3:0] aD, bD, aQ, bQ;

// Stage registers variables
wire [7:0] sum0_d, sum1_d, final_sum_d;
wire [7:0] sum0_q, sum1_q, product;

	// INPUT REGISTERS
	// Input registers instantiation
	d_reg #(4) aREG4b_multi(
			.clk(clk),
			.rst(rst),
			.en(inEnable),
			.d(aD),
			.q(aQ));
	d_reg #(4) bREG4b_multi(
			.clk(clk),
			.rst(rst),
			.en(inEnable),
			.d(bD),
			.q(bQ));

	// AND module: a*b = a&b (Output of input regs)
	partial_prod p0_multi(
		.a(aQ), .b(bQ),
		.pp0(pp0), .pp1(pp1), .pp2(pp2), .pp3(pp3));

	// Shift/pad the partial products
	shifter s0_multi(.in(pp0), .shift(2'b00), .out(pad0));
	shifter s1_multi(.in(pp1), .shift(2'b01), .out(pad1));
	shifter s2_multi(.in(pp2), .shift(2'b10), .out(pad2));
	shifter s3_multi(.in(pp3), .shift(2'b11), .out(pad3));

	// STAGE REGISTERS
	// Stage register instantiation
	d_reg #(8) s01REG8b_multi(
			.clk(clk),
			.rst(rst),
			.en(sEnable),
			.d(sum0_d),
			.q(sum0_q));
	d_reg #(8) s23REG8b_multi(
			.clk(clk),
			.rst(rst),
			.en(sEnable),
			.d(sum1_d),
			.q(sum1_q));
	// SUM the partial products PP0+PP1=sum0 (Input of stage regs)
	cla_gen a0_multi(	.A(pad0[3:0]), .B(pad1[3:0]), .c_in(1'b0), 
				.Sum(sum0_d[3:0]), .c_out(carry0));
	cla_gen a00_multi(.A(pad0[7:4]), .B(pad1[7:4]), .c_in(carry0), 
				.Sum(sum0_d[7:4]), .c_out(x0));
	// ADD the partial products PP2+PP4=sum1
	cla_gen a1_multi(	.A(pad2[3:0]), .B(pad3[3:0]), .c_in(1'b0), 
				.Sum(sum1_d[3:0]), .c_out(carry1));
	cla_gen a11_multi(.A(pad2[7:4]), .B(pad3[7:4]), .c_in(carry1), 
				.Sum(sum1_d[7:4]), .c_out(x1));

	// OUTPUT REGISTER 
	// Output register instantiation
	d_reg #(8) pOUT8b_multi(
			.clk(clk),
			.rst(rst),
			.en(outEnable),
			.d(final_sum_d),
			.q(pQ));
	// SUM sum0+sum1=product
	cla_gen a2_multi(	.A(sum0_q[3:0]), .B(sum1_q[3:0]), .c_in(1'b0), 
				.Sum(final_sum_d[3:0]), .c_out(carry2));
	cla_gen a22_multi(.A(sum0_q[7:4]), .B(sum1_q[7:4]), .c_in(carry2), 
				.Sum(final_sum_d[7:4]), .c_out(x2));

	//ud_counter inst_ud_counter (.clk(clk), .rst(rst), .ce(ce), .ld(ld), .ud(ud), .D(D), .zFlag(zFlag));

//end
endmodule
