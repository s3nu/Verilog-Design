`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2017 02:11:14 PM
// Design Name: 
// Module Name: calculator_tb
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


module calculator_tb();
	reg go, clk;
	reg [1:0] op;
	reg [2:0] in1, in2;
	wire [3:0] cs;
	wire done;
	wire [2:0] out;
	reg [2:0] expected;
	integer i, j, k;
	
	calculator DUT(.go(go), .clk(clk), .op(op), .in1(in1), .in2(in2), .cs(cs), .done(done), .out(out));        
	task cycle;
	   begin
		   clk=0;
		   #5;
		   clk=1;
		   #5;
	   end
	endtask
initial
begin
	go=1;
	for(i=0; i<4; i=i+1)
	begin
		op=i;
		for(j=0; j<8; j=j+1)
		begin
			in1=j;
			for(k=0; k<8; k=k+1)
			begin
				in2=k;
				cycle; $display("State %d", cs);
				cycle; $display("State %d", cs);
				cycle; $display("State %d", cs);
				case(op)
					2'b00:  expected = in1 + in2;   
					2'b01:  expected = in1 - in2;   
					2'b10:  expected = in1 & in2;   
					default:  expected = in1 ^ in2; // 2'b11;
				endcase
				if(out!=expected)
				begin
					$display ("error");
					$stop;
				end     
			end
		end
	end
end
endmodule
