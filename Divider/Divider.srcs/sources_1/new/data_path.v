`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name: data_path
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

//Data_PATH
module data_path(
	input clk, rst, 
	input Yen, Xen, Ren,        // Register/counter enables/loads
	input X_sL, Xshiftbit, RsL, RsR,// Shift reg ctrl bits
	input s1, s2, s3,           // mux selectors
	input load_cnt, ud, Cen,    // Up/Down counter ctrl
	input [3:0] X_in, Y_in,     // Divident, Divisor
	input [2:0] n,              // Counter input

	output [3:0] R, Q,          // Remainder, Quotient
	output R_lt_Y, cnt_out,     // CU flags
    output zeroerror              // Divide by zero flag
    );
	wire [3:0] X_out, Y_out;
	wire [4:0] subOut, R_in, R_out;
	wire x3;
	mux2   #(5) m0(.A(subOut), .B(5'b00000), .sel(s1), .out(R_in));
	mux2   #(4) m1(.A(R_out[3:0]), .B(4'b0000), .sel(s2), .out(R));
	mux2   #(4) m2(.A(X_out), .B(4'b0000), .sel(s3), .out(Q));
	y_reg       y0(.clk(clk), .rst(rst), .en(Yen), .D(Y_in), .Q(Y_out),.zeroflag(zeroerror));
	x_reg       x0(.clk(clk), .rst(rst), .LD(Xen), .sL(X_sL),.shiftbit(Xshiftbit), .D(X_in), .Q(X_out), .msb(x3));
	r_reg       r0(.clk(clk), .rst(rst), .LD(Ren), .sL(RsL),.sR(RsR), .shiftbit(x3), .D(R_in), .Q(R_out));
	comparator  c0(.A(R_out[3:0]), .B(Y_out), .out(R_lt_Y));
	sub         s0(.A(R_out), .B({1'b0,Y_out}), .out(subOut));
	ud_counter  u0(.clk(clk), .rst(rst), .ce(Cen),.ld(load_cnt), .ud(ud), .D(cnt_out), .zeroflag(cnt_out));
endmodule

//universal mux
module mux2 #(parameter WIDTH = 4) (
	input [WIDTH-1:0] A, B,
	input sel,
	output reg [WIDTH-1:0] out);
	always @(*) 
	begin
		if (sel) 
		begin
			out = B;
		end
		else
		begin
			out = A;
		end
	end
endmodule

module x_reg(
	input clk, rst, LD, sL, shiftbit,
	input [3:0] D,
	output reg [3:0] Q,
	output reg msb
	);
	wire [3:0] out;
	assign out = Q;
	always @(posedge clk, posedge rst) 
	begin
		if (rst)
		begin
			Q <= 4'b0000;//rst
		end          
		else if (LD)
		begin
  			Q <= D;
  		end            
		else if (sL) 
		begin
			if (shiftbit) 
			begin
				Q <= {out[2:0], 1'b1};
			end
			else
			begin
				Q <= {out[2:0], 1'b0};
			end
		end
		else
		begin
			Q <= out;//holder
		end
	
	end
	always @(Q) 
	begin
		msb = out[3];
	end
endmodule

module y_reg(
	input clk, rst, en,
	input [3:0] D,
	output reg [3:0] Q,
    output reg zeroflag
	);
	always @(posedge clk, posedge rst) 
	begin
		if (rst) 
		begin
			Q <= 0;//rst
		end
		else if (en) 
		begin
			Q <= D;
		end
		else
		begin         
			Q <= Q;
		end
	end
	
	always @(Q) 
	begin
		if (Q == 0) 
		begin
			zeroflag = 1;
		end
		else
		begin
			zeroflag = 0;
		end
	end
endmodule

module r_reg(
	input clk, rst, LD, sL, sR, shiftbit,
	input [4:0] D,
	output reg [4:0] Q);
	wire [4:0] out;
	assign out = Q;
	always @(posedge clk, posedge rst) 
	begin
		if (rst)     Q <= 5'b00000;  
		else if (LD) Q <= D;      
		else if (sL) Q <= {out[3:0], shiftbit};
		else if (sR) Q <= {1'b0, out[4:1]}; 
		else         Q <= out;           
	end
endmodule

module ud_counter(
	input clk, rst, ce, ld, ud,
	input [2:0] D,
	output reg zeroflag);
	
	reg [2:0] Q;
	always @(posedge clk, posedge rst) 
	begin
		if (rst)
		begin
			Q <= 0;
		end
		else if (ce) 
		begin
			if (ld) 
			begin
				Q <= D;
			end
			else 
			begin    
				case (ud)
					0: Q <= Q-1;
					1: Q <= Q+1;
				endcase
			end
		end
		else 
		begin
			Q <= Q;
		end
	end
	always @(Q) 
	begin
		if (Q==3'b000)
		begin
			zeroflag = 1;
		end
		else 
		begin
			zeroflag = 0;
		end
	end
endmodule

module comparator(
	input [3:0] A, B,
	output reg out);
	always @(*) 
	begin
		if (A<B) 
		begin
			out = 1;
		end
		else
		begin
			out = 0;
		end
	end
endmodule

module sub(
	input [4:0] A, B,
	output reg [4:0] out
	);
	always @(*) 
	begin
		out = A-B;
	end
endmodule
