`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2017 05:23:19 AM
// Design Name: 
// Module Name: data_path
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
//	if (Op = 2'b11) //Add
//		R3 ? R1 + R2;
//	else if(Op = 2'b10) //Subtract
//		R3 ? R1 - R2;
//	else if(Op = 2'b01) //And
//		R3 ? R1 & R2;
//	else //Xor
//		R3 ? R1 ^ R2;
//////////////////////////////////////////////////////////////////////////////////


module DP(in1, in2, s1, clk, wa, we, raa, rea, rab, reb, c, s2, out);
	input [2:0] in1, in2;
	input [1:0] s1, wa, raa, rab, c;
	input we, rea, reb, s2, clk;
	output [2:0] out;
	wire [2:0] mux1out;
	wire [2:0] douta;
	wire [2:0] doutb;
	wire [2:0] aluout;
	
	// instantiate the building blocks
	MUX1 U0(.in1(in1), .in2(in2), .in3(3'b000), .in4(aluout), .s1(s1),
	.m1out(mux1out));
	RF U1(.clk(clk), .rea(rea), .reb(reb), .raa(raa), .rab(rab), .we(we), .wa(wa),
	.din(mux1out), .douta(douta), .doutb(doutb));
	ALU U2(.in1(douta), .in2(doutb), .c(c), .aluout(aluout));
	MUX2 U3(.in1(aluout), .in2(3'b000), .s2(s2), .m2out(out));
endmodule //DP

/* Source Code for the Building Blocks Used */
module MUX1(in1, in2, in3, in4, s1, m1out);
	input [2:0] in1, in2, in3, in4;
	input [1:0] s1;
	output reg [2:0] m1out;
	always @ (in1, in2, in3, in4, s1)
	begin
		case (s1)
			2'b11: m1out = in1;
			2'b10: m1out = in2;
			2'b01: m1out = in3;
			default: m1out = in4; // 2'b00
		endcase
	end
endmodule //MUX1

module RF(clk, rea, reb, raa, rab, we, wa, din, douta, doutb);
	input clk, rea, reb, we;
	input [1:0] raa, rab, wa;
	input [2:0] din;
	output reg [2:0] douta, doutb;
	reg [2:0] RegFile [3:0];
	always @(rea, reb, raa, rab)
	begin
		if (rea)
			douta = RegFile[raa];
		else douta = 3'b000;
		if (reb)
			doutb = RegFile[rab];
		else doutb = 3'b000;
	end
	always@(posedge clk)
	begin
		if (we)
			RegFile[wa] = din;
		else
			RegFile[wa] = RegFile[wa];
	end
endmodule //RF
	
module ALU (in1, in2, c, aluout);
	input [2:0] in1, in2;
	input [1:0] c;
	output reg [2:0] aluout;
	always @ (in1, in2, c)
	begin
		case (c)
			2'b00: aluout = in1 + in2;
			2'b01: aluout = in1 - in2;
			2'b10: aluout = in1 & in2;
		default: aluout = in1 ^ in2; // 2'b11;
		endcase
	end
endmodule //ALU
	
module MUX2 (in1, in2, s2, m2out);
	input [2:0] in1, in2;
	input s2;
	output reg [2:0] m2out;
	always @ (in1, in2, s2)
	begin
		if (s2)
			m2out = in1;
		else
			m2out = in2;
	end
endmodule //MUX2

//Attachment 3: Verilog Source Code for Utility Blocks Needed by FPGA Prototyping
module clk_gen(clk100MHz, rst, clk_4sec, clk_5KHz);
	input clk100MHz, rst;
	output clk_4sec, clk_5KHz;
	reg clk_4sec, clk_5KHz;
	integer count, count1;
	always@(posedge clk100MHz)
	begin
		if(rst)
		begin
			count = 0;
			count1 = 0;
			clk_4sec = 0;
			clk_5KHz =0;
		end
		else
		begin
			if(count == 200000000)
			begin
				clk_4sec = ~clk_4sec;
				count = 0;
			end
			if(count1 == 10000)
			begin
				clk_5KHz = ~clk_5KHz;
				count1 = 0;
			end
			count = count + 1;
			count1 = count1 + 1;
		end
	end
endmodule // end clk_gen

module bcd_to_7seg(BCD, s0, s1, s2, s3, s4, s5, s6);
	output s0, s1, s2, s3, s4, s5, s6;
	input [3:0] BCD;
	reg s0, s1, s2, s3, s4, s5, s6;
	always @ (BCD)
	begin // BCD to 7-segment decoding
		case (BCD) // s0 - s6 are active low
		4'b0000: begin s0=0; s1=0; s2=0; s3=1; s4=0; s5=0; s6=0; end
		4'b0001: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=1; end
		4'b0010: begin s0=0; s1=1; s2=0; s3=0; s4=0; s5=1; s6=0; end
		4'b0011: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=1; s6=0; end
		4'b0100: begin s0=1; s1=0; s2=1; s3=0; s4=0; s5=0; s6=1; end
		4'b0101: begin s0=0; s1=0; s2=1; s3=0; s4=1; s5=0; s6=0; end
		4'b0110: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=0; end
		4'b0111: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=0; end
		4'b1000: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
		4'b1001: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=0; s6=0; end
		default: begin s0=1; s1=1; s2=1; s3=1; s4=1; s5=1; s6=1; end
		endcase
	end
endmodule // end bcd_to_7seg

module led_mux (clk, rst, LED0, LED1, LED2, LED3, LEDOUT, LEDSEL);
	input clk, rst;
	input [7:0] LED0, LED1, LED2, LED3;
	output[3:0] LEDSEL;
	output[7:0] LEDOUT;
	reg [3:0] LEDSEL;
	reg [7:0] LEDOUT;
	reg [1:0] index;
	always @(posedge clk)
	begin
		if(rst)
			index = 0;
		else
			index = index + 2'd1;
	end
	always @(index,LED0,LED1,LED2,LED3)
	begin
		case(index)
			0: begin
				LEDSEL = 4'b1110;
				LEDOUT = LED0;
			end
			1: begin
				LEDSEL = 4'b1101;
				LEDOUT = LED1;
			end
			2: begin
				LEDSEL = 4'b1011;
				LEDOUT = LED2;
			end
			3: begin
				LEDSEL = 4'b0111;
				LEDOUT = LED3;
			end
			default: begin
				LEDSEL = 0; LEDOUT = 0;
			end
		endcase
	end
endmodule // end led_mux

module button_debouncer #(parameter depth = 16) (
	input wire clk, /* 5 KHz clock */
	input wire button, /* Input button from constraints */
	output reg debounced_button);
	
	localparam history_max = (2**depth)-1;
	/* History of sampled input button */
	reg [depth-1:0] history;
	always @ (posedge clk)
	begin
		/* Move history back one sample and insert new sample */
		history <= { button, history[depth-1:1] };
		
		/* Assert debounced button if it has been in a consistent state
		throughout history */
		debounced_button <= (history == history_max) ? 1'b1 : 1'b0;
	end
endmodule
