module voting_machine_fpga (
	input A,
	input B,
	input C,
	input clk100MHz,
	input rst,
	output [7:0] LEDOUT,
	output [7:0] LEDSEL);
	supply1[7:0] vcc;
	wire s0, s1, s2, s3, s4, s5, s6, s7;
	wire [3:0] i;
	wire DONT_USE, clk_5KHz;
	assign s7 = 1'b1;
	// instantiation and connect the sub modules
	voting_rule u0(A,B,C,i[0],i[1],i[2],i[3]);
	bcd_to_7seg u1({i[0],i[1],i[2],i[3]},s0,s1,s2,s3,s4,s5,s6);
	led_mux u2(clk_5KHz, rst, vcc, vcc, vcc, vcc, vcc, vcc, vcc,{s7, s6, s5, s4, s3, s2, s1, s0}, LEDOUT, LEDSEL);
	clk_gen u3 (.clk100MHz(clk100MHz), .rst(rst),
	.clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
	// Signal DONT_USE will cause some warnings during Synthesis.
	// You can ignore the warnings.
endmodule // end voting_machine_fpga