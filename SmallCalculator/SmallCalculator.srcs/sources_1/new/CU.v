`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2017 04:15:07 AM
// Design Name: 
// Module Name: CU
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


module CU(s1, wa, we, rea, reb, raa, rab, c, s2, done, go, clk, cs, op);

output reg [1:0] s1, wa, raa, rab, c;
output reg we, rea, reb, s2, done;
output reg [3:0] cs;

input clk, go;
input [1:0] op;

reg [3:0] ns; //next state

parameter S0 = 4'b0000;  //state parameters
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;

always @ (go, cs)
    begin
    case(cs)
    S0: ns = (go)? S1: S0;
    S1: ns = S2;
    S2: ns = S3;
    S3: case(op)
        2'b00: ns = S4;
        2'b01: ns = S5;
        2'b10: ns = S6;
        2'b11: ns = S7;
        endcase
    S4: ns = S8;
    S5: ns = S8;
    S6: ns = S8;
    S7: ns = S8;
    default: ns = 0;
    endcase
    end
    
    always@(posedge clk)
    begin
        cs <= ns;    
    end
always@(cs)
    begin
    case(cs)
    S0: begin s1=1; wa=0; we=0; rea=0; reb=0; raa=0; rab=0; c=0; s2=0; done=0; end
    S1: begin s1=3; wa=1; we=1; rea=0; reb=0; raa=0; rab=0; c=0; s2=0; done=0; end
    S2: begin s1=2; wa=2; we=1; rea=0; reb=0; raa=0; rab=0; c=0; s2=0; done=0; end
    S3: begin s1=1; wa=0; we=0; rea=0; reb=0; raa=0; rab=0; c=0; s2=0; done=0; end
    S4: begin s1=0; wa=3; we=1; rea=1; reb=1; raa=1; rab=2; c=0; s2=0; done=0; end
    S5: begin s1=0; wa=3; we=1; rea=1; reb=1; raa=1; rab=2; c=1; s2=0; done=0; end
    S6: begin s1=0; wa=3; we=1; rea=1; reb=1; raa=1; rab=2; c=2; s2=0; done=0; end
    S7: begin s1=0; wa=3; we=1; rea=1; reb=1; raa=1; rab=2; c=3; s2=0; done=0; end
    S8: begin s1=1; wa=0; we=0; rea=0; reb=0; raa=3; rab=3; c=2; s2=1; done=1; end
    
    endcase
    end

endmodule
