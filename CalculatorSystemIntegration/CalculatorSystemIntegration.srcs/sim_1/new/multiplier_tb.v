`timescale 1ns / 1ps
module multiplier_tb;
	reg clk;
	reg [3:0] a, b;
	wire [7:0] out;

	reg rst, en1, en2, en3;

multiplier DUT_multi(
	.aD        (a),
	.bD        (b),
	.clk       (clk),
	.rst       (rst),
	.inEnable  (en1),
	.sEnable   (en2),
	.outEnable (en3),
	.pQ        (out)
);

task clockTrig; begin
	clk = 0; #5; clk = 1; #5; end
endtask

task resetTrig; begin
	rst = 1; #5; rst = 0; #5; end
endtask

integer int_out = 0;

integer i = 0;
integer j = 0;
integer actual = 0;
integer b_old = 0;

reg [7:0] comp1, comp2;

initial begin
	resetTrig;								// Clear regs
	$display("---Simulation Begining---");
	en1 = 1; en2 = 1; en3 = 1;				// Set enables
	
	 $display("---Multiplication Test---");
	 for (i=0; i<16; i=i+1) begin 			// Test a 0000-1111
	 	clockTrig;
	 	a = i; 
	 	clockTrig;
	 	for (j=0; j<16; j=j+1) begin  		// Test b 0000-1111
	 		b = j;
	 		clockTrig;

	 		comp1 = a*(b-2);
	 		comp2 = out;
	 		#2 if (int_out != b_old) begin
	 			$display ("ERROR - a = %d b = %d OUT = %d ACTUAL = %d", a, b, out, actual);
	 			//$stop;
	 		end
	 	end
	 end

	 $display("---Reset Test---");
	 resetTrig;
	 if (out != 0) begin
	 	$display ("RESET: a = %d b = %d OUT = %d ACTUAL = %d", a, b, out, actual);
	 	$stop;
	 end

	 $display("---Enable Test---"); 			// Enables off
	 a = 2;									
	 b = 2;
	 en1 = 0; en2 = 0; en3 = 0;
	 clockTrig;
	 if (out == 4) begin  					// Should still be 225
	 	$display ("RESET: a = %d b = %d OUT = %d ACTUAL = %d", a, b, out, actual);
	 	$stop;
	 end
     $display("---Simulation Complete---");
    $finish;
end
endmodule