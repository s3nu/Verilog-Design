`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2017 06:54:28 PM
// Design Name: 
// Module Name: divider_top_level_tb
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


module divider_top_level_tb;
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
    $display("---Simulation Begining---");
    dividend = 0; divisor = 0; GO = 0; rst = 1;
    clockTrig;
    rst = 0; clockTrig;

    for (i=0; i<16; i=i+1) begin
        dividend = i;
        for (j=0; j<16; j=j+1) begin
            divisor = j; 
            GO = 1; clockTrig; 

            // Tansition FSM until done or error
            while((!done) && (!error)) begin
                clockTrig;
            end

            if (error) begin
                if (divisor != 0) begin
                    $display("DIVISOR error: %d / %d", dividend, divisor);
                    $stop;
                end
                if (quotient != 0 && remainder != 0) begin
                    $display("ERR_STATE error: Q: %d R: %d", quotient, remainder);
                   $stop;
                end
                GO = 0; clockTrig;
            end
            else if (done) begin
                if (quotient != (dividend/divisor)) begin
                    $display("QUOTIENT error: %d  /  %d", dividend, divisor);
                    $display("             q: %d  r: %d", quotient, remainder);
                    $stop;
                end
                if (remainder != (dividend%divisor)) begin
                    $display("REMAINDER error: %d  /  %d", dividend, divisor);
                    $display("              q: %d  r: %d", quotient, remainder);
                    $stop;
                end
            end

            clockTrig;
        end
    end
    $display("---Simulation Finished---");
    $finish;
end
endmodule