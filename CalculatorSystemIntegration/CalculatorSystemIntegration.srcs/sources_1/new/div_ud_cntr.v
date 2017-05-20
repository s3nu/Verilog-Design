`timescale 1ns / 1ps
module ud_counter(
    input clk, rst, ce, ld, ud,
    input [2:0] D,
    output reg zFlag);

reg [2:0] Q;

always @(posedge clk, posedge rst) begin
    if (rst)    Q <= 0;
    else if (ce) begin
        if (ld) Q <= D;
        else begin    
            case (ud)
                0: Q <= Q-1;
                1: Q <= Q+1;
            endcase
            end
        end
    else Q <= Q;
end

always @(Q) begin
    if (Q==3'b000) zFlag = 1;
    else zFlag = 0;
end
endmodule
