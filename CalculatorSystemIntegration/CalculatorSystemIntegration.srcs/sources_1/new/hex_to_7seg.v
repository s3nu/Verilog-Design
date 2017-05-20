//`timescale 1ns / 1ps
//module hex_to_7seg(
//    input [3:0]HEX, 
//    output reg s0, s1, s2, s3, s4, s5, s6);
//always @ (HEX)
//begin // HEX to 7-segment decoding
//case (HEX) 
//4'b0000: begin s0=0; s1=0; s2=0; s3=1; s4=0; s5=0; s6=0; end
//4'b0001: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=1; end
//4'b0010: begin s0=0; s1=1; s2=0; s3=0; s4=0; s5=1; s6=0; end
//4'b0011: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=1; s6=0; end
//4'b0100: begin s0=1; s1=0; s2=1; s3=0; s4=0; s5=0; s6=1; end
//4'b0101: begin s0=0; s1=0; s2=1; s3=0; s4=1; s5=0; s6=0; end
//4'b0110: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=0; end
//4'b0111: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=0; end
//4'b1000: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
//4'b1001: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=0; s6=0; end
//4'b1010: begin s0=1; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
//4'b1011: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=1; end
//4'b1100: begin s0=0; s1=1; s2=0; s3=1; s4=1; s5=0; s6=0; end
//4'b1101: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=1; s6=1; end
//4'b1110: begin s0=0; s1=1; s2=0; s3=0; s4=1; s5=0; s6=0; end
//4'b1111: begin s0=1; s1=1; s2=0; s3=0; s4=1; s5=0; s6=0; end
//default: begin s0=1; s1=1; s2=1; s3=1; s4=1; s5=1; s6=1; end
//endcase
//end
//endmodule // end hex_to_7seg