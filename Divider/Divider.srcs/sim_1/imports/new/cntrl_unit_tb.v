`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2017 03:11:20 PM
// Design Name: 
// Module Name: cntrl_unit_tb
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


module cu_tb;
	reg GO, clk, rst; 
	reg Y_zFlag, R_Lt_Y, cntFlag;
	wire doneFlag, errFlag;
	wire s1, s2, s3;
	wire Yen, Xld, Rld;
	wire X_sL, Xsh_b, RsL, RsR;
	wire ld_cnt, ud, Cen;
    wire [3:0] CS;

control_unit DUT(.GO(GO), .clk(clk), .rst(rst),
        .Y_zFlag(Y_zFlag), .R_Lt_Y(R_Lt_Y), .cntFlag(cntFlag),
        .doneFlag(doneFlag), .zeroerror(errFlag), 
        .s1(s1), .s2(s2), .s3(s3),
        .Yen(Yen), .Xld(Xld), .Rld(Rld),
        .X_sL(X_sL), .Xshiftbit(Xsh_b), .RsL(RsL), .RsR(RsR),
        .ld_cnt(ld_cnt), .ud(ud), .Cen(Cen), .CS(CS)
    );

// 1   2   3   4    5    6    7    8     9      
// s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xsh_b, 
// A    B    C       D   E         F
// Yen, Cen, ld_cnt, ud, doneFlag, Y_zFlag   
parameter
            //    123_456_789_A_BCD_E
    IDLE_0  = 14'b111_000_000_0_000_0,
    LD_1    = 14'b111_100_100_1_110_0, // Load R, X, Y, Cnt<-4
    RXSL_2  = 14'b111_010_010_0_000_0, // R<-sL, X<-sL0
    DEC_3   = 14'b111_000_000_0_100_0, // Cnt--
    SUB_4   = 14'b011_100_000_1_000_0, // R<-R-Y 
    GTE_5   = 14'b111_010_011_0_000_0, // R<-sL, X<-sL1
    LT_6    = 14'b111_010_010_0_000_0, // R<-sL, X<-sL0
    RSR0_7  = 14'b111_001_000_0_000_0, // R<-sR
    DONE_8  = 14'b100_000_000_0_000_1, // Done, X, R
    ERR_9   = 14'b111_000_000_0_000_0; // errFlag = 1
            //    123_456_789_A_BCD_E

reg [13:0] CTRL;

task clockTrig; begin
	#5; clk = 1; #5; clk = 0; end
endtask

always @(*) begin
CTRL = {s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xsh_b, Yen,Cen, ld_cnt, ud, doneFlag};
end

initial begin
	// 4 - bits to test
	// {GO, Y_zFlag, R_Lt_Y, cntFlag} = test
	$display("---Simulation Begining---");
    GO = 0; Y_zFlag = 0; R_Lt_Y = 0; cntFlag = 0;
	rst = 1; clockTrig;
	rst = 0; clockTrig;

    // STATE 0 TEST
    if (CTRL != IDLE_0) $display("IDLE_0 error1");
    
        // ERROR FLAG TEST
        Y_zFlag = 1; clockTrig;
        if (CTRL != IDLE_0) $display("ZERO flag error");
        if (errFlag != 1) $display("ERROR flag error");

        // !GO TEST
        Y_zFlag = 0; clockTrig;
        if (CTRL != IDLE_0) $display("!GO error");
        GO = 1; clockTrig;
    
    // STATE 1 TEST
	if (CTRL != LD_1)$display("LD_1 error"); 
    clockTrig;

    // STATE 2 TEST
    if (CTRL != RXSL_2) $display("RXSL_2 error");
     
    // STATE 3 TEST
    clockTrig;
    if (CTRL != DEC_3) $display("DEC_3 error"); 

    // STATE 4 TEST
    R_Lt_Y = 0; clockTrig;
    if (CTRL != SUB_4) $display("SUB_4 error"); 

        // STATE 5 TEST
        clockTrig;
        if (CTRL != GTE_5) $display("GTE_5 error"); 
        cntFlag = 0; clockTrig; 
        R_Lt_Y = 1; clockTrig;

        // STATE 6 TEST
        if (CTRL != LT_6) $display("LT_6 error"); 
        clockTrig; // back to state 3
        clockTrig; cntFlag = 1;
        clockTrig;

    // STATE 7 TEST
    if (CTRL != RSR0_7) $display("RSR0_7 error"); 
    clockTrig;

    // STATE 8 TEST
    if (CTRL != DONE_8) $display("DONE_8 error"); 
    if (doneFlag != 1) $display("doneFlag error");
    clockTrig;

	$display("succeffull;");
	$finish;
end
endmodule
