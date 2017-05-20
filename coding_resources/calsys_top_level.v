`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 04:20:30 AM
// Design Name: 
// Project Name: 
// Module Name: calcsys_top_level
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

module fullcalc(
    input        GO, clk, rst,
    input  [2:0] OP,
    input  [3:0] in1, in2,
    output       done, error,
    output [3:0] LO, HI, CS);

wire x_en, y_en, f_en, hi_en, lo_en, sel_p, Y_zFlag;
wire done_calc, done_div, go_div, go_calc;
wire [1:0] sel_lo, sel_hi, op_calc;
wire [2:0] op_wire;

full_datapath fullDP_0(
    .X         (in1),     .Y         (in2),       .OP_in     (OP),
    .clk       (clk),     .rst       (rst),       .x_en      (x_en),
    .y_en      (y_en),    .f_en      (f_en),      .hi_en     (hi_en),
    .lo_en     (lo_en),   .sel_lo    (sel_lo),    .sel_hi    (sel_hi),
    .op_calc   (op_calc), .sel_p     (sel_p),     .go_calc   (go_calc),
    .go_div    (go_div),  .done_calc (done_calc), .done_div  (done_div),
    .errFlag   (Y_zFlag), .OP_out    (op_wire),    .Hi        (HI),
    .Lo        (LO)
);

full_control_unit fullCU_0(
    .GO        (GO),        .clk       (clk),       .rst       (rst),
    .DoneCalc  (done_calc), .DoneDIV   (done_div),  .Y_zFlag   (Y_zFlag),
    .OP_code   (op_wire),   .x_en      (x_en),      .y_en      (y_en),
    .f_en      (f_en),      .hi_en     (hi_en),     .lo_en     (lo_en),
    .sel_lo    (sel_lo),    .sel_hi    (sel_hi),    .op_calc   (op_calc),
    .sel_p     (sel_p),     .go_calc   (go_calc),   .go_div    (go_div),
    .doneFlag  (done),      .errorFlag (error),     .CS        (CS)
);
endmodule