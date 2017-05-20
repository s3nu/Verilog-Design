`timescale 1ns / 1ps
module mux2 #(parameter WIDTH = 4) (
    input [WIDTH-1:0] A, B,
    input sel,
    output reg [WIDTH-1:0] out);
always @(*) begin
    if (sel) out = B;
    else     out = A;
end
endmodule