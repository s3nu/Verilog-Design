`timescale 1ns / 1ps
module c_gen(
    input [3:0] G, P,
    input c_in,
    output [4:0] C);
    
    assign C[0] = c_in;
    assign C[1] = G[0] | (P[0]&C[0]);
    assign C[2] = G[1] | (G[0]&P[1]) | (C[0]&P[0]&P[1]);
    assign C[3] = G[2] | (G[1]&P[2]) | (G[0]&P[1]&P[2]) | (C[0]&P[0]&P[1]&P[2]);
    assign C[4] = G[3] | (G[2]&P[3]) | (G[1]&P[2]&P[3]) | (G[0]&P[1]&P[2]&P[3]) | (C[0]&P[0]&P[1]&P[2]&P[3]);
endmodule

