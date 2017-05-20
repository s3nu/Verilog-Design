`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2017 03:23:25 PM
// Design Name: 
// Module Name: tb_fifo
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


module tb_fifo;
	reg clk, rst, wr, enable;
	reg [3:0] d_in;

	wire [3:0] out;
	wire full, empty;

	fifo DUT(.d_in(d_in), .d_out(out), .empty(empty), .full(full),.clk(clk), .rst(rst), .wr(wr), .enable(enable));
// 	fifo DUT(.clk(clk), .rst(rst), .wr(wr), .enable(enable),
//		.d_in(d_in), .d_out(out),
//		.full(full), .empty(empty),
//		.r_ptr(rptr), w_ptr(wptr));

	task clkhit; begin
		clk = 1; #5; clk = 0; #5; end
	endtask	
	task rst_global; begin
		rst = 1; #5; rst = 0; #5; end
	endtask

	integer i = 0;
	initial 
	begin
		enable = 1; wr = 0; d_in = 0; clkhit;
		rst_global;
		if (out != 0)//checking if out does not equal 0
		begin
			$display ("error");
			$stop; 
		end
		enable = 0;
		clkhit;
		if (out != d_in)//checking if output equals input
		begin
			$display ("error");
			$stop; 
		end
		
		$display("testing writing");
		enable = 1; wr = 0; clkhit;
		for (i=0; i<10; i=i+1)//testing the write fiunction 
		begin
			d_in = i;
			clkhit;
		end
		if (!full)//checking if full
		begin
			$display ("error");
			$stop; 
		end
	
		$display("testing reading");
		wr = 1; clkhit;
		for (i=0; i<10; i=i+1)//testing the read function
		begin
			clkhit;
			if (out != i)
			begin
				$display ("error");
			end
		end
		if (!empty)//checking for empty
		begin
			$display ("error");
			$stop; 
		end
		$display("successfull");
	end
endmodule
