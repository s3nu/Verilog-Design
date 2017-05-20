`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2017 05:05:26 PM
// Design Name: 
// Module Name: top_level
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
module divider_tb;
	reg clk, rst, GO;
	reg [3:0] dividend, divisor;
	wire done, error;
	wire [3:0] quotient, remainder;

divider DUT2( 
    .clk(clk), .rst(rst), .GO(GO),
    .dividend(dividend), .divisor(divisor),
    .done(done), .error(error),
    .quotient(quotient), .remainder(remainder));

task clockTrig; begin
    #5; clk = 1; #5; clk = 0; end
endtask

integer i = 0;
integer j = 0;

initial begin
    dividend = 0; divisor = 0; GO = 0; rst = 1;
    clockTrig;
    rst = 0; clockTrig;

    for (i=0; i<16; i=i+1) begin
        dividend = i;
        for (j=0; j<16; j=j+1) begin
            divisor = j; 
            GO = 1; clockTrig; 
            while((!done) && (!error)) begin
                clockTrig;
            end

            if (error) begin
                if (divisor != 0) begin
                      $display("error");
                    $stop;
                end
                if (quotient != 0 && remainder != 0) begin
                	$display("error");
                   $stop;
                end
                GO = 0; clockTrig;
            end
            else if (done) begin
                if (quotient != (dividend/divisor)) begin
                    $display("error");
                    $stop;
                end
                if (remainder != (dividend%divisor)) begin
                    $display("error");
                    $stop;
                end
            end

            clockTrig;
        end
    end
    $display("succesfull");
    $finish;
end
endmodule
