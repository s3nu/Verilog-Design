`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2017 02:00:54 PM
// Design Name: 
// Module Name: calculator
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
module calculator_top_level(
	input GO, man_clk, clk100MHz, rst, 
	input [1:0] OP,
	input [2:0] in1, in2,
	output doneFlag, 
	output [7:0] LEDOUT,
	output [7:0] LEDSEL,
	output [2:0] in1_LEDs, in2_LEDs,
	output [1:0] OP_LEDs);

	supply1 [7:0] vcc;
	wire s0, s1, s2, s3, s4, s5, s6, s7; // Ouptut LED
	wire r0, r1, r2, r3, r4, r5, r6, r7; // Current State LED
	wire [3:0] cs;
	wire [2:0] out;
	wire debouncedButton;
	wire DONT_USE, clk_5KHz;
	assign s7 = 1'b1;
	assign r7 = 1'b1;
	
	assign in1_LEDs = in1;
	assign in2_LEDs = in2;
	assign OP_LEDs = OP;
	
	clk_gen u5 (.clk100MHz(clk100MHz), .rst(rst), 
				.clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
	button_debouncer #(16) bd(.clk(clk_5KHz), .button(man_clk), 
							  .debounced_button(debouncedButton));
	calculator c1(.GO(GO), .clk(debouncedButton), .rst(rst), .OP(OP), .in1(in1),
			.in2(in2), .doneFlag(doneFlag), .CurrentState(cs), 
			.out(out));
//	hex_to_7seg out0({1'b0, out}, s0, s1, s2, s3, s4, s5, s6);
//	hex_to_7seg cs0(cs, r0, r1, r2, r3, r4, r5, r6);
	bcd_to_7seg out0({1'b0, out}, s0, s1, s2, s3, s4, s5, s6);
	bcd_to_7seg cs0(cs, r0, r1, r2, r3, r4, r5, r6);
	led_mux U4(clk_5KHz, rst, {r7, r6, r5, r4, r3, r2, r1, r0},
			   vcc, vcc, vcc, vcc, vcc, vcc,
			   {s7, s6, s5, s4, s3, s2, s1, s0}, LEDOUT, LEDSEL);					

endmodule

module calculator(go, op, in1, in2, clk, cs, done, out);
	input go, clk;
	input [1:0] op;
	input [2:0] in1, in2;
	output [3:0] cs;
	output [2:0] out;
	output done;
	wire [1:0] s1, wa, raa, rab, c;
	wire we, rea, reb, s2;
	CU U0(.s1(s1), .wa(wa), .we(we), .rea(rea), .reb(reb), .raa(raa), .rab(rab), .c(c), .s2(s2), .done(done), .go(go), .clk(clk), .cs(cs), .op(op));
	DP U1(.in1(in1), .in2(in2), .s1(s1), .clk(clk), .wa(wa), .we(we), .raa(raa), .rea(rea), .rab(rab), .reb(reb), .c(c), .out(out));
endmodule

module bcd_to_7seg(BCD, s0, s1, s2, s3, s4, s5, s6); 
	output s0, s1, s2, s3, s4, s5, s6; 
	input [3:0] BCD; 
	reg s0, s1, s2, s3, s4, s5, s6; 
	always @ (BCD) begin // BCD to 7-segment decoding 
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
endmodule  // end bcd_to_7seg

module button_debouncer #(parameter depth = 16) (     
	input wire clk,                 /* 5 KHz clock */     
	input wire button,              /* Input button from constraints */     
	output reg debounced_button);          
	localparam history_max = (2**depth)-1;     /* History of sampled input button */     
	reg [depth-1:0] history;     
	always @ (posedge clk)     
		begin         /* Move history back one sample and insert new sample */         
		history <= { button, history[depth-1:1] };                  /* Assert debounced button if it has been in a consistent state throughout history */         
		debounced_button <= (history == history_max) ? 1'b1 : 1'b0;     
		end 
endmodule

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
	 clk_5KHz  =0;
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
	   count1 = 0;   end   
	  count = count + 1;   
	  count1 = count1 + 1;         
	 end 
	 end 
 endmodule // end clk_gen
 
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
	  if(rst)  index = 0;
	  else
	   index = index + 2'd1;
	 end always @(index,LED0,LED1,LED2,LED3)
	 begin
	  case(index)  0: 
	  begin  LEDSEL = 4'b1110;   LEDOUT = LED0;
	   end
	  1: begin  LEDSEL = 4'b1101;   LEDOUT = LED1;   
	   end
	  2: begin  LEDSEL = 4'b1011;   LEDOUT = LED2;
	   end
	  3: begin  LEDSEL = 4'b0111;   LEDOUT = LED3;
	   end
	  default: begin    LEDSEL = 0; LEDOUT = 0;
	  end  
	  endcase 
	  end 
  endmodule  // end led_mux