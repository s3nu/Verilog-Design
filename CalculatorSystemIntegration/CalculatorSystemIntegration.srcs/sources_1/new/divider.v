`timescale 1ns / 1ps
module divider(
    input clk, rst, GO,
    input [3:0] dividend, divisor,
    output done, error,
    output [3:0] quotient, remainder, CS
    );

// CU control signals
wire s1, s2, s3, Xld, Rld, X_sl, Xsh_b, RsL, RsR;
wire ld_cnt, ud, Cen, Yen;

// DP status signals
wire R_lt_y, cnt_out, errFlag;

dp d0(
    .clk(clk), .rst(rst), .Yen(Yen), .Xen(Xld), .Ren(Rld),
    .X_sL(X_sl), .Xsh_b(Xsh_b), .RsL(RsL), .RsR(RsR),
    .s1(s1), .s2(s2), .s3(s3), .load_cnt(ld_cnt),
    .ud(ud), .Cen(Cen), .X_in(dividend), .Y_in(divisor),
    .R(remainder), .Q(quotient),
    .R_lt_Y(R_lt_y), .cnt_out(cnt_out), .errFlag(errFlag)
    );

cu cu0(
    .GO(GO), .clk(clk), .rst(rst),
    .Y_zFlag(errFlag), .R_Lt_Y(R_lt_y), .cntFlag(cnt_out),
    .doneFlag(done), .errFlag(error), 
    .s1(s1), .s2(s2), .s3(s3), .CS(CS),
    .Yen(Yen), .Xld(Xld), .Rld(Rld),
    .X_sL(X_sl), .Xsh_b(Xsh_b), .RsL(RsL), .RsR(RsR),
    .ld_cnt(ld_cnt), .ud(ud), .Cen(Cen)
    );
endmodule