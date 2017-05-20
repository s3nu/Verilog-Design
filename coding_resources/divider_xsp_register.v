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

module x_reg(
    input clk, rst, LD, sL, sh_b,         // sh_b == shift bit val
    input [3:0] D,
    output reg [3:0] Q,
    output reg msb
    );

wire [3:0] out;
assign out = Q;

always @(posedge clk, posedge rst) begin
    if (rst)      Q <= 4'b0000;          // Reset (load 0)
    else if (LD)  Q <= D;                // Set
    else if (sL) begin
        if (sh_b) Q <= {out[2:0], 1'b1}; // SL w/ 1
        else      Q <= {out[2:0], 1'b0}; // SL w/ 0
    end
    else          Q <= out;              // Hold

end
always @(Q) begin
    msb = out[3];                        // MSB output
end
endmodule