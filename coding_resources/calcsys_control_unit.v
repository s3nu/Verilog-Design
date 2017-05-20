`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name: 
// Project Name: 
// Module Name: calcsys_control_unit 
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

module full_control_unit(
    input GO, clk, rst, 
    input DoneCalc, DoneDIV, Y_zFlag,
    input [2:0] OP_code,
    output reg x_en, y_en, f_en, hi_en, lo_en,
    output reg [1:0] sel_lo, sel_hi, op_calc,
    output reg sel_p, go_calc, go_div, 
    output reg doneFlag, errorFlag,
    output reg [3:0] CS
    );

parameter // State Machine
    IDLE  = 4'b0000, // State 0
    LOAD  = 4'b0001, // State 1
    WAIT  = 4'b0010, // State 2
    CGO   = 4'b0011, // State 3
    MWAIT = 4'b0100, // State 4
    DIVGO = 4'b0101, // State 5
    CWAIT = 4'b0110, // State 6
    DWAIT = 4'b0111, // State 7
    DONE  = 4'b1000; // State 8

// f_en, x_en, y_en, go_calc, op_calc, go_div, 
//    0,    1,    2,       3,       4       5,     
// sel_p, sel_hi, sel_lo, hi_en, lo_en, doneFlag
//     6,      7,     8,     9     A    B
parameter
            //    0_1_2_3__4_5_6__7__8_9_A_B
    IDLE0   = 15'b0_0_0_0_00_0_0_00_00_0_0_0, // State 0
    LOAD0   = 15'b1_1_1_0_00_0_0_00_00_0_0_0, // State 1
    WAIT0   = 15'b0_0_0_0_00_0_0_00_00_0_0_0, // State 2

    CGO0    = 15'b0_0_0_1_00_0_0_00_01_0_0_0, // State 3
    CWAIT0  = 15'b0_0_0_1_00_0_0_01_01_0_0_0, // State 6 
    CWAIT1  = 15'b0_0_0_1_01_0_0_01_01_0_0_0,
    CWAIT2  = 15'b0_0_0_1_10_0_0_01_01_0_0_0,
    CWAIT3  = 15'b0_0_0_1_11_0_0_01_01_0_0_0,

    MWAIT0  = 15'b0_0_0_0_00_0_0_10_10_0_0_0, // State 4

    DIVGO0  = 15'b0_0_0_0_00_1_0_00_11_0_0_0, // State 5
    DWAIT0  = 15'b0_0_0_0_00_1_0_11_11_0_0_0, // State 7

    // Part of WAIT state
    PASSA   = 15'b0_0_0_0_00_0_0_00_00_0_0_0, // State 2
    PASSB   = 15'b0_0_0_0_00_0_1_00_00_0_0_0, 

    DONE0   = 15'b0_0_0_0_00_0_0_00_00_1_1_1; // State 8
            //    0_1_2_3__4_5_6__7__8_9_A

reg [3:0] NS;
reg [14:0] CTRL;
reg [1:0] counter;

always @ (CTRL) begin
{f_en, x_en, y_en, go_calc, op_calc, go_div, sel_p, sel_hi, sel_lo, hi_en, lo_en, doneFlag} = CTRL;
end

/*
    Next-State Logic (Combinational)
*/
always @(CS, GO, OP_code, DoneCalc, DoneDIV, Y_zFlag) begin
    errorFlag = Y_zFlag;
    case (CS)
        IDLE: begin                             // State 0
            if (GO) begin
                if (!Y_zFlag) NS = LOAD; 
                else NS = IDLE; end
            else NS = IDLE;
          end
        LOAD: NS = WAIT;                        // State 1
        WAIT: begin                             // State 2
            case (OP_code)
                3'b100: NS = DIVGO;
                3'b101: NS = MWAIT;
                3'b110: NS = DONE;
                3'b111: NS = DONE;
                default: NS = CGO; // op codes 0,1,2,3
            endcase
        end
        CGO: NS = CWAIT;                        // State 3
        CWAIT: begin                            // State 6
            if (DoneCalc) NS = DONE;
            else          NS = CWAIT;  
        end
        DIVGO: NS = DWAIT;                      // State 5
        DWAIT: begin                            // State 7
            if (DoneDIV) NS = DONE;
            else         NS = DWAIT;
        end
        MWAIT: NS = DONE;                       // State 4
        DONE: NS = IDLE;                        // State 8
        default: NS = IDLE;
    endcase
end


/*
    State Register (sequential)
*/
always @(posedge clk, posedge rst) begin
    if (rst) begin 
        CS <= IDLE;
        counter <= 0;
    end 
    else begin
        if ((CS == MWAIT) && (counter < 2)) begin
            counter <= counter + 1;    
        end
        else if (CS == DONE) begin
            counter <= 0;
            CS <= NS;
        end
        else CS <= NS;
    end     
end

/*
    Output Logic (combinational from table)
*/
always @(CS) begin
    case (CS)
        IDLE:  CTRL = IDLE0;
        LOAD:  CTRL = LOAD0;
        WAIT:  begin
            case (OP_code)
                3'b110:  CTRL = PASSA;
                3'b111:  CTRL = PASSB;
                default: CTRL = WAIT0;
            endcase
        end  
        CGO:   CTRL = CGO0;
        CWAIT:  begin
            case (OP_code)
                3'b000:  CTRL = CWAIT0;
                3'b001:  CTRL = CWAIT1;
                3'b010:  CTRL = CWAIT2;
                3'b011:  CTRL = CWAIT3;
                default: CTRL = CWAIT0;
            endcase
        end  
        MWAIT: CTRL = MWAIT0;
        DIVGO: CTRL = DIVGO0;
        DWAIT: CTRL = DWAIT0;
        DONE:  CTRL = DONE0;
    endcase
end
endmodule