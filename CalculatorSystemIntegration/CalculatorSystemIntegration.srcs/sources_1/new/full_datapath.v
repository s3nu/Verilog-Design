`timescale 1ns / 1ps

module calcsys_datapath(
    input   [3:0] X, Y,
    input   [2:0] OP_in,
    input   clk, rst,
    input   x_en, y_en, f_en, hi_en, lo_en,
    input   [1:0] sel_lo, sel_hi, op_calc,
    input   sel_p, go_calc, go_div,
    output  done_calc, done_div, errFlag, 
    output  [2:0] OP_out,
    output  [3:0] Hi, Lo);
	
	wire [3:0] x_out, y_out, pass_out;
	wire [4:0] smCalc_out;
	wire [3:0] multi_outHI, multi_outLO;
	wire [3:0] div_Quotient, div_remainder;
	wire [3:0] mux_LO_out, mux_HI_out;
	wire [3:0] cs_calc, cs_div;
	wire div_error;
	
	err_comparator eFlag0(.OP_check(OP_in), .A(Y), .B(1), .out(errFlag));
	d_reg #(3) f0dreg(.clk(clk), .rst(rst), .en(f_en), .d(OP_in), .q(OP_out));
	d_reg #(4) x0dreg(.clk(clk), .rst(rst), .en(x_en), .d(X), .q(x_out));
	d_reg #(4) y0dreg(.clk(clk), .rst(rst), .en(y_en), .d(Y), .q(y_out));
	small_calc smCalc0(.GO(go_calc),.clk(clk), .rst(rst),.OP(op_calc),.in1(x_out),.in2(y_out),.doneFlag(done_calc),.CurrentState (cs_calc),.out(smCalc_out));
	multiplier multi0(.aD(x_out), .bD(y_out), .clk(clk), .rst(rst), .inEnable(1'b1), .sEnable(1'b1), .outEnable(1'b1), .pQ({multi_outHI[3:0],multi_outLO[3:0]}));
	divider div0(.clk       (clk),.rst       (rst),.GO        (go_div),.dividend  (x_out),.divisor   (y_out),.done      (done_div),.error     (div_error),.quotient  (div_Quotient),.remainder (div_remainder),.CS        (cs_div));
	mux2 #(4) pass_mux1(.A      (x_out), .B      (y_out), .sel    (sel_p), .out    (pass_out));
	MUX1 mux1_LO(.in1    (pass_out), .in2    (smCalc_out[3:0]), .in3    (multi_outLO), .in4    (div_Quotient), .s1     (sel_lo), .m1out  (mux_LO_out));
	MUX1 mux1_HI(.in1    (4'b0000), .in2    ({3'b000,smCalc_out[4]}), .in3    (multi_outHI), .in4    (div_remainder), .s1     (sel_hi), .m1out  (mux_HI_out));
	d_reg #(4) outHI_reg(.clk(clk), .rst(rst), .en(hi_en), .d(mux_HI_out), .q(Hi));
	d_reg #(4) outLO_reg(.clk(clk), .rst(rst), .en(lo_en), .d(mux_LO_out), .q(Lo));
endmodule

module err_comparator(
    input [2:0] OP_check,
    input [3:0] A, B,
    output reg out);
always @(*) begin
    if (OP_check == 3'b100) begin
        if (A<B) out = 1;
        else     out = 0;
    end
    else out = 0;
end
endmodule