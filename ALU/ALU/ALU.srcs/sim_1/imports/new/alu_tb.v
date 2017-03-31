`timescale 1ns / 1ps
module alu_tb;

reg [2:0] sel;       	//This hold 3 bits selection for m, s1, s0
reg m_tb, s1_tb, s0_tb;  //This hold 1 bits selector
reg [3:0] A_tb, B_tb;	//This hold 4 bits input
wire [3:0] out_tb;   	//This hold 4 bits output
wire z_tb, ov_tb;     	//This hold check zero and overflow
reg [3:0] expected;  	//This hold for selftest
integer a;      	//This hold selector loop
integer b;      	//This hold input loop
 
ALU DUT(.m(m_tb), .s1(s1_tb), .s0(s0_tb), .A(A_tb), .B(B_tb), .out(out_tb), .z(z_tb), .ov(ov_tb));
initial
begin
  for(a = 0; a < 16; a = a + 1)
	begin
      for(b = 0; b < 16; b = b + 1)
    	begin
      	// Assign bits to m, s1, s0
      	sel = a;
      	#5;
        {m_tb, s1_tb, s0_tb} = sel;
        #5;
        A_tb = a;
        #5;
        B_tb = b;
        #5;
      	if (m_tb == 1'b0) //logic operation
    	    case ({s1_tb, s0_tb})
              2'b00: expected = ~A_tb; //bitwise negation
              2'b01: expected = A_tb & B_tb; //bitwise AND;
              2'b10: expected = A_tb ^ B_tb; //bitwise XOR
              default: expected = A_tb | B_tb; //bitwise OR
            endcase
      	else //arithmetic operation
            case ({s1_tb, s0_tb})
              2'b00: expected = A_tb - 1; // decrement
   	          2'b01: expected = A_tb + B_tb; //addition
              2'b10: expected = A_tb - B_tb; //subtraction
              default: expected = A_tb + 1; // increment
            endcase
          if(out_tb != expected) //error checking
            begin
              $display("Error Out");
              $stop;
            end
    	end 
	end   
  $display("No Error");
  $stop;
end
endmodule