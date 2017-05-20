`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2017 02:58:09 PM
// Design Name: 
// Module Name: storage_top
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


//module storage_top(input clk100MHz, setCLK, rst, wr, enable, 
//	input [3:0] in, 
//	output [3:0] out,
//	output full, empty,
//	output wnrLED, enLED,
//	output [3:0] inLED
//    );
//	wire dbbutton;
//	wire DONT_USE, clk_5KHz;
//	assign wnrLED = wr;
//	assign enLED = enable;
//	assign inLED = in;
//	clk_gen u5 (.clk100MHz(clk100MHz), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));
//	button_debouncer #(16) bd(.clk(clk_5KHz), .button(setCLK), .debounced_button(dbbutton));
//	fifo Q1(.d_in(in), .d_out(out), .empty(empty), .full(full), .clk(dbbutton), .rst(rst), .wr(wr), .enable(enable));
//endmodule

module fifo(d_in,d_out,empty,full,clk,rst,wr,enable);
	input clk, rst, wr, enable;
	input [3:0] d_in;
	output reg [3:0] d_out;
	output reg full, empty;
	reg [3:0] r_ptr, w_ptr;
	reg [3:0] mem [7:0];
	always @(posedge clk or posedge rst) begin
		if (rst) 
		begin
			r_ptr <= 0; w_ptr <= 0; d_out <= 0; 
		end
		else if (!enable) 
		begin
			d_out <= 'bz;
		end
		else if (wr && !empty) 
		begin
			d_out <= mem[r_ptr[2:0]];
			r_ptr <= r_ptr + 1;
		end
		else if (!wr && !full) 
		begin
			mem[w_ptr[2:0]] <= d_in;
			w_ptr <= w_ptr + 1;
		end
		else 
		begin
			d_out <= 'bz;
		end
	end
	always @(r_ptr, w_ptr) 
	begin
		if (r_ptr == w_ptr) 
			begin
				empty = 1;
				full = 0;
			end
		else if (r_ptr[2:0] == w_ptr[2:0]) 
		begin
			empty = 0;
			full = 1;
		end
		else 
		begin
			empty = 0;
			full = 0;
		end
	end
endmodule

module regfile (input [4:0] ra1, ra2, wa1, wa2, input we1, we2, clk, input [31:0] wd1, wd2, output [31:0] rd1, rd2);
	reg [31:0] rf [31:0];
	always @(posedge clk) begin
		if (we1) 
		begin
			rf[wa1] <= wd1;
		end
		if (we2) 
		begin
			rf[wa2] <= wd2;
		end
	end
	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module clk_gen(clk100MHz, rst, clk_4sec, clk_5KHz); // start clk_gen
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


