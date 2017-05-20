`timescale 1ns / 1ps
module cu(
	input GO, clk, rst, 
	input Y_zFlag, R_Lt_Y, cntFlag,
	output reg doneFlag, errFlag,
	output reg s1, s2, s3,
	output reg Yen, Xld, Rld, 
	output reg X_sL, Xsh_b, RsL, RsR,
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
	DONE = 4'b1000; // State 8
    //ERR  = 4'b1001; // State 9

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
    DONE_8  = 14'b100_000_000_0_000_1; // Done, X, R
    //ERR_9   = 14'b111_000_000_0_000_0; // errFlag = 1
            //    123_456_789_A_BCD_E

reg [3:0] NS;
reg [13:0] CTRL;

always @ (CTRL) begin
{s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xsh_b, Yen,Cen, ld_cnt, ud, doneFlag} = CTRL;
end

/*
    Next-State Logic (Combinational)
*/
always @(CS, GO, R_Lt_Y, Y_zFlag, cntFlag) begin
    errFlag = Y_zFlag;
    case (CS)
        IDLE: begin
            if (GO) begin
                if (!Y_zFlag) NS = LD; 
                else NS = IDLE; end
            else NS = IDLE;
          end
        LD: NS = RXSL;
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


/*
    State Register (sequential)
*/
always @(posedge clk, posedge rst) begin
    if (rst) CS <= IDLE;
    else     CS <= NS;
end

/*
    Output Logic (combinational from table)
*/
always @(CS) begin
    case (CS)
        IDLE: CTRL = IDLE_0;
        LD:   CTRL = LD_1;
        RXSL: CTRL = RXSL_2;
        DEC:  CTRL = DEC_3;
        SUB:  CTRL = SUB_4;
        GTE:  CTRL = GTE_5;
        LT:   CTRL = LT_6;
        RSR0: CTRL = RSR0_7;
        DONE: CTRL = DONE_8;
        //ERR:  CTRL = ERR_9;
    endcase
end

endmodule