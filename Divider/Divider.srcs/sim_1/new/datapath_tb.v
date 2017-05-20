`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
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


module data_path_tb;
    reg clk, rst;
    reg Yen, Xld, Rld;          // Register/counter enables/loads
    reg X_sL, Xshiftbit, RsL, RsR;  // Shift reg ctrl bits
    reg s1, s2, s3;             // mux selectors
    reg ld_cnt, ud, Cen;        // Up/Down counter ctrl
    reg [3:0] X_in, Y_in;       // Divident, Divisor
    reg [2:0] n;                // Counter input

    wire [3:0] R, Q;            // Remainder, Quotient
    wire R_lt_Y, cnt_out;       // CU flags
    wire zeroerror;               // Divide by 0

    reg [12:0] control_signal;

data_path DUT(clk, rst, Yen, Xld, Rld, X_sL, Xshiftbit, RsL, RsR, s1, s2, s3, ld_cnt, ud, Cen, X_in, Y_in, n, R, Q, R_lt_Y, cnt_out, zeroerror);

// s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xshiftbit, Yen, Cen, ld_cnt, ud   
parameter
    IDLE  = 13'b111_000_000_0_000,
    LOAD1 = 13'b111_100_100_1_110, // go and load and initialize and notrest
    SHFTL = 13'b111_010_010_0_000, // shift left into register, shift left0 into x reg
    DEC   = 13'b111_000_000_0_100, // count=count-count
    SUB   = 13'b011_100_000_1_000, // reg - reg = new reg
    GTE   = 13'b111_010_011_0_000, // shift left into register, shift left1 into x reg
    LT    = 13'b111_010_010_0_000, // less than using shift left
    SHFTR = 13'b111_001_000_0_000, // shift right into reg
    DONE  = 13'b100_000_000_0_000; // donzo


task clockTrig; begin
	#5; clk = 1; 
	#5; clk = 0; end
endtask

integer i = 0;
integer j = 0;
integer k = 0;
integer Rt= 0;
integer Qt= 0;

always @ (control_signal) begin
{s1, s2, s3, Rld, RsL, RsR, Xld, X_sL, Xshiftbit, Yen,Cen, ld_cnt, ud} = control_signal;
end

initial 
begin
    X_in = 0; 
    Y_in = 0;
    n = 0;
    rst = 1;
    clockTrig;
    rst = 0; 
    n = 4; 
    clockTrig;

    for (i=0; i<8; i=i+1) 
    begin    
        X_in = i;
        for (j=0; j<8; j=j+1) 
        begin
            Y_in = j;
            Rt = (i%j);
            Qt = (i/j);
            control_signal = IDLE; 
            clockTrig;
            control_signal = LOAD1; 
            clockTrig;
            control_signal = SHFTL; 
            clockTrig;
            
            for (k=3; k>=0; k=k-1) 
            begin
                control_signal = DEC; 
                clockTrig;
                if (R_lt_Y) 
                begin
                    control_signal = LT; 
                    clockTrig;
                end
                else 
                begin
                    control_signal = SUB; 
                    clockTrig;
                    control_signal = GTE; 
                    clockTrig;
                end  
            end  
            if ((Y_in==0) && (!zeroerror)) 
            begin
            	$display("error");
            end
            if (!cnt_out) 
            begin
            	$display("error");
            end
            
            control_signal = SHFTR; 
            clockTrig;
            control_signal = DONE; 
            clockTrig;
            
            if ((i/j) != Q) 
            begin
            	$display("error");
            end
            if ((i%j) != R) 
            begin
            	$display("error");
            end
        end
    end
    $display("successs");
    $finish;
end
endmodule
