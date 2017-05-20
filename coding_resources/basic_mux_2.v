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

module mux2 #(parameter WIDTH = 4) (
    input [WIDTH-1:0] A, B,
    input sel,
    output reg [WIDTH-1:0] out);
always @(*) begin
    if (sel) out = B;
    else     out = A;
end
endmodule