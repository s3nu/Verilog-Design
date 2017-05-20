`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name: 
// Project Name: 
// Module Name: divider_comp
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

module comparator(input [3:0] A, B, output reg out);
always @(*) begin
	if (A<B) out = 1;
	else     out = 0;
end
endmodule

module err_comparator(
    input [2:0] OP_check,
    input [3:0] A, B,
    output reg out);
always @(*) begin
    if (OP_check == 3'b100) begin
        if (A<B) out = 1;
        else     out = 0;
    end
    else out = 0;
end
endmodule