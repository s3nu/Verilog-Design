`timescale 1ns / 1ps

module calcsys_top_level(
    input clk100MHz, man_clk, rst, GO, 
    input [2:0] OP,
    input [3:0] A, B,
    output done, error,
    output [7:0] LEDOUT, LEDSEL,
    output [3:0] A_LEDs, B_LEDs,
    output [2:0] OP_LEDs);

	supply1 [7:0] vcc;
	wire q0, q1, q2, q3, q4, q5, q6, q7;    // HI
	wire t0, t1, t2, t3, t4, t5, t6, t7;    // LO
	wire c7, c6, c5, c4, c3, c2, c1, c0;    // CS
	wire DONT_USE, clk_5KHz, debouncedButton; 
	wire [3:0] HI, LO, CS;
	assign q7 = 1'b1;
	assign t7 = 1'b1;
	assign c7 = 1'b1;
	assign A_LEDs = A;
	assign B_LEDs = B;
	assign OP_LEDs = OP;
	
	clk_gen clk0(.clk100MHz(clk100MHz), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
	button_debouncer #(16) bd(.clk(clk_5KHz), .button(man_clk), .debounced_button(debouncedButton));
	calsysfull fc2(.GO(GO), .CS(CS), .rst(rst), .OP(OP), .in1(A), .in2(B), .done(done), .error(error), .LO(LO), .HI(HI), .clk(debouncedButton));
	hex_to_7seg hexHI (.HEX(HI),   .s0(q0),    .s1(q1), .s2(q2),    .s3(q3),    .s4(q4), .s5(q5),    .s6(q6));
	hex_to_7seg hexLO (.HEX(LO),   .s0(t0),    .s1(t1), .s2(t2),    .s3(t3),    .s4(t4), .s5(t5),    .s6(t6));
	hex_to_7seg hexCS (.HEX(CS),   .s0(c0),    .s1(c1), .s2(c2),    .s3(c3),    .s4(c4), .s5(c5),    .s6(c6));
	led_mux U4(clk_5KHz, rst, {c7, c6, c5, c4, c3, c2, c1, c0}, vcc, vcc, vcc, vcc, vcc, {q7, q6, q5, q4, q3, q2, q1, q0},{t7, t6, t5, t4, t3, t2, t1, t0}, LEDOUT, LEDSEL);
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
			clk_5KHz =0;
	end
	else
	begin
		if(count == 200000000) begin
			clk_4sec = ~clk_4sec;
			count = 0;
		end
		if(count1 == 10000) begin
			clk_5KHz = ~clk_5KHz;
			count1 = 0;
		end
			count = count + 1;
			count1 = count1 + 1;
	  end
	end
endmodule // end clk_gen

module button_debouncer #(parameter depth = 16) (
    input wire clk,                 /* 5 KHz clock */
    input wire button,              /* Input button from constraints */
    output reg debounced_button
    );
    localparam history_max = (2**depth)-1;
    /* History of sampled input button */
    reg [depth-1:0] history;
    always @ (posedge clk)
    begin
        /* Move history back one sample and insert new sample */
        history <= { button, history[depth-1:1] };
        /* Assert debounced button if it has been in a consistent state throughout history */
        debounced_button <= (history == history_max) ? 1'b1 : 1'b0;
    end
endmodule

module led_mux (
    input wire clk,
    input wire rst,
    input wire [7:0] LED0, // leftmost digit
    input wire [7:0] LED1,
    input wire [7:0] LED2,
    input wire [7:0] LED3,
    input wire [7:0] LED4,
    input wire [7:0] LED5,
    input wire [7:0] LED6,
    input wire [7:0] LED7, // rightmost digit
    output wire [7:0] LEDSEL,
    output wire [7:0] LEDOUT);

	reg [2:0] index;
	reg [15:0] led_ctrl;
	assign {LEDOUT, LEDSEL} = led_ctrl;
	always@(posedge clk)
	begin
	  index <= (rst) ? 3'd0 : (index + 3'd1);
	end
	always @(index, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7)
	begin
		case(index)
			 3'd0: led_ctrl <= {8'b11111110, LED7};
			 3'd1: led_ctrl <= {8'b11111101, LED6};
			 3'd2: led_ctrl <= {8'b11111011, LED5};
			 3'd3: led_ctrl <= {8'b11110111, LED4};
			 3'd4: led_ctrl <= {8'b11101111, LED3};
			 3'd5: led_ctrl <= {8'b11011111, LED2};
			 3'd6: led_ctrl <= {8'b10111111, LED1};
			 3'd7: led_ctrl <= {8'b01111111, LED0};
		   default: led_ctrl <= {8'b11111111, 8'hFF};
		  endcase
	end
endmodule

module hex_to_7seg(
    input [3:0]HEX, 
    output reg s0, s1, s2, s3, s4, s5, s6);
always @ (HEX)
begin 
	case (HEX) 
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
		4'b1010: begin s0=1; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
		4'b1011: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=1; end
		4'b1100: begin s0=0; s1=1; s2=0; s3=1; s4=1; s5=0; s6=0; end
		4'b1101: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=1; s6=1; end
		4'b1110: begin s0=0; s1=1; s2=0; s3=0; s4=1; s5=0; s6=0; end
		4'b1111: begin s0=1; s1=1; s2=0; s3=0; s4=1; s5=0; s6=0; end
		default: begin s0=1; s1=1; s2=1; s3=1; s4=1; s5=1; s6=1; end
	endcase
end
endmodule 