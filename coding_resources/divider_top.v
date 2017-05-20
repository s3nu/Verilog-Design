`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2017 03:26:55 PM
// Design Name: 
// Module Name: divder_top_level
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

// module divder_top_level(
// 	input clk100MHz, man_clk, rst, GO,
// 	input [3:0] dividend, divisor,
// 	output done, zerror,
// 	output [7:0] LEDOUT, LEDSEL,
// 	output [3:0] dividend_LEDs, divisor_LEDs
// 	);
	
// 	supply1 [7:0] vcc;
// 	wire q0, q1, q2, q3, q4, q5, q6, q7;    // Quotient 10's digit
// 	wire t0, t1, t2, t3, t4, t5, t6, t7;    // Quotient 1's digit
// 	wire r0, r1, r2, r3, r4, r5, r6, r7;    // Remainder 10's digit
// 	wire d0, d1, d2, d3, d4, d5, d6, d7;    // Remainder 1's digit
// 	wire [3:0] qLo, qHi, rLo, rHi;          // Spliter Values
// 	wire DONT_USE, clk_5KHz, debouncedButton;
// 	wire [3:0] quotient, remainder, CS;
// 	wire a7, a6, a5, a4, a3, a2, a1, a0;     // r 7-seg
// 	wire c7, c6, c5, c4, c3, c2, c1, c0;     // CS 
	
	
// 	assign q7 = 1'b1;
// 	assign t7 = 1'b1;
// 	assign r7 = 1'b1;
// 	assign d7 = 1'b1;
// 	assign c7 = 1'b1;
// 	assign a0 = 1; assign a1 = 1; assign a2 = 0; assign a3 = 0;
// 	assign a4 = 1; assign a5 = 1; assign a6 = 1; assign a7 = 1;
	
// 	assign dividend_LEDs = dividend;
// 	assign divisor_LEDs = divisor;
	
// 	clk_gen clk0(.clk100MHz(clk100MHz), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
// 	button_debouncer #(16) bd(.clk(clk_5KHz), .button(man_clk), .debounced_button(debouncedButton));
// 	divider div0(.clk(debouncedButton), .rst(rst), .GO(GO), .dividend(dividend), .divisor(divisor), .done(done), .error(zerror), .CS(CS), .quotient(quotient), .remainder(remainder));
// 	split s2(.split({1'b0, quotient}), .lo(qLo), .hi(qHi));
// 	split s3(.split({1'b0, remainder}), .lo(rLo), .hi(rHi));
// 	// Quotient 7-segment display
// 	bcd_to_7seg q3 (qHi, q0, q1, q2, q3, q4, q5, q6);
// 	bcd_to_7seg q4 (qLo, t0, t1, t2, t3, t4, t5, t6);
// 	// Remainder 7-segment display
// 	bcd_to_7seg r3 (rHi, r0, r1, r2, r3, r4, r5, r6);
// 	bcd_to_7seg r4 (rLo, d0, d1, d2, d3, d4, d5, d6);
// 	// Current State 7-segment display
// 	bcd_to_7seg cs0(CS, c0, c1, c2, c3, c4, c5, c6);
// 	led_mux U4(clk_5KHz, rst, 
// 	    {c7, c6, c5, c4, c3, c2, c1, c0},
// 	    vcc, 
// 	    vcc, 
// 	    {q7, q6, q5, q4, q3, q2, q1, q0}, 
// 	    {t7, t6, t5, t4, t3, t2, t1, t0}, 
// 	    {a7, a6, a5, a4, a3, a2, a1, a0}, 
// 	    {r7, r6, r5, r4, r3, r2, r1, r0},
// 	    {d7, d6, d5, d4, d3, d2, d1, d0}, 
// 	    LEDOUT, LEDSEL);
// endmodule

module divider(
	input clk, rst, GO,
    input [3:0] dividend, divisor,
    output done, error,
    output [3:0] quotient, remainder, CS
    );

// CU control signals
wire s1, s2, s3, Xld, Rld, X_sl, shiftbit, RsL, RsR;
wire ld_cnt, ud, Cen, Yen;

// DP status signals
wire R_lt_y, cnt_out, nullerror;

data_path d0(
	.clk(clk), .rst(rst), .Yen(Yen), .Xen(Xld), .Ren(Rld),
	.X_sL(X_sl), .Xshiftbit(shiftbit), .RsL(RsL), .RsR(RsR),
	.s1(s1), .s2(s2), .s3(s3), .load_cnt(ld_cnt),
	.ud(ud), .Cen(Cen), .X_in(dividend), .Y_in(divisor),
	.R(remainder), .Q(quotient),
	.R_lt_Y(R_lt_y), .cnt_out(cnt_out), .zeroerror(nullerror)
	);

control_unit cu0(
    .GO(GO), .clk(clk), .rst(rst),
    .Y_zFlag(error), .R_Lt_Y(R_lt_y), .cntFlag(cnt_out),
    .doneFlag(done), .zeroerror(error), 
    .s1(s1), .s2(s2), .s3(s3), .CS(CS),
    .Yen(Yen), .Xld(Xld), .Rld(Rld),
    .X_sL(X_sl), .Xshiftbit(shiftbit), .RsL(RsL), .RsR(RsR),
    .ld_cnt(ld_cnt), .ud(ud), .Cen(Cen)
    );
endmodule

// module clk_gen(clk100MHz, rst, clk_4sec, clk_5KHz); 
// 	input clk100MHz, rst;
// 	output clk_4sec, clk_5KHz;
// 	reg clk_4sec, clk_5KHz;
// 	integer count, count1; 
// 	always@(posedge clk100MHz) 
// 	begin
// 		if(rst) 
// 		begin
// 			count = 0;
// 			count1 = 0;
// 			clk_4sec = 0;
// 			clk_5KHz =0;
// 	end
// 	else
// 	begin
// 		if(count == 200000000) begin
// 			clk_4sec = ~clk_4sec;
// 			count = 0;
// 		end
// 		if(count1 == 10000) begin
// 			clk_5KHz = ~clk_5KHz;
// 			count1 = 0;
// 		end
// 			count = count + 1;
// 			count1 = count1 + 1;
// 	  end
// 	end
// endmodule // end clk_gen

// module bcd_to_7seg(BCD, s0, s1, s2, s3, s4, s5, s6); 
// 	output s0, s1, s2, s3, s4, s5, s6;
// 	input [3:0] BCD;
// 	reg s0, s1, s2, s3, s4, s5, s6;
// 	always @ (BCD)
// 	begin // BCD to 7-segment decoding 
// 	case (BCD) // s0-s6 are active low
// 	4'b0000: begin s0=0; s1=0; s2=0; s3=1; s4=0; s5=0; s6=0; end 
// 	4'b0001: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=1; end 
// 	4'b0010: begin s0=0; s1=1; s2=0; s3=0; s4=0; s5=1; s6=0; end 
// 	4'b0011: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=1; s6=0; end 
// 	4'b0100: begin s0=1; s1=0; s2=1; s3=0; s4=0; s5=0; s6=1; end 
// 	4'b0101: begin s0=0; s1=0; s2=1; s3=0; s4=1; s5=0; s6=0; end 
// 	4'b0110: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=0; end 
// 	4'b0111: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=0; end 
// 	4'b1000: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end 
// 	4'b1001: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=0; s6=0; end 
// 	default: begin s0=1; s1=1; s2=1; s3=1; s4=1; s5=1; s6=1; end
// 	endcase
// 	end
// endmodule // end bcd_to_7seg

// module led_mux (
//     input wire clk,
//     input wire rst,
//   	input wire [7:0] LED0, // leftmost digit
//     input wire [7:0] LED1,
//     input wire [7:0] LED2,
//     input wire [7:0] LED3,
//     input wire [7:0] LED4,
//     input wire [7:0] LED5,
//     input wire [7:0] LED6,
//     input wire [7:0] LED7, // rightmost digit
//     output wire [7:0] LEDSEL,
//     output wire [7:0] LEDOUT);
	
// 	reg [2:0] index;
// 	reg [15:0] led_ctrl;

// 	assign {LEDOUT, LEDSEL} = led_ctrl;
// 	always@(posedge clk)
// 	begin
// 	  index <= (rst) ? 3'd0 : (index + 3'd1);
// 	end
// 	always @(index, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7)
// 	begin
// 		case(index)
// 			 3'd0: led_ctrl <= {8'b11111110, LED7};
// 			 3'd1: led_ctrl <= {8'b11111101, LED6};
// 			 3'd2: led_ctrl <= {8'b11111011, LED5};
// 			 3'd3: led_ctrl <= {8'b11110111, LED4};
// 			 3'd4: led_ctrl <= {8'b11101111, LED3};
// 			 3'd5: led_ctrl <= {8'b11011111, LED2};
// 			 3'd6: led_ctrl <= {8'b10111111, LED1};
// 			 3'd7: led_ctrl <= {8'b01111111, LED0};
// 		   default: led_ctrl <= {8'b11111111, 8'hFF};
// 		  endcase
// 	end
// endmodule

// module button_debouncer #(parameter depth = 16) (
//     input wire clk,                 /* 5 KHz clock */
//     input wire button,              /* Input button from constraints */
//     output reg debounced_button
//     );
    
//     localparam history_max = (2**depth)-1;

//     /* History of sampled input button */
//     reg [depth-1:0] history;

//     always @ (posedge clk)
//     begin
//         /* Move history back one sample and insert new sample */
//         history <= { button, history[depth-1:1] };
        
//         /* Assert debounced button if it has been in a consistent state throughout history */
//         debounced_button <= (history == history_max) ? 1'b1 : 1'b0;
//     end
// endmodule

// module split(
//     input [4:0] split, 
//     output reg [3:0] lo, 
//     output reg [3:0] hi);
// 	always @ (split)
// 	begin
// 		if(split <= 4'b1001)
// 		begin
// 			 lo = split;
// 			 hi = 4'b0000;
// 		end
// 		else if(split <= 5'b10011 && split > 4'b1001)
// 		begin
// 			 lo = (split - 4'b1010);
// 			 hi = 4'b0001;
// 		end
// 		else if(split <= 5'b11101 && split > 5'b10011)
// 		begin
// 			 lo = (split - 5'b10100);
// 			 hi = 4'b0010;
// 		end
// 		else if(split <= 5'b11111)
// 		begin
// 			 lo = (split - 5'b11110);
// 			 hi = 4'b0011;
// 		end
// 	end
// endmodule
