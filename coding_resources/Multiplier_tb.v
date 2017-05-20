`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2017 08:35:25 PM
// Design Name: 
// Module Name: Multiplier_tb
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


module Multiplier_tb();
reg [3:0] a, b;
reg CLK_tb;
reg RST_tb;
reg EN_tb;
reg [7:0] temp1, temp2, temp3;
wire [7:0] mem[2:0];
wire [7:0] sum;
wire [7:0] check0, check1, check2, check3, check4;
multiplier DUT0 (a, b,  CLK_tb, RST_tb, EN_tb, sum);

integer i,j,k, x, count;

initial
begin
a = 4'd0;
b = 4'd0;
RST_tb = 1;
#1;
RST_tb = 0;
CLK_tb = 0;
EN_tb = 1;
count = 2;

end


 initial
    begin
    #5;
    for(i = 0; i < 16; i = i + 1)
        
        begin
             a = i;
             temp1 = sum;            
                for(j = 0; j < 16; j = j + 1)
                    begin
                    b = j;
                    
                        temp3 = temp2;
                        temp2 = temp1;
                        temp1 = a * b;
                        
                        CLK_tb = 1;
                        #5 CLK_tb = 0;
                        #5;                        

                        if(temp3 != a * b && CLK_tb == 1)
                            $display("Error, Mult does not equal a * b");
                              
                         
                     end
         end
     $display ("End of Simulation");
     $finish;
     end
endmodule
