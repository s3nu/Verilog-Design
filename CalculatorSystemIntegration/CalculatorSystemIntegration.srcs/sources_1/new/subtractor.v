`timescale 1ns / 1ps
module sub(
    input [4:0] A, B,
    output reg [4:0] out);
always @(*) out = A-B;
endmodule