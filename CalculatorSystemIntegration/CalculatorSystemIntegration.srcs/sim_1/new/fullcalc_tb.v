`timescale 1ns / 1ps

module calsys_top_level_tb;
    reg        GO, clk, rst;
    reg  [2:0] OP;
    reg  [3:0] in1, in2;
    wire       done, error;
    wire [3:0] LO, HI, CS;

	calsysfull DUT_fc(
		.GO    (GO),
		.clk   (clk),
		.rst   (rst),
		.OP    (OP),
		.in1   (in1),
		.in2   (in2),
		.done  (done),
		.error (error),
		.LO    (LO),
		.HI    (HI),
		.CS    (CS));

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
    GO = 0; OP = 0; in1 = 0; in2 = 0; reset; 
    // GO = 0; OP = 6; in1 = 3; in2 = 2; clock;
    // GO = 1; clock;
    // while((!done) && (!error)) clock;
    // clock; reset;
    for (i=0; i<16; i=i+1) begin
        in1 = i;
        for (j=0; j<16; j=j+1) begin
            in2 = j;
            for (k=0; k<8; k=k+1) begin
                OP = k; GO = 1;
                while((!done) && (!error)) clock;
                case (OP)
                    0: begin
                        if ((i+j) != {HI,LO})  
                        $display("errort");
                    end
                    1: begin
                        actual = in1 - in2;
                        if (actual != {HI,LO})  
                        $display("errort");  
                    end
                    2: begin
                        if ((i&j) != {HI,LO})  
                        $display("errort");
                    end
                    3: begin
                        if ((i^j) != {HI,LO})  
                        $display("errort");
                    end
                    4: begin
                        if (in2 == 0) begin
                            if (!error)  
                            $display("errort");
                        end
                        else begin
                            if ((i/j) != LO || (i%j) != HI)  
                            $display("errort");
                            end
                    end
                    5: begin
                        if ((i*j) != {HI,LO}) 
                       	 $display("error");
                   end
                    6: begin
                        if (i != LO) $display("error");
                    end
                    7: begin
                        if (j != LO) 
                        $display("error");
                    end
                endcase
                clock; 
                reset;
            end
        end 
    end 
    $display("/n/n/nsuccessfull");
    $finish;
end
endmodule
