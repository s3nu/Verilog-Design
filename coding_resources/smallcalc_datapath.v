`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name: 
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

module DP(in1, in2, s1, clk, wa, we, raa, rea, rab, reb, c, s2, out);
input [3:0] in1, in2;
input [1:0] s1, wa, raa, rab, c;
input we, rea, reb, s2, clk;
output [4:0] out;
wire [4:0] mux1out;
wire [4:0] douta;
wire [4:0] doutb;
wire [4:0] aluout;
// instantiate the building blocks
MUX1 #(5) m1sc0(
      .in1   ({0,in1}),
      .in2   ({0,in2}),
      .in3   (5'b00000),
      .in4   (aluout),
      .s1    (s1),
      .m1out (mux1out)
);
//MUX1 m1sc (.in1(in1), .in2(in2), .in3(4'b0000), .in4(aluout), .s1(s1), .m1out(mux1out));
RF rf1sc(
            .clk   (clk),
            .rea   (rea),
            .reb   (reb),
            .raa   (raa),
            .rab   (rab),
            .we    (we),
            .wa    (wa),
            .din   (mux1out),
            .douta (douta),
            .doutb (doutb)
        );
ALU alu1sc (.in1(douta), .in2(doutb), .c(c), .aluout(aluout));
mux2 #(5) m2sc(.A(5'b00000), .B(aluout), .sel(s2), .out(out));
endmodule //DP