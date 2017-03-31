// Verilog Code: An Arithmetic Logic Unit (ALU)

module ALU (m, s1, s0, A, B, out, z, ov);
 
input m, s1, s0;       	         //This hold 3 bits selection for m, s1, s0
input [3:0] A, B;      	          //This hold 4 bits input
output reg [3:0] out;  	        //This hold 4 bits output
output reg z, ov;      	//This hold check zero and overflow
 
always @ (m, s1, s0, A, B)
begin
  ov=0;
  if (m == 1'b0)        	//logic operation
	case ({s1, s0})
  	2'b00: out = ~A;  	//bitwise negation
  	2'b01: out = A & B;   //bitwise AND
  	2'b10: out = A ^ B;   //bitwise XOR
  	default: out = A | B; //bitwise OR
	endcase
  else                  	//arithmetic operation
	case ({s1, s0})
  	2'b00:
    	begin
      	out = A - 1;  	// decrement
      	if(A == 0)
        	ov = 1;
    	end 
  	2'b01:
    	begin
      	out = A + B;  	//addition
      	if ((A+B > 15))   // This check overflow
        	ov=1;
    	end 
  	2'b10:
    	begin
      	out = A - B;       	//subtraction
    	end
  	default:
    	begin
      	out = A + 1;       	// increment
      	if ((A+1 > 15))  //check overflow
        	ov=1;
    	end
	endcase
  if (out==0000)
	z=1;    	//set z flag=1 if out==0
  else
	z=0;    	//set z flag=0 if out!==0
end
endmodule