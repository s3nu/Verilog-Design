//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Design Name: 
//// Module Name: sample_provided
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module DPA_tb;

//	reg        clk, re1, re2, we, s2;
//	reg  [1:0] ra1, ra2, wa, s1, op;
//	reg  [3:0] in1, in2;
//	reg [13:0] ctrl;
//	wire [3:0] out;
	
//	DPA DUT (clk, re1, re2, we, s2, ra1, ra2, wa, s1, op, in1, in2, out);
	
//	parameter
//		IDLE  = 14'b00_0_00_0_00_0_00_00_0,
//		LOAD1 = 14'b01_0_00_0_00_1_01_00_0,
//		LOAD2 = 14'b10_0_00_0_00_1_10_00_0,
//		WAIT  = 14'b11_1_01_1_10_0_00_00_0,
//		ADD   = 14'b11_1_01_1_10_1_11_00_0,
//		SUB   = 14'b11_1_01_1_10_1_11_01_0,
//		AND   = 14'b11_1_01_1_10_1_11_10_0,
//		XOR   = 14'b11_1_01_1_10_1_11_11_0,
//		DONE  = 14'b00_1_00_1_11_0_00_00_1;
	
//	task tick; begin #5 clk = 1;  #5 clk = 0; end endtask
	
//	always @ (ctrl) {s1, re1, ra1, re2, ra2, we, wa, op, s2} = ctrl;
	
//	initial
//	begin
//		clk = 0; in1 = 5; in2 = 4;
//		ctrl = IDLE;  tick;
//		ctrl = LOAD1; tick;
//		ctrl = LOAD2; tick;
//		ctrl = WAIT;  tick;
//		ctrl = ADD;   tick;
//		ctrl = DONE;  tick; if (out != (in1 + in2)) $display ("Add Failed");
//		ctrl = SUB;   tick;
//		ctrl = DONE;  tick; if (out != (in1 - in2)) $display ("Sub Failed");
//		ctrl = AND;   tick;
//		ctrl = DONE;  tick; if (out != (in1 & in2)) $display ("And Failed");
//		ctrl = XOR;   tick;
//		ctrl = DONE;  tick; if (out != (in1 ^ in2)) $display ("Xor Failed");
//		$display ("Simulation Successful");
//		$finish;
//	end

//endmodule