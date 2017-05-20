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

module ALU (in1, in2, c, aluout);
input [4:0] in1, in2;
input [1:0] c;
output reg [4:0] aluout;
always @ (in1, in2, c) begin
    case (c)
        2'b00: aluout = in1 + in2;
        2'b01: aluout = in1 - in2;
        2'b10: aluout = in1 & in2;
        2'b11: aluout = in1 ^ in2; 
    endcase
end
endmodule //ALU