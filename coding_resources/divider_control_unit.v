`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2017 03:16:58 PM
// Design Name: 
// Module Name: divider_control_unit
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


module control_unit(
	input GO, clk, rst, 
	input Y_zFlag, R_Lt_Y, cntFlag,
	output reg doneFlag, zeroerror,
	output reg s1, s2, s3,
	output reg Yen, Xld, Rld, 
	output reg X_sL, Xshiftbit, RsL, RsR,
	output reg ld_cnt, ud, Cen,
	output reg [3:0] CS
    );

	parameter // State Machine
		IDLE = 4'b0000, // State 0
		LD   = 4'b0001, // State 1
		RXSL = 4'b0010, // State 2
		DEC  = 4'b0011, // State 3
		SUB  = 4'b0100, // State 4
		GTE  = 4'b0101, // State 5
		LT   = 4'b0110, // State 6
		RSR0 = 4'b0111, // State 7
		DONE = 4'b100; // State 8
		//ERR  = 4'b1001; // State 9
	parameter
		IDLE_0  = 15'b111_000_000_0_000_00,
		LD_1    = 15'b111_100_100_1_110_00, // Load R, X, Y, Cnt<-4
		RXSL_2  = 15'b111_010_010_0_000_00, // R<-sL, X<-sL0
		DEC_3   = 15'b111_000_000_0_100_00, // Cnt--
		SUB_4   = 15'b011_100_000_1_000_00, // R<-R-Y 
		GTE_5   = 15'b111_010_011_0_000_00, // R<-sL, X<-sL1
		LT_6    = 15'b111_010_010_0_000_00, // R<-sL, X<-sL0
		RSR0_7  = 15'b111_001_000_0_000_00, // R<-sR
		DONE_8  = 15'b100_000_000_0_000_10; // Done, X, R
		//ERR_9   = 15'b111_000_000_0_000_01; // zeroerror = 1
			
	reg [3:0] NS, CS;
	reg [14:0] control_signal;
	
	always @ (control_signal) 
	begin
		{s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xshiftbit, Yen,Cen, ld_cnt, ud, doneFlag} = control_signal;
	end

	always @(CS, GO, R_Lt_Y, Y_zFlag, cntFlag) 
	begin
		zeroerror = Y_zFlag;
		case (CS)
			IDLE: begin
				if (!GO) NS = IDLE;
				else     NS = LD;
			  end
			LD: begin
				if (Y_zFlag) NS = RSR0;
				else         NS = RXSL;
			  end
			RXSL: NS = DEC;
			DEC: begin
				if (R_Lt_Y) NS = LT;
				else        NS = SUB;
			  end
			SUB: NS = GTE;
			GTE: begin
				if (cntFlag) NS = RSR0;
				else         NS = DEC;
			  end
			LT: begin
				if (cntFlag) NS = RSR0;
				else         NS = DEC;
			  end
			RSR0: NS = DONE;
			DONE: NS = IDLE;
			//ERR: NS = IDLE;
			default: NS = IDLE;
		endcase
	end

	always @(posedge clk, posedge rst)
	begin
		if (rst) CS <= IDLE;
		else CS <= NS;
	end
	
	always @(CS) 
	begin
		case (CS)
			IDLE: control_signal = IDLE_0;
			LD:   control_signal = LD_1;
			RXSL: control_signal = RXSL_2;
			DEC:  control_signal = DEC_3;
			SUB:  control_signal = SUB_4;
			GTE:  control_signal = GTE_5;
			LT:   control_signal = LT_6;
			RSR0: control_signal = RSR0_7;
			DONE: control_signal = DONE_8;
			//ERR:  control_signal = ERR_9;
		endcase
	end
endmodule