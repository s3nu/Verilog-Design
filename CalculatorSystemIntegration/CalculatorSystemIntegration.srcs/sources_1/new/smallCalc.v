 `timescale 1ns / 1ps
module small_calc(
    input GO, clk, rst, 
    input [1:0] OP,
    input [3:0] in1, in2,
    output doneFlag, 
    output [3:0] CurrentState, 
    output [4:0] out
    );

wire we, rea, reb, s2;
wire [1:0] wa, raa, rab, s1, c;

CU cu0sc (
        .GO    (GO),
        .clk   (clk),
        .rst   (rst),
        .OP    (OP),
        .we    (we),
        .rea   (rea),
        .reb   (reb),
        .s2    (s2),
        .doneF (doneFlag),
        .wa    (wa),
        .raa   (raa),
        .rab   (rab),
        .s1    (s1),
        .c     (c),
        .CS    (CurrentState)
    );

DP dp0sc(
        .in1 (in1),
        .in2 (in2),
        .s1  (s1),
        .clk (clk),
        .wa  (wa),
        .we  (we),
        .raa (raa),
        .rea (rea),
        .rab (rab),
        .reb (reb),
        .c   (c),
        .s2  (s2),
        .out (out)
    );

endmodule
