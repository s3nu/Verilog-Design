`timescale 1ns / 1ps

module calcsys_datapath_tb;
reg  [3:0] X, Y;
reg  [2:0] OP_in;
reg        clk, rst;
reg        x_en, y_en, f_en;
reg        hi_en, lo_en;
reg  [1:0] sel_lo, sel_hi, op_calc;
reg        go_calc, go_div, sel_p;
wire       done_calc, done_div, errFlag;
wire [2:0] OP_out;
wire [3:0] Hi, Lo;

calcsys_datapath DUT_dp(
	.X         (X),
	.Y         (Y),
	.OP_in     (OP_in),
	.clk       (clk),
	.rst       (rst),
	.x_en      (x_en),
	.y_en      (y_en),
	.f_en      (f_en),
	.hi_en     (hi_en),
	.lo_en     (lo_en),
	.sel_hi    (sel_hi),
	.sel_p     (sel_p),
	.sel_lo    (sel_lo),
	.op_calc   (op_calc),
	.go_calc   (go_calc),
	.go_div    (go_div),
	.done_calc (done_calc),
	.done_div  (done_div),
	.OP_out    (OP_out),
	.errFlag   (errFlag),
	.Hi        (Hi),
	.Lo        (Lo));
reg [13:0] CTRL;
	// f_en, x_en, y_en, go_calc, op_calc, go_div, sel_p, sel_hi, sel_lo, hi_en, lo_en, done
	//    0,    1,    2,       3,       4       5,     6       7,     8,     9     A    B
	parameter
				//    0_1_2_3__4_5_6__7__8_9_A
		IDLE    = 14'b0_0_0_0_00_0_0_00_00_0_0, // State 0
		LOAD    = 14'b1_1_1_0_00_0_0_00_00_0_0, // State 1
		WAIT    = 14'b0_0_0_0_00_0_0_00_00_0_0, // State 2
		CGO     = 14'b0_0_0_1_00_0_0_00_01_0_0, // State 3
		CWAIT0  = 14'b0_0_0_1_00_0_0_01_01_1_1, // State 6 
		CWAIT1  = 14'b0_0_0_1_01_0_0_01_01_1_1,
		CWAIT2  = 14'b0_0_0_1_10_0_0_01_01_1_1,
		CWAIT3  = 14'b0_0_0_1_11_0_0_01_01_1_1,
		MWAIT   = 14'b0_0_0_0_00_0_0_10_10_1_1, // State 4
		DIVGO   = 14'b0_0_0_0_00_1_0_00_11_0_0, // State 5
		DWAIT0  = 14'b0_0_0_0_00_1_0_11_11_1_1, // State 7 		// Part of WAIT state
		PASS0   = 14'b0_0_0_0_00_0_0_00_00_1_1, // State 2		// Part of WAIT state
		PASS1   = 14'b0_0_0_0_00_0_1_00_00_1_1, 				// Part of WAIT state
		DONE    = 14'b0_0_0_0_00_0_0_00_00_1_1; // State 8		// Part of WAIT state
				//    0_1_2_3__4_5_6_7__8_9_A
				
	always @ (CTRL) begin
	{f_en, x_en, y_en, go_calc, op_calc, go_div, sel_p, sel_hi, sel_lo, hi_en, lo_en} = CTRL;
	end

	task clock; 
	begin
		clk = 1; #5; clk = 0; #5; 
	end
	endtask
	
	task reset; 
	begin
		rst = 1; #5; rst = 0; #5; 
	end
	endtask

	integer i = 0;
	integer j = 0;
	integer k = 0;
	reg [4:0] actual;
initial 
begin
X = 12; Y = 12; CTRL = IDLE; reset; clock;
reset;
for (i=0; i<16; i=i+1) begin            // Set X input 
	X = i;
	for (j=0; j<16; j=j+1) begin        // Sey Y input
	Y = j;
	for (k=0; k<8; k=k+1) begin     // Set OP code input
		OP_in = k;
		CTRL = IDLE; clock;
		CTRL = LOAD; clock;
		if (OP_in < 6) begin
			CTRL = WAIT; clock;
			case (OP_in)
			3'b000:	begin                   // ADD
					CTRL = CGO; clock;
					CTRL = CWAIT0; clock;
					while (!done_calc) clock; 
					CTRL = DONE; clock; 
					if ((i+j) != {Hi,Lo}) $display("error7");
					end
			3'b001:	begin                   // SUB
					actual = i-j;
					CTRL = WAIT; clock;
					CTRL = CGO; clock;
					CTRL = CWAIT1; clock;
					while (!done_calc) clock;
					CTRL = DONE; clock; 
					if (actual != {Hi,Lo}) $display("error6");
					end
			3'b010:	begin                   // AND
					CTRL = WAIT; clock;
					CTRL = CGO; clock;
					CTRL = CWAIT2; clock;
					while (!done_calc) clock; CTRL = DONE; clock; 
					if ((i&j) != {Hi,Lo}) $display("error5");
					end 
			3'b011:	begin                   // XOR
					CTRL = WAIT; clock;
					CTRL = CGO; clock;
					CTRL = CWAIT3; clock;
					while (!done_calc) clock; 
					CTRL = DONE; clock; 
					if ((i^j) != {Hi,Lo}) $display("error4");
					end 
			3'b100: begin                   // DIVIDE
					CTRL = DIVGO; clock;
					CTRL = DWAIT0; clock;
					while((!done_div) && (!errFlag)) clock; 
					CTRL = DONE; clock; 
					if (Y == 0)	begin
						if (!errFlag) $display("error3");
					end else begin 
							if (((i/j) != Lo)|| ((i%j) != Hi)) $display("error2");
						 	 end
					 end 
			3'b101: begin                   // MULTIPLY
					CTRL = MWAIT; clock;
					clock; // Run MWAIT for 2 clock cycles
					CTRL = DONE; clock; 
					if ((i*j) != {Hi,Lo}) $display("\n\n\nerror1\n\n\n");
					end
			endcase
		end else if (OP_in == 6) begin          // Pass A input
			CTRL = PASS0; clock;
			CTRL = DONE; clock; 
			if (i != Lo) $display("error\n\n\n");
		end else begin                          // Pass B input
				CTRL = PASS1; clock;
				CTRL = DONE; clock; 
				if (j != Lo) $display("error\n\n\n");
				 end 
		reset;
		end 
	end
	end
	$display("succesfully done");
	$finish;
end
endmodule 

