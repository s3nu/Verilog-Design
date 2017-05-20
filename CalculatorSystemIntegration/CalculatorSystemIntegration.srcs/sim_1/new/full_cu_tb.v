`timescale 1ns / 1ps

module syscalc_controlunit_tb;
    reg GO, clk, rst;
    reg DoneCalc, DoneDIV, Y_zFlag;
    reg [2:0] OP_code;
    wire x_en, y_en, f_en, hi_en, lo_en;
    wire [1:0] sel_lo, sel_hi, op_calc;
    wire sel_p, go_calc, go_div;
    wire doneFlag, errorFlag;
    wire [3:0] CS;
	reg [14:0] CTRL;
	
	calcsys_control_unit  DUT_cu(
		.GO        (GO),
		.clk       (clk),
		.rst       (rst),
		.DoneCalc  (DoneCalc),
		.DoneDIV   (DoneDIV),
		.Y_zFlag   (Y_zFlag),
		.OP_code   (OP_code),
		.x_en      (x_en),
		.y_en      (y_en),
		.f_en      (f_en),
		.hi_en     (hi_en),
		.lo_en     (lo_en),
		.sel_lo    (sel_lo),
		.sel_hi    (sel_hi),
		.op_calc   (op_calc),
		.sel_p     (sel_p),
		.go_calc   (go_calc),
		.go_div    (go_div),
		.doneFlag  (doneFlag),
		.errorFlag (errorFlag),
		.CS        (CS));

	// f_en, x_en, y_en, go_calc, op_calc, go_div, 
	//    0,    1,    2,       3,       4       5,     
	// sel_p, sel_hi, sel_lo, hi_en, lo_en, doneFlag
	//     6,      7,     8,     9     A    B
	parameter
		IDLE0   = 15'b0_0_0_0_00_0_0_00_00_0_0_0, // State 0
		LOAD0   = 15'b1_1_1_0_00_0_0_00_00_0_0_0, // State 1
		WAIT0   = 15'b0_0_0_0_00_0_0_00_00_0_0_0, // State 2
		CGO0    = 15'b0_0_0_1_00_0_0_00_01_0_0_0, // State 3
		CWAIT0  = 15'b0_0_0_1_00_0_0_01_01_1_1_0, // State 6 
		CWAIT1  = 15'b0_0_0_1_01_0_0_01_01_1_1_0,
		CWAIT2  = 15'b0_0_0_1_10_0_0_01_01_1_1_0,
		CWAIT3  = 15'b0_0_0_1_11_0_0_01_01_1_1_0,
		MWAIT0  = 15'b0_0_0_0_00_0_0_10_10_1_1_0, // State 4
		DIVGO0  = 15'b0_0_0_0_00_1_0_00_11_0_0_0, // State 5
		DWAIT0  = 15'b0_0_0_0_00_1_0_11_11_1_1_0, // State 7	// Part of WAIT state
		PASSA   = 15'b0_0_0_0_00_0_0_00_00_1_1_0, // State 2	// Part of WAIT state
		PASSB   = 15'b0_0_0_0_00_0_1_00_00_1_1_0, 				// Part of WAIT state
		DONE0   = 15'b0_0_0_0_00_0_0_00_00_1_1_1; // State 8	// Part of WAIT state
		 
	task clock; 
	begin
		#5; clk = 1; #5; clk = 0;
	end
	endtask
	
	task reset; 
	begin
		rst = 1; #5; rst = 0; #5; 
	end
	endtask
	
	always @ (*) 
	begin
		CTRL = {f_en, x_en, y_en, go_calc, op_calc, go_div, sel_p, sel_hi, sel_lo, hi_en, lo_en, doneFlag};
	end

initial 
begin
    GO = 0; Y_zFlag = 0; DoneCalc = 0; DoneDIV = 0; OP_code = 0;
    reset; clock;
    // STATE 0 - IDLE TEST
    if (CTRL != IDLE0) 
    	$display("error exception");
        Y_zFlag = 1; clock;
        if ((CTRL != IDLE0) || (errorFlag != 1))
        	$display("error exception");
        Y_zFlag = 0; clock;
        if (CTRL != IDLE0) 
        	$display("error exception"); 
        	
    GO = 1; clock;
    if (CTRL != LOAD0)     // STATE 1 - LOAD TEST
    	$display("error exception"); 
    	clock;
    if (CTRL != WAIT0)     // STATE 2 - WAIT TEST
		$display("error exception");
		OP_code = 0; clock; // STATE 3 - SMALL CALC TEST
		if (CTRL != CGO0) // ADD Test
			$display("error exception");
			DoneCalc = 0; clock;
			if (CTRL != CWAIT0) // State 6 - Calc wait Test
				$display("error exception");
				DoneCalc = 1; clock;
				if (CTRL != DONE0) 
					$display("error exception");
					reset; DoneCalc = 0; clock; clock;
		OP_code = 1; clock;
		if (CTRL != CGO0) // SUB Test
			$display("error exception"); 
			DoneCalc = 0; clock;
			if (CTRL != CWAIT1) // State 6 - Calc wait Test
				$display("error exception");
				DoneCalc = 1; clock;
				if (CTRL != DONE0) 
					$display("error exception");
					reset; DoneCalc = 0; clock; clock;
            OP_code = 2; clock;
            if (CTRL != CGO0) // AND Test
            	$display("error exception");
                DoneCalc = 0; clock;
                if (CTRL != CWAIT2) // State 6 - Calc wait Test
                	$display("error exception");
                    DoneCalc = 1; clock;
                    if (CTRL != DONE0) // State 8 Test - From Small Calc
                    	$display("error exception");
                    	reset; DoneCalc = 0; clock; clock;
            OP_code = 3; clock;
            if (CTRL != CGO0) // XOR Test
            	$display("error exception"); 
                DoneCalc = 0; clock;
                if (CTRL != CWAIT3) // State 6 - Calc wait Test
                	$display("error exception");
                    DoneCalc = 1; clock;
                    if (CTRL != DONE0)   // State 8 Test - From Small Calc
                    	$display("error exception");
                    	reset; DoneCalc = 0; clock; clock;
        OP_code = 3'b101; clock;
        if (CTRL != MWAIT0) // STATE 4 - MULTIPLIER TEST
        	$display("error exception");
        	clock; clock;
            clock;
            if (CTRL != DONE0) // State 8 - From multiplier
            	$display("error exception");
            	reset; clock; clock;
        OP_code = 3'b100; clock;
        if (CTRL != DIVGO0) // STATE 5 - DIVISION TEST
        	$display("error exception");
            DoneDIV = 0; clock;
            if (CTRL != DWAIT0) // State 7 - Division wait test
            	$display("error exception");
                DoneDIV = 1; clock;
                if (CTRL != DONE0) // State 8 test - from divider
                	$display("error exception");
                	reset; DoneDIV = 0; clock;
    OP_code = 3'b110; 
    clock;
    if (CTRL != PASSA) // State 3 Test - Pass through A input
    	$display("error exception");
        clock;
        if (CTRL != DONE0)  // State 8 - Pass A test
        	$display("error exception");
        	reset; clock;
    OP_code = 3'b111; clock;
    if (CTRL != PASSB)   // State 3 Test - Pass through B input
    	$display("error exception");
        clock;
        if (CTRL != DONE0)  // State 8 - Pass B test
        	$display("error exception");

    $display("successfull");
    $finish;
end
endmodule