`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2017 05:52:21 AM
// Design Name: 
// Module Name: data_path_tb
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



module DP_tb;

reg [2:0] in1_tb, in2_tb;
reg [1:0] s1_tb, wa_tb, raa_tb, rab_tb, c_tb;
reg we_tb, rea_tb, reb_tb, s2_tb, clk_tb;
wire [2:0] out_tb;
integer a,b,c;

DP DUT (.in1(in1_tb), .in2(in2_tb), .s1(s1_tb), .clk(clk_tb), .wa(wa_tb), .we(we_tb), .raa(raa_tb), .rea(rea_tb), .rab(rab_tb), .reb(reb_tb), .c(c_tb), .s2(s2_tb), .out(out_tb));

initial 
begin
	// 2 bits control signals
	s1_tb=2'b00;
	wa_tb=2'b00;
	raa_tb=2'b00;
	rab_tb=2'b00;
	c_tb=2'b00;
	// 1 bit control signals
	we_tb=1'b0;
	rea_tb=1'b0;
	reb_tb=1'b0;
	s2_tb=1'b1;
	clk_tb=1'b0;
	
	for(a=0;a<8;a=a+1) //2^8
	begin
		for(b=0;b<8;b=b+1)
		begin
			in1_tb=a;
			in2_tb=b;
			
			s1_tb=2'b11;
			wa_tb=2'b01;
			we_tb=1'b1;
			#10 clk_tb=1'b1;
			#10 clk_tb=1'b0;
			//clk is low
			we_tb=1'b0; 
			s1_tb=2'b10;
			wa_tb=2'b10;
			we_tb=1'b1;
			#10 clk_tb=1'b1;
			#10 clk_tb=1'b0;
			// clk low
			we_tb=1'b0;
			raa_tb=2'b01;
			rab_tb=2'b10;
			#10;
			rea_tb=1'b1;
			reb_tb=1'b1;
			for(c=0;c<4;c=c+1)
			begin
				c_tb=c;
				#10;
			
				case(c_tb)
					// +
					2'b00:if(out_tb!=in1_tb+in2_tb) begin
						$display("Output %d does not match %d + %d",out_tb,in1_tb,in2_tb);
						$stop;
					end
					// - 
					2'b01:if(out_tb!=in1_tb-in2_tb)begin
						$display("Output %d does not match %d - %d",out_tb,in1_tb,in2_tb);
						$stop;
					end
					// AND
					2'b10:if(out_tb!=(in1_tb&in2_tb))begin
						$display("Output %d does not match %d AND %d",out_tb,in1_tb,in2_tb);
						$stop;
					end
					// XOR
					default: if(out_tb!=(in1_tb^in2_tb))begin
						$display("Output %d does not match %d XOR %d",out_tb,in1_tb,in2_tb);
						$stop;
					end
				endcase
			end// loop c   
			#10;
			rea_tb = 1'b0;
			reb_tb = 1'b0;
		end// loop b
	end // loop 
$display("sucessfully completeed");
end
endmodule 