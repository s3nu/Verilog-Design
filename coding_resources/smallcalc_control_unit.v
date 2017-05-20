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

`timescale 1ns / 1ps
module CU(
    input GO, clk, rst,
    input [1:0] OP,
    output reg we, rea, reb, s2, doneF,
    output reg [1:0] wa, raa, rab, s1, c,
    output reg [3:0] CS);

parameter
    IDLE  = 4'b0000,
    LD1   = 4'b0001,
    LD2   = 4'b0010,
    WAIT  = 4'b0011,
    ADD   = 4'b0100,
    SUB   = 4'b0101,
    AND   = 4'b0110,
    XOR   = 4'b0111,
    DONE  = 4'b1000;

// {s1, rea, raa, reb, rab, we, wa, c, s2, doneF}
parameter
    IDLE_0 = 15'b10_0_00_0_00_0_00_00_0_0,
    LD1_1  = 15'b00_0_00_0_00_1_01_00_0_0,
    LD2_2  = 15'b01_0_00_0_00_1_10_00_0_0,
    WAIT_3 = 15'b10_0_00_0_00_0_00_00_0_0,
    ADD_4  = 15'b11_1_01_1_10_1_11_00_0_0,
    SUB_5  = 15'b11_1_01_1_10_1_11_01_0_0,
    AND_6  = 15'b11_1_01_1_10_1_11_10_0_0,
    XOR_7  = 15'b11_1_01_1_10_1_11_11_0_0,
    DONE_8 = 15'b10_1_11_1_11_0_00_10_1_1;

reg [3:0]  NS;
reg [14:0] CTRL;

/*
    CTRL signal
*/
always @ (CTRL) begin
    {s1, rea, raa, reb, rab, we, wa, c, s2, doneF} = CTRL;
end
/*
    Next-State logic (combinational)
*/
always @(CS, GO, OP) begin
    case (CS)
        IDLE: begin
                if (!GO) NS = IDLE;
                else     NS = LD1;
              end
        LD1:  NS = LD2;
        LD2:  NS = WAIT;
        WAIT: begin
                case (OP)
                    2'b00: NS = ADD;
                    2'b01: NS = SUB;
                    2'b10: NS = AND;
                    2'b11: NS = XOR;
                endcase
              end
        ADD:  NS = DONE;
        SUB:  NS = DONE;
        AND:  NS = DONE;
        XOR:  NS = DONE;
        DONE: NS = IDLE;
        default: NS = WAIT;
    endcase
end
/*
    State Register (sequential)
*/
always @(posedge clk, posedge rst) begin
    if (rst) CS <= IDLE;
    else     CS <= NS;
end
/*
    Output logic (combinational from table)
*/
always @(CS) begin
    case (CS)
        IDLE: CTRL = IDLE_0;
        LD1:  CTRL = LD1_1;
        LD2:  CTRL = LD2_2;
        WAIT: CTRL = WAIT_3;
        ADD:  CTRL = ADD_4;
        SUB:  CTRL = SUB_5;
        AND:  CTRL = AND_6;
        XOR:  CTRL = XOR_7;
        DONE: CTRL = DONE_8;
        default: CTRL = WAIT_3;
    endcase
end
endmodule
