`timescale 1ns / 1ps
module calc_tb;
    reg GO, clk, rst;
    reg [1:0] OP;
    reg [3:0] in1, in2;
    wire dFlag;
    wire [3:0] cs;
    wire [4:0] out;

small_calc sc0(
            .GO           (GO),
            .clk          (clk),
            .rst          (rst),
            .OP           (OP),
            .in1          (in1),
            .in2          (in2),
            .doneFlag     (dFlag),
            .CurrentState (cs),
            .out          (out)
        );

task clockTrig; begin
    #5; clk = 1; #5; clk = 0; end
endtask

integer i = 0;
integer j = 0;
integer k = 0;

initial begin
    $display("---Simulation Begining---");
    in1 = 0; in2 = 0; GO = 0; OP = 0; rst = 1;
    clockTrig;
    rst = 0; clockTrig;
    OP = 0;
    for (i=0; i<16; i=i+1) begin
        GO = 1;
        in1 = i;
        clockTrig;
        GO = 0;
        clockTrig;
        for (j=0; j<16; j=j+1) begin
            in2 = j;
            clockTrig;
            for (k=0; k<4; k=k+1) begin
                OP = k;
                clockTrig;
                clockTrig;

                    while (!dFlag) begin
                        clockTrig;  
                    end
                case (OP)
                    2'b00: begin
                            if ((in1+in2) != out)
                                $display("ADD error");
                           end
                    2'b01: begin
                            if ((in1-in2) != out)
                                $display("SUB error");
                           end
                    2'b10: begin
                            if ((in1&in2) != out)
                                $display("AND error");
                           end
                    2'b11: begin
                            if ((in1^in2) != out)
                                $display("XOR error");
                           end
                endcase
                // if (dFlag != 1) 
                //  $display("DONE flag error");
                // clockTrig; clockTrig;
                GO = 1;
                clockTrig;
            end
        end
    end
    $display("---Simulation Finished---");
    $finish; 
end
endmodule